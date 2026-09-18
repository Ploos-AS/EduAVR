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

# Confirm GDB can read both AVR ELF files and their symbols non-interactively.
for elf in build/blink-c.elf build/blink-asm.elf build/timer-isr-c.elf build/timer-isr-asm.elf build/pwm-c.elf build/pwm-asm.elf; do
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
        -ex "break TIMER0_COMPA_vect" \
        -ex "continue" \
        -ex "info registers pc sp sreg" \
        -ex "detach" >"$log" 2>&1
    rc=$?
    set -e

    kill "$sim_pid" 2>/dev/null || true
    wait "$sim_pid" 2>/dev/null || true
    trap - EXIT INT TERM

    test "$rc" -eq 0 || { cat "$log" >&2; fail "GDB timer IRQ probe failed for $elf"; }
    grep -q "Breakpoint .*TIMER0_COMPA_vect" "$log" ||
        { cat "$log" >&2; fail "Timer0 compare ISR was not reached in $elf"; }
}

probe_timer_irq build/timer-isr-c.elf
probe_timer_irq build/timer-isr-asm.elf

printf '%s\n' "Q1 PASS"
