#!/bin/sh
set -eu

BUILD="${BUILD:-build}"
OUT="$BUILD/memory-report.txt"
fail(){ printf 'ANALYZE FAIL: %s\n' "$*" >&2; exit 1; }

mkdir -p "$BUILD"

for tool in avr-size avr-nm; do
    command -v "$tool" >/dev/null 2>&1 || fail "missing tool: $tool"
done

: > "$OUT"
printf '%s\n' "EduAVR memory analysis report" >> "$OUT"
printf '%s\n' "Target: ATmega1284P" >> "$OUT"
printf '%s\n' "" >> "$OUT"

for elf in "$BUILD"/optimization-c-o0.elf "$BUILD"/optimization-c-os.elf "$BUILD"/optimization-c-o2.elf "$BUILD"/optimization-asm.elf "$BUILD"/resource-budget-c.elf "$BUILD"/resource-budget-asm.elf; do
    test -f "$elf" || fail "missing ELF: $elf"
    printf '%s\n' "=== $elf ===" >> "$OUT"
    avr-size -A "$elf" >> "$OUT"
    printf '%s\n' "" >> "$OUT"
done

for elf in "$BUILD"/optimization-c-o0.elf "$BUILD"/optimization-c-os.elf "$BUILD"/optimization-c-o2.elf "$BUILD"/optimization-asm.elf; do
    printf '%s\n' "=== budget summary: $elf ===" >> "$OUT"
    text_size=$(avr-size -A "$elf" | awk '$1==".text"{print $2}')
    rodata_size=$(avr-size -A "$elf" | awk '$1==".rodata"{print $2}')
    data_size=$(avr-size -A "$elf" | awk '$1==".data"{print $2}')
    bss_size=$(avr-size -A "$elf" | awk '$1==".bss"{print $2}')
    text_size=${text_size:-0}; rodata_size=${rodata_size:-0}; data_size=${data_size:-0}; bss_size=${bss_size:-0}
    flash=$((text_size + rodata_size + data_size))
    static_sram=$((data_size + bss_size))
    printf 'text=%s rodata=%s data=%s bss=%s flash_image=%s static_sram=%s\n' "$text_size" "$rodata_size" "$data_size" "$bss_size" "$flash" "$static_sram" >> "$OUT"
    printf '%s\n' "" >> "$OUT"
done

printf '%s\n' "=== resource-budget symbols ===" >> "$OUT"
avr-nm -S --size-sort "$BUILD/resource-budget-c.elf" | tail -20 >> "$OUT"
printf '%s\n' "" >> "$OUT"
printf '%s\n' "Dynamic stack depth is a separate runtime measurement; this report does not claim a worst-case stack bound." >> "$OUT"

printf '%s\n' "ANALYZE PASS: $OUT"
