#!/bin/sh
set -eu
fail(){ printf 'CAPSTONE Q1 FAIL: %s\n' "$*" >&2; exit 1; }

for elf in build/capstone-c.elf build/capstone-asm.elf; do
    test -f "$elf" || fail "missing $elf"
    set +e
    timeout 3s simavr -m atmega1284p -f 8000000 "$elf" >"$elf.capstone.sim.log" 2>&1
    rc=$?
    set -e
    test "$rc" -eq 124 || { cat "$elf.capstone.sim.log" >&2; fail "simavr did not run indefinitely for $elf (rc=$rc)"; }
done

probe(){
    elf="$1"; log="$elf.capstone.gdb.log"
    simavr -m atmega1284p -f 8000000 -g "$elf" >"$elf.capstone.gdb.sim.log" 2>&1 &
    pid=$!
    trap 'kill "$pid" 2>/dev/null || true' EXIT INT TERM
    sleep 1
    set +e
    timeout 12s avr-gdb -q -batch "$elf"       -ex "target remote :1234"       -ex "break capstone_ready"       -ex "continue"       -ex "p/x *(unsigned short*)&capstone_adc"       -ex "p/x *(unsigned char*)&capstone_calibration"       -ex "p/x *(unsigned short*)&capstone_value"       -ex "p/x *(unsigned short*)&capstone_ticks"       -ex "p/x *(unsigned char*)&capstone_eeprom"       -ex "p/x *(unsigned char*)&capstone_uart_ready"       -ex "quit" >"$log" 2>&1
    rc=$?
    set -e
    kill "$pid" 2>/dev/null || true
    wait "$pid" 2>/dev/null || true
    trap - EXIT INT TERM
    test "$rc" -eq 0 || { cat "$log" >&2; fail "GDB probe failed for $elf"; }

    values=$(awk '/^[$][0-9]+ = 0x/ { sub(/^.*= /, ""); print }' "$log")
    set -- $values
    test "$#" -ge 6 || { cat "$log" >&2; fail "missing capstone probe values for $elf"; }

    adc=$1; cal=$2; value=$3; ticks=$4; eeprom=$5; uart=$6
    test "$cal" = "0x5a" || fail "calibration mismatch in $elf: $cal"
    test "$eeprom" = "0x5a" || fail "EEPROM readback mismatch in $elf: $eeprom"
    test "$uart" = "0x1" || fail "USART initialization marker missing in $elf: $uart"
    test "$ticks" != "0x0" || fail "Timer0 ISR did not advance in $elf"
    adc_dec=$(printf "%d" "$adc")
    value_dec=$(printf "%d" "$value")
    test "$value_dec" -eq $((adc_dec + 90)) || fail "ADC+calibration result mismatch in $elf: adc=$adc value=$value"
}
probe build/capstone-c.elf
probe build/capstone-asm.elf
printf '%s\n' "CAPSTONE Q1 PASS: timer + ADC + EEPROM + USART integration is observable in C and Assembly"
