#!/bin/sh
set -eu

fail() {
    printf 'M1 FAIL: %s\n' "$*" >&2
    exit 1
}

for tool in avr-gcc avr-objcopy avr-objdump avr-size avr-gdb avrdude avarice make simavr; do
    command -v "$tool" >/dev/null 2>&1 || fail "missing tool: $tool"
done

avr-gcc -mmcu=atmega1284p -dM -E - </dev/null >/dev/null 2>&1 ||
    fail "avr-gcc does not accept -mmcu=atmega1284p"

make clean
make all
make disasm
make size

for artifact in     build/blink-c.elf     build/blink-c.hex     build/blink-c.lst     build/blink-asm.elf     build/blink-asm.hex     build/blink-asm.lst
do
    test -s "$artifact" || fail "missing or empty artifact: $artifact"
done

avr-objdump -f build/blink-c.elf | grep -qi avr ||
    fail "C ELF is not reported as AVR"
avr-objdump -f build/blink-asm.elf | grep -qi avr ||
    fail "ASM ELF is not reported as AVR"

printf '%s\n' "M1 PASS"
