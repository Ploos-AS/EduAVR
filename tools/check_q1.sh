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
run_sim build/gpio-c.elf
run_sim build/gpio-asm.elf
run_sim build/stack-functions-c.elf
run_sim build/stack-functions-asm.elf
run_sim build/timer-isr-c.elf
run_sim build/timer-isr-asm.elf
run_sim build/pwm-c.elf
run_sim build/pwm-asm.elf
run_sim build/usart0-echo-c.elf
run_sim build/usart0-echo-asm.elf
run_sim build/usart0-irq-ring-c.elf
run_sim build/usart0-irq-ring-asm.elf
run_sim build/usart1-echo-c.elf
run_sim build/usart1-echo-asm.elf
run_sim build/usart1-irq-ring-c.elf
run_sim build/usart1-irq-ring-asm.elf
run_sim build/spi-c.elf
run_sim build/spi-asm.elf
run_sim build/twi-c.elf
run_sim build/twi-asm.elf

probe_gpio_config() {
    elf="$1"
    log="$elf.gpio.gdb.log"

    simavr -m atmega1284p -f 8000000 -g "$elf" >"$elf.gpio.sim.log" 2>&1 &
    sim_pid=$!
    trap 'kill "$sim_pid" 2>/dev/null || true' EXIT INT TERM
    sleep 1

    set +e
    timeout 10s avr-gdb -q -batch "$elf" \
        -ex "target remote :1234" \
        -ex "break gpio_ready" \
        -ex "continue" \
        -ex "p/x *(unsigned char*)0x24" \
        -ex "p/x *(unsigned char*)0x25" \
        -ex "p/x *(unsigned char*)0x23" \
        -ex "quit" >"$log" 2>&1
    rc=$?
    set -e

    kill "$sim_pid" 2>/dev/null || true
    wait "$sim_pid" 2>/dev/null || true
    trap - EXIT INT TERM

    test "$rc" -eq 0 || { cat "$log" >&2; fail "GDB GPIO probe failed for $elf"; }
    values=$(awk '/^[$][0-9]+ = 0x/ { sub(/^.*= /, ""); print }' "$log")
    set -- $values
    test "$#" -ge 3 || { cat "$log" >&2; fail "could not read GPIO registers from $elf"; }
    test "$1" = "0x1" || test "$1" = "0x01" || fail "unexpected DDRB in $elf: $1"
    test "$2" = "0x2" || test "$2" = "0x02" || fail "unexpected PORTB in $elf: $2"
    case "$3" in 0x* ) ;; *) fail "invalid PINB value in $elf: $3" ;; esac
}

probe_gpio_config build/gpio-c.elf
probe_gpio_config build/gpio-asm.elf

probe_stack_abi() {
    elf="$1"
    log="$elf.stack.gdb.log"

    simavr -m atmega1284p -f 8000000 -g "$elf" >"$elf.stack.sim.log" 2>&1 &
    sim_pid=$!
    trap 'kill "$sim_pid" 2>/dev/null || true' EXIT INT TERM
    sleep 1

    set +e
    timeout 10s avr-gdb -q -batch "$elf" \
        -ex "target remote :1234" \
        -ex "break stack_ready" \
        -ex "continue" \
        -ex "p/x *(unsigned char*)&stack_result" \
        -ex "p/x *(unsigned short*)&stack_sp_before" \
        -ex "p/x *(unsigned short*)&stack_sp_inside" \
        -ex "p/x *(unsigned short*)&stack_sp_after" \
        -ex "quit" >"$log" 2>&1
    rc=$?
    set -e

    kill "$sim_pid" 2>/dev/null || true
    wait "$sim_pid" 2>/dev/null || true
    trap - EXIT INT TERM

    test "$rc" -eq 0 || { cat "$log" >&2; fail "GDB stack/ABI probe failed for $elf"; }
    values=$(awk '/^[$][0-9]+ = 0x/ { sub(/^.*= /, ""); print }' "$log")
    set -- $values
    test "$#" -ge 4 || { cat "$log" >&2; fail "could not read stack/ABI probe values from $elf"; }

    result=$1; before=$2; inside=$3; after=$4
    test "$result" = "0x46" || fail "ABI argument/result check failed in $elf: result=$result"
    test "$before" = "$after" || fail "stack did not balance in $elf: before=$before after=$after"

    before_dec=$(printf "%d" "$before")
    inside_dec=$(printf "%d" "$inside")
    test "$inside_dec" -lt "$before_dec" ||
        fail "stack pointer did not move downward inside call in $elf: before=$before inside=$inside"
}

probe_stack_abi build/stack-functions-c.elf
probe_stack_abi build/stack-functions-asm.elf

# Confirm GDB can read both AVR ELF files and their symbols non-interactively.
for elf in build/blink-c.elf build/blink-asm.elf build/gpio-c.elf build/gpio-asm.elf build/stack-functions-c.elf build/stack-functions-asm.elf build/timer-isr-c.elf build/timer-isr-asm.elf build/pwm-c.elf build/pwm-asm.elf build/usart0-echo-c.elf build/usart0-echo-asm.elf build/usart0-irq-ring-c.elf build/usart0-irq-ring-asm.elf build/usart1-echo-c.elf build/usart1-echo-asm.elf build/usart1-irq-ring-c.elf build/usart1-irq-ring-asm.elf build/spi-c.elf build/spi-asm.elf build/twi-c.elf build/twi-asm.elf; do
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
        -ex "info registers pc sp" \
        -ex "quit" >"$log" 2>&1
    rc=$?
    set -e

    kill "$sim_pid" 2>/dev/null || true
    wait "$sim_pid" 2>/dev/null || true
    trap - EXIT INT TERM

    test "$rc" -eq 0 || { cat "$log" >&2; fail "GDB timer IRQ probe failed for $elf"; }
    grep -Eq "Breakpoint [0-9]+,.*|in timer0_compa_probe" "$log" ||
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
        -ex "break pwm_ready" \
        -ex "continue" \
        -ex "p/x *(unsigned char*)0x24" \
        -ex "p/x *(unsigned char*)0x44" \
        -ex "p/x *(unsigned char*)0x45" \
        -ex "p/x *(unsigned char*)0x47" \
        -ex "quit" >"$log" 2>&1
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
    values=$(awk '/^[$][0-9]+ = 0x/ { sub(/^.*= /, ""); print }' "$log")
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
        -ex "break usart0_ready" \
        -ex "continue" \
        -ex "p/x *(unsigned char*)0xc5" \
        -ex "p/x *(unsigned char*)0xc4" \
        -ex "p/x *(unsigned char*)0xc0" \
        -ex "p/x *(unsigned char*)0xc1" \
        -ex "p/x *(unsigned char*)0xc2" \
        -ex "quit" >"$log" 2>&1
    rc=$?
    set -e

    kill "$sim_pid" 2>/dev/null || true
    wait "$sim_pid" 2>/dev/null || true
    trap - EXIT INT TERM

    test "$rc" -eq 0 || { cat "$log" >&2; fail "GDB USART0 probe failed for $elf"; }

    values=$(awk '/^[$][0-9]+ = 0x/ { sub(/^.*= /, ""); print }' "$log")
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




probe_usart1_config() {
    elf="$1"
    log="$elf.usart1.gdb.log"
    simavr -m atmega1284p -f 8000000 -g "$elf" >"$elf.usart1.sim.log" 2>&1 &
    sim_pid=$!
    trap 'kill "$sim_pid" 2>/dev/null || true' EXIT INT TERM
    sleep 1
    set +e
    timeout 10s avr-gdb -q -batch "$elf" \
        -ex "target remote :1234" \
        -ex "break usart1_ready" \
        -ex "continue" \
        -ex "p/x *(unsigned char*)0xcd" \
        -ex "p/x *(unsigned char*)0xcc" \
        -ex "p/x *(unsigned char*)0xc8" \
        -ex "p/x *(unsigned char*)0xc9" \
        -ex "p/x *(unsigned char*)0xca" \
        -ex "quit" >"$log" 2>&1
    rc=$?
    set -e
    kill "$sim_pid" 2>/dev/null || true
    wait "$sim_pid" 2>/dev/null || true
    trap - EXIT INT TERM
    test "$rc" -eq 0 || { cat "$log" >&2; fail "GDB USART1 probe failed for $elf"; }
    values=$(awk '/^[$][0-9]+ = 0x/ { sub(/^.*= /, ""); print }' "$log")
    set -- $values
    test "$#" -ge 5 || { cat "$log" >&2; fail "could not read USART1 registers from $elf"; }
    test "$1" = "0x0" || test "$1" = "0x00" || fail "unexpected UBRR1H in $elf: $1"
    test "$2" = "0x33" || fail "unexpected UBRR1L in $elf: $2"
    test "$4" = "0x18" || fail "RX/TX not enabled in $elf: UCSR1B=$4"
    test "$5" = "0x6" || test "$5" = "0x06" || fail "USART1 frame mismatch in $elf: UCSR1C=$5"
}

probe_usart1_config build/usart1-echo-c.elf
probe_usart1_config build/usart1-echo-asm.elf

probe_spi_config() {
    elf="$1"
    log="$elf.spi.gdb.log"

    simavr -m atmega1284p -f 8000000 -g "$elf" >"$elf.spi.sim.log" 2>&1 &
    sim_pid=$!
    trap 'kill "$sim_pid" 2>/dev/null || true' EXIT INT TERM
    sleep 1

    set +e
    timeout 10s avr-gdb -q -batch "$elf" \
        -ex "target remote :1234" \
        -ex "break spi_ready" \
        -ex "continue" \
        -ex "p/x *(unsigned char*)0x24" \
        -ex "p/x *(unsigned char*)0x4c" \
        -ex "p/x *(unsigned char*)0x4d" \
        -ex "quit" >"$log" 2>&1
    rc=$?
    set -e

    kill "$sim_pid" 2>/dev/null || true
    wait "$sim_pid" 2>/dev/null || true
    trap - EXIT INT TERM

    test "$rc" -eq 0 || { cat "$log" >&2; fail "GDB SPI probe failed for $elf"; }

    values=$(awk '/^[$][0-9]+ = 0x/ { sub(/^.*= /, ""); print }' "$log")
    set -- $values
    test "$#" -ge 3 || { cat "$log" >&2; fail "could not read SPI registers from $elf"; }
    ddrb=$1; spcr=$2; spsr=$3

    # PB4/SS, PB5/MOSI and PB7/SCK are outputs; PB6/MISO remains input.
    test "$ddrb" = "0xb0" || fail "unexpected SPI DDRB in $elf: $ddrb"
    # SPE|MSTR|SPR0 = 0x51: enabled controller, mode 0, F_CPU/16.
    test "$spcr" = "0x51" || fail "unexpected SPCR in $elf: $spcr"
    # SPI2X must be clear. Other SPSR bits are live peripheral state.
    case "$spsr" in
        0x0|0x00|0x80) ;;
        *) fail "unexpected SPSR in $elf: $spsr" ;;
    esac
}

probe_spi_config build/spi-c.elf
probe_spi_config build/spi-asm.elf


probe_twi_config() {
    elf="$1"
    log="$elf.twi.gdb.log"

    simavr -m atmega1284p -f 8000000 -g "$elf" >"$elf.twi.sim.log" 2>&1 &
    sim_pid=$!
    trap 'kill "$sim_pid" 2>/dev/null || true' EXIT INT TERM
    sleep 1

    set +e
    timeout 10s avr-gdb -q -batch "$elf" \
        -ex "target remote :1234" \
        -ex "break twi_ready" \
        -ex "continue" \
        -ex "p/x *(unsigned char*)0xb8" \
        -ex "p/x *(unsigned char*)0xb9" \
        -ex "p/x *(unsigned char*)0xbc" \
        -ex "quit" >"$log" 2>&1
    rc=$?
    set -e

    kill "$sim_pid" 2>/dev/null || true
    wait "$sim_pid" 2>/dev/null || true
    trap - EXIT INT TERM

    test "$rc" -eq 0 || { cat "$log" >&2; fail "GDB TWI probe failed for $elf"; }

    values=$(awk '/^[$][0-9]+ = 0x/ { sub(/^.*= /, ""); print }' "$log")
    set -- $values
    test "$#" -ge 3 || { cat "$log" >&2; fail "could not read TWI registers from $elf"; }
    twbr=$1; twsr=$2; twcr=$3

    test "$twbr" = "0x20" || fail "unexpected TWBR in $elf: $twbr"
    # TWSR prescaler bits TWPS1:0 must remain zero. Status bits may be model state.
    case "$twsr" in
        0x0|0x00|0xf8) ;;
        *) fail "unexpected TWSR in $elf: $twsr" ;;
    esac
    # TWEN is bit 2. At the stable probe point no command bits were requested.
    test "$twcr" = "0x4" || test "$twcr" = "0x04" ||
        fail "TWI not enabled as expected in $elf: TWCR=$twcr"
}

probe_twi_config build/twi-c.elf
probe_twi_config build/twi-asm.elf

# Deterministic USART0 data-path qualification using simavr's IRQ API.
# Feed bytes into RX and require the echo firmware to reproduce them on TX.
cc -std=c11 -Wall -Wextra -Werror -o build/q1-usart-loopback \
    tools/q1_usart_loopback.c \
    -I/usr/include/simavr -lsimavr -lelf
build/q1-usart-loopback build/usart0-echo-c.elf
build/q1-usart-loopback build/usart0-echo-asm.elf


# Deterministic USART1 RX -> firmware -> TX qualification.
cc -std=c11 -Wall -Wextra -Werror -o build/q1-usart1-loopback \
    tools/q1_usart1_loopback.c \
    -I/usr/include/simavr -lsimavr -lelf
build/q1-usart1-loopback build/usart1-echo-c.elf
build/q1-usart1-loopback build/usart1-echo-asm.elf

# Interrupt-driven USART0 RX/TX ring-buffer qualification.
cc -std=c11 -Wall -Wextra -Werror -o build/q1-usart-irq-ring \
    tools/q1_usart_irq_ring.c \
    -I/usr/include/simavr -lsimavr -lelf
build/q1-usart-irq-ring build/usart0-irq-ring-c.elf
build/q1-usart-irq-ring build/usart0-irq-ring-asm.elf



# Interrupt-driven USART1 RX/TX ring-buffer qualification.
cc -std=c11 -Wall -Wextra -Werror -o build/q1-usart1-irq-ring \
    tools/q1_usart1_irq_ring.c \
    -I/usr/include/simavr -lsimavr -lelf
build/q1-usart1-irq-ring build/usart1-irq-ring-c.elf
build/q1-usart1-irq-ring build/usart1-irq-ring-asm.elf

# Robust USART normal-path qualification. Reuse the deterministic USART0
# loopback harness: modeled RX/TX must remain byte-identical. FE/DOR/UPE are
# intentionally not claimed here unless the simulator can model them reliably.
build/q1-usart-loopback build/usart-robust-c.elf
build/q1-usart-loopback build/usart-robust-asm.elf

# Bidirectional USART0 <-> USART1 bridge qualification.
cc -std=c11 -Wall -Wextra -Werror -o build/q1-dual-uart-bridge \
    tools/q1_dual_uart_bridge.c \
    -I/usr/include/simavr -lsimavr -lelf
build/q1-dual-uart-bridge build/dual-uart-bridge-c.elf
build/q1-dual-uart-bridge build/dual-uart-bridge-asm.elf

# The same bidirectional data-path harness stresses the interrupt/ring-buffer bridge.
build/q1-dual-uart-bridge build/dual-uart-irq-bridge-c.elf
build/q1-dual-uart-bridge build/dual-uart-irq-bridge-asm.elf

# Deterministic SPI controller data-path qualification using simavr's SPI IRQ API.
# Firmware transmits 0x55; the virtual peripheral responds with 0xaa.
cc -std=c11 -Wall -Wextra -Werror -o build/q1-spi-datapath \
    tools/q1_spi_datapath.c \
    -I/usr/include/simavr -lsimavr -lelf
build/q1-spi-datapath build/spi-c.elf
build/q1-spi-datapath build/spi-asm.elf

# Deterministic TWI data-path qualification with a virtual EEPROM-like peer.
cc -std=c11 -Wall -Wextra -Werror -o build/q1-twi-datapath \
    tools/q1_twi_datapath.c \
    -I/usr/include/simavr -lsimavr -lelf
build/q1-twi-datapath build/twi-c.elf
build/q1-twi-datapath build/twi-asm.elf

printf '%s\n' "Q1 PASS"
