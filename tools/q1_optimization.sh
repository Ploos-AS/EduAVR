#!/bin/sh
set -eu
fail(){ printf 'Q1 FAIL: %s\n' "$*" >&2; exit 1; }
for elf in build/optimization-c-o0.elf build/optimization-c-os.elf build/optimization-c-o2.elf build/optimization-asm.elf; do test -f "$elf" || fail "missing optimization ELF: $elf"; done
probe_result(){
 elf="$1"; log="$elf.optimization.gdb.log"
 simavr -m atmega1284p -f 8000000 -g "$elf" >"$elf.optimization.sim.log" 2>&1 & sim_pid=$!
 trap 'kill "$sim_pid" 2>/dev/null || true' EXIT INT TERM; sleep 1
 set +e
 timeout 10s avr-gdb -q -batch "$elf" -ex "target remote :1234" -ex "break optimization_ready" -ex "continue" -ex "p/x *(unsigned short*)&opt_result" -ex "quit" >"$log" 2>&1
 rc=$?; set -e
 kill "$sim_pid" 2>/dev/null || true; wait "$sim_pid" 2>/dev/null || true; trap - EXIT INT TERM
 test "$rc" -eq 0 || { cat "$log" >&2; fail "GDB optimization probe failed for $elf"; }
 value=$(awk '/^[$][0-9]+ = 0x/ { sub(/^.*= /, ""); print; exit }' "$log")
 test "$value" = "0x3f8" || fail "unexpected weighted sum in $elf: $value"
}
probe_result build/optimization-c-o0.elf
probe_result build/optimization-c-os.elf
probe_result build/optimization-c-o2.elf
probe_result build/optimization-asm.elf
for elf in build/optimization-c-o0.elf build/optimization-c-os.elf build/optimization-c-o2.elf build/optimization-asm.elf; do avr-size -A "$elf" | awk '/\.text[[:space:]]/ { found=1 } END { exit(found ? 0 : 1) }' || fail "could not inspect .text size in $elf"; done
printf '%s\n' "Q1 PASS: optimization variants preserve the required result"
