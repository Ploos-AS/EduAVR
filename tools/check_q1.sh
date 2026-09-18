#!/bin/sh
set -eu

fail() {
    printf 'Q1 FAIL: %s\n' "$*" >&2
    exit 1
}

for tool in avr-gcc avr-gdb avr-objdump simavr timeout; do
    command -v "$tool" >/dev/null 2>&1 || fail "missing tool: $tool"
done

make clean all disasm

simavr --list-cores | grep -Eqi 'atmega1284|atmega1284p' ||
    fail "simavr does not advertise ATmega1284(P) support"

# A firmware that enters its endless main loop is expected not to exit by itself.
# timeout therefore treats 124 as the expected result. Any crash/loader error fails.
run_sim() {
    elf="$1"
    set +e
    timeout 2s simavr -m atmega1284p -f 8000000 "$elf" >"$elf.sim.log" 2>&1
    rc=$?
    set -e
    case "$rc" in
        124) ;;
        0) fail "simulated firmware exited unexpectedly: $elf" ;;
        *) cat "$elf.sim.log" >&2; fail "simavr failed for $elf (rc=$rc)" ;;
    esac
}

run_sim build/blink-c.elf
run_sim build/blink-asm.elf
run_sim build/timer-isr-c.elf
run_sim build/timer-isr-asm.elf
run_sim build/pwm-c.elf
run_sim build/pwm-asm.elf
run_sim build/usart0-echo-c.elf
run_sim build/usart0-echo-asm.elf

# Confirm GDB can read both AVR ELF files and their symbols non-interactively.
for elf in build/blink-c.elf build/blink-asm.elf build/timer-isr-c.elf build/timer-isr-asm.elf build/pwm-c.elf build/pwm-asm.elf build/usart0-echo-c.elf build/usart0-echo-asm.elf; do
    avr-gdb -q -batch         -ex "file $elf"         -ex "info files" >"$elf.gdb.log" 2>&1 ||
        { cat "$elf.gdb.log" >&2; fail "avr-gdb could not inspect $elf"; }
    grep -q "Symbols from" "$elf.gdb.log" ||
        fail "avr-gdb did not load symbols from $elf"
done

probe_timer_irq() {
    elf="$1"
    log="$elf.irq.gdb.log"

    simavr -m atmega1284p -f 8000000 -g "$elf" >"$elf.irq.sim.log" 2>&1 &
    sim_pid=$!
    trap 'kill "$sim_pid" 2>/dev/null || true' EXIT INT TERM
    sleep 1

    set +e
    timeout 10s avr-gdb -q -batch "$elf" \
        -ex "target remote :1234" \
        -ex "break timer0_compa_probe" \
        -ex "continue" \
        -ex "info registers pc sp sreg" \
        -ex "detach" >"$log" 2>&1
    rc=$?
    set -e

    kill "$sim_pid" 2>/dev/null || true
    wait "$sim_pid" 2>/dev/null || true
    trap - EXIT INT TERM

    test "$rc" -eq 0 || { cat "$log" >&2; fail "GDB timer IRQ probe failed for $elf"; }
    grep -q "Breakpoint .*timer0_compa_probe" "$log" ||
        { cat "$log" >&2; fail "Timer0 compare ISR was not reached in $elf"; }
}

probe_timer_irq build/timer-isr-c.elf
probe_timer_irq build/timer-isr-asm.elf


probe_pwm_config() {
    elf="$1"
    log="$elf.pwm.gdb.log"

    simavr -m atmega1284p -f 8000000 -g "$elf" >"$elf.pwm.sim.log" 2>&1 &
    sim_pid=$!
    trap 'kill "$sim_pid" 2>/dev/null || true' EXIT INT TERM
    sleep 1

    set +e
    timeout 10s avr-gdb -q -batch "$elf" \
        -ex "target remote :1234" \
        -ex "break loop" \
        -ex "continue" \
        -ex "p/x *(unsigned char*)0x24" \
        -ex "p/x *(unsigned char*)0x44" \
        -ex "p/x *(unsigned char*)0x45" \
        -ex "p/x *(unsigned char*)0x47" \
        -ex "detach" >"$log" 2>&1
    rc=$?
    set -e

    kill "$sim_pid" 2>/dev/null || true
    wait "$sim_pid" 2>/dev/null || true
    trap - EXIT INT TERM

    test "$rc" -eq 0 || { cat "$log" >&2; fail "GDB PWM probe failed for $elf"; }

    # ATmega1284P data-space addresses:
    # DDRB=0x24 -> PB3 output => bit 3 set
    # TCCR0A=0x44 -> COM0A1|WGM01|WGM00 = 0x83
    # TCCR0B=0x45 -> CS01|CS00 = 0x03
    # OCR0A=0x47 -> 63 = 0x3f
    values=$(grep -E '^\\$[0-9]+ = 0x' "$log" | sed 's/.*= //')
    set -- $values
    test "$#" -ge 4 || { cat "$log" >&2; fail "could not read PWM registers from $elf"; }
    ddrb=$1; tccr0a=$2; tccr0b=$3; ocr0a=$4

    case "$ddrb" in
        0x8|0x08|0x9|0x09|0xa|0x0a|0xb|0x0b|0xc|0x0c|0xd|0x0d|0xe|0x0e|0xf|0x0f) ;;
        *) fail "PB3 not configured as output in $elf (DDRB=$ddrb)" ;;
    esac
    test "$tccr0a" = "0x83" || fail "unexpected TCCR0A in $elf: $tccr0a"
    test "$tccr0b" = "0x3" || test "$tccr0b" = "0x03" || fail "unexpected TCCR0B in $elf: $tccr0b"
    test "$ocr0a" = "0x3f" || fail "unexpected OCR0A in $elf: $ocr0a"
}

probe_pwm_config build/pwm-c.elf
probe_pwm_config build/pwm-asm.elf


probe_usart0_config() {
    elf="$1"
    log="$elf.usart.gdb.log"

    simavr -m atmega1284p -f 8000000 -g "$elf" >"$elf.usart.sim.log" 2>&1 &
    sim_pid=$!
    trap 'kill "$sim_pid" 2>/dev/null || true' EXIT INT TERM
    sleep 1

    set +e
    timeout 10s avr-gdb -q -batch "$elf" \
        -ex "target remote :1234" \
        -ex "break echo_loop" \
        -ex "continue" \
        -ex "p/x *(unsigned char*)0xc5" \
        -ex "p/x *(unsigned char*)0xc4" \
        -ex "p/x *(unsigned char*)0xc0" \
        -ex "p/x *(unsigned char*)0xc1" \
        -ex "p/x *(unsigned char*)0xc2" \
        -ex "detach" >"$log" 2>&1
    rc=$?
    set -e

    kill "$sim_pid" 2>/dev/null || true
    wait "$sim_pid" 2>/dev/null || true
    trap - EXIT INT TERM

    test "$rc" -eq 0 || { cat "$log" >&2; fail "GDB USART0 probe failed for $elf"; }

    values=$(grep -E '^\\$[0-9]+ = 0x' "$log" | sed 's/.*= //')
    set -- $values
    test "$#" -ge 5 || { cat "$log" >&2; fail "could not read USART0 registers from $elf"; }

    ubrr0h=$1; ubrr0l=$2; ucsr0a=$3; ucsr0b=$4; ucsr0c=$5

    test "$ubrr0h" = "0x0" || test "$ubrr0h" = "0x00" ||
        fail "unexpected UBRR0H in $elf: $ubrr0h"
    test "$ubrr0l" = "0x33" ||
        fail "unexpected UBRR0L in $elf: $ubrr0l"
    test "$ucsr0b" = "0x18" ||
        fail "RX/TX not enabled as expected in $elf: UCSR0B=$ucsr0b"
    test "$ucsr0c" = "0x6" || test "$ucsr0c" = "0x06" ||
        fail "USART0 not configured for 8-bit frame as expected in $elf: UCSR0C=$ucsr0c"

    # UCSR0A contains live status bits, so only assert that U2X0 remains clear.
    case "$ucsr0a" in
        0x*) ;;
        *) fail "invalid UCSR0A value in $elf: $ucsr0a" ;;
    esac
}

probe_usart0_config build/usart0-echo-c.elf
probe_usart0_config build/usart0-echo-asm.elf

printf '%s\n' "Q1 PASS"
