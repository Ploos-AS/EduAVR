#!/bin/sh
set -eu

OUT=build/visual-v1
mkdir -p "$OUT"

{
  echo "EduAVR V1 toolchain capture"
  echo "commit: $(git rev-parse HEAD)"
  date -u '+captured_utc: %Y-%m-%dT%H:%M:%SZ'
  avr-gcc --version | head -1
  avr-as --version | head -1
  avr-objdump --version | head -1
  avr-size --version | head -1
  simavr --help 2>&1 | head -3 || true
  avr-gdb --version | head -1
  avrdude --version 2>&1 | head -1
} > "$OUT/01-toolchain.txt"

make all disasm >/dev/null
# Q1 ran earlier in the same CI job. Do not clean here: its real simulator/debugger
# logs are evidence that the visual-source pack must preserve.

{
  echo "EduAVR build artifacts"
  echo "commit: $(git rev-parse HEAD)"
  printf '\nELF/HEX files:\n'
  find build -maxdepth 1 \( -name '*.elf' -o -name '*.hex' \) -printf '%f\n' | sort
} > "$OUT/02-build-artifacts.txt"

avr-size -C --mcu=atmega1284p build/*.elf > "$OUT/03-avr-size.txt"
avr-objdump -h build/blink-c.elf > "$OUT/04-elf-sections.txt"
avr-objdump -t build/blink-c.elf > "$OUT/05-elf-symbols.txt"
avr-objdump -d -S build/blink-c.elf > "$OUT/06-blink-c-disassembly.txt"
avr-objdump -d -S build/blink-asm.elf > "$OUT/07-blink-asm-disassembly.txt"

{
  echo "EduAVR C versus assembly comparison"
  echo "commit: $(git rev-parse HEAD)"
  printf '\n=== C source ===\n'
  cat examples/c/blink/main.c
  printf '\n=== Generated C disassembly ===\n'
  avr-objdump -d -S build/blink-c.elf
  printf '\n=== Assembly source ===\n'
  cat examples/asm/blink/main.S
  printf '\n=== Assembly build disassembly ===\n'
  avr-objdump -d -S build/blink-asm.elf
} > "$OUT/08-c-vs-asm.txt"

{
  echo "EduAVR vector/ISR disassembly"
  echo "commit: $(git rev-parse HEAD)"
  avr-objdump -d -S build/timer-isr-c.elf
} > "$OUT/09-timer-isr-disassembly.txt"


# Preserve REAL Q1 simulator/debugger evidence produced by tools/check_q1.sh.
# These files are copied verbatim; they are not synthetic screenshots.
mkdir -p "$OUT/q1"
for src in \
  build/stack-functions-c.elf.stack.gdb.log \
  build/stack-functions-asm.elf.stack.gdb.log \
  build/eeprom-c.elf.eeprom.gdb.log \
  build/eeprom-asm.elf.eeprom.gdb.log \
  build/timer-isr-c.elf.irq.gdb.log \
  build/timer-isr-asm.elf.irq.gdb.log \
  build/pwm-c.elf.pwm.gdb.log \
  build/pwm-asm.elf.pwm.gdb.log \
  build/usart0-echo-c.elf.usart.gdb.log \
  build/usart0-echo-asm.elf.usart.gdb.log \
  build/usart1-echo-c.elf.usart1.gdb.log \
  build/usart1-echo-asm.elf.usart1.gdb.log \
  build/spi-c.elf.spi.gdb.log \
  build/spi-asm.elf.spi.gdb.log \
  build/twi-c.elf.twi.gdb.log \
  build/twi-asm.elf.twi.gdb.log
do
  if [ -f "$src" ]; then
    cp "$src" "$OUT/q1/"
  fi
done

cat > "$OUT/q1/FIGURE_MANIFEST.md" <<EOF
# Q1 figure-source manifest

All entries below are verbatim outputs from the qualified simavr/avr-gdb run.
Use the same technical source in English and Norwegian course material; localize
only captions and explanation.

| Figure source | Teaching use | Qualification |
| --- | --- | --- |
| stack-functions-c.elf.stack.gdb.log | C ABI result and stack-pointer before/inside/after call | Q1 |
| stack-functions-asm.elf.stack.gdb.log | Assembly CALL/RET result and stack-pointer balance | Q1 |
| eeprom-c.elf.eeprom.gdb.log | C EEPROM write/read persistence probe | Q1 |
| eeprom-asm.elf.eeprom.gdb.log | Assembly EEPROM write/read persistence probe | Q1 |
| timer-isr-c.elf.irq.gdb.log | Timer compare interrupt: breakpoint, PC and SP | Q1 |
| timer-isr-asm.elf.irq.gdb.log | Same interrupt path in assembly | Q1 |
| pwm-c.elf.pwm.gdb.log | DDRB/TCCR0A/TCCR0B/OCR0A after C setup | Q1 |
| pwm-asm.elf.pwm.gdb.log | Same PWM registers after assembly setup | Q1 |
| usart0-echo-c.elf.usart.gdb.log | USART0 baud/frame/RX/TX configuration in C | Q1 |
| usart0-echo-asm.elf.usart.gdb.log | Same USART0 configuration in assembly | Q1 |
| usart1-echo-c.elf.usart1.gdb.log | USART1 configuration in C | Q1 |
| usart1-echo-asm.elf.usart1.gdb.log | USART1 configuration in assembly | Q1 |
| spi-c.elf.spi.gdb.log | DDRB/SPCR/SPSR SPI setup in C | Q1 |
| spi-asm.elf.spi.gdb.log | Same SPI setup in assembly | Q1 |
| twi-c.elf.twi.gdb.log | TWBR/TWSR/TWCR TWI setup in C | Q1 |
| twi-asm.elf.twi.gdb.log | Same TWI setup in assembly | Q1 |

Repository commit: $(git rev-parse HEAD)
EOF

cat > "$OUT/q1/README.txt" <<EOF
EduAVR Q1 simulator/debugger capture

These are verbatim avr-gdb logs from the Q1 simavr qualification performed
earlier in the same CI job. They are real reproducible simulator/debugger
evidence, not generated terminal UI.

Repository commit: $(git rev-parse HEAD)
Qualification level: Q1 (simulated)

Expected coverage:
- Stack/functions ABI: result plus SP before/inside/after CALL/RET
- EEPROM write/read round trip in C and assembly
- Timer0 compare interrupt breakpoint and PC/SP
- PWM register configuration
- USART0 register configuration
- USART1 register configuration
- SPI register configuration
- TWI register configuration

A missing expected log is an error in the visual capture pipeline.
EOF

expected_q1_logs=16
actual_q1_logs=$(find "$OUT/q1" -maxdepth 1 -name '*.log' | wc -l)
test "$actual_q1_logs" -eq "$expected_q1_logs" || {
  echo "V1 capture FAIL: expected $expected_q1_logs Q1 logs, found $actual_q1_logs" >&2
  exit 1
}

cat > "$OUT/README.txt" <<EOF
EduAVR V1 visual-source artifact pack

These are REAL textual outputs produced by the repository CI environment.
They are source material for course figures/screenshots; they are not synthetic UI.

Qualification: Q0 unless a later qualified capture explicitly states Q1.
Repository commit: $(git rev-parse HEAD)

Files:
01 toolchain versions
02 produced ELF/HEX artifact inventory
03 avr-size report
04 ELF section table
05 ELF symbol table
06 C blink disassembly
07 assembly blink disassembly
08 side-by-side source/disassembly material
09 timer ISR/vector disassembly
q1/ verbatim avr-gdb logs from the same CI job's Q1 simavr qualification

Top-level files are Q0 source material. Files under q1/ are explicitly Q1 evidence.
Nothing in this artifact is Q2 physical-hardware evidence.
EOF
