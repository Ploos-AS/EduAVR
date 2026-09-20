#!/bin/sh
set -eu

BUILD="${BUILD:-build}"
POLICY="tools/resource-policy.env"
fail(){ printf 'RESOURCE GATE FAIL: %s\n' "$*" >&2; exit 1; }

test -f "$POLICY" || fail "missing $POLICY"
. "$POLICY"

for tool in avr-size avr-nm; do command -v "$tool" >/dev/null 2>&1 || fail "missing tool: $tool"; done

check_elf(){
    elf="$1"
    flash=$(avr-size -A "$elf" | awk '
      $1==".text" {t=$2}
      $1==".rodata" {r=$2}
      $1==".data" {d=$2}
      END {print (t+0)+(r+0)+(d+0)}')
    sram=$(avr-size -A "$elf" | awk '
      $1==".data" {d=$2}
      $1==".bss" {b=$2}
      END {print (d+0)+(b+0)}')
    test "$flash" -le "$FLASH_GUARD_BYTES" ||
      fail "$elf Flash image $flash exceeds guard $FLASH_GUARD_BYTES"
    test "$sram" -le "$STATIC_SRAM_GUARD_BYTES" ||
      fail "$elf static SRAM $sram exceeds guard $STATIC_SRAM_GUARD_BYTES"
    printf 'RESOURCE PASS: %s flash=%s static_sram=%s\n' "$elf" "$flash" "$sram"
}

found=0
for elf in "$BUILD"/*.elf; do
    test -f "$elf" || continue
    found=1
    check_elf "$elf"
done
test "$found" -eq 1 || fail "no ELF files found in $BUILD"

for elf in "$BUILD"/resource-budget-c.elf "$BUILD"/resource-budget-asm.elf; do
    test -f "$elf" || fail "missing resource-budget ELF: $elf"
    static=$(avr-nm -S --size-sort "$elf" |
      awk '$NF=="budget_static" {print $2; exit}')
    test -n "$static" || fail "budget_static symbol missing from $elf"
    static_dec=$((16#$static))
    test "$static_dec" -le "$RESOURCE_BUDGET_STATIC_SRAM_GUARD_BYTES" ||
      fail "$elf budget_static=$static_dec exceeds guard $RESOURCE_BUDGET_STATIC_SRAM_GUARD_BYTES"
done

printf '%s\n' "RESOURCE GATE PASS: all educational ELF guardrails satisfied"
