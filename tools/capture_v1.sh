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

make clean all disasm >/dev/null

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

Do not relabel these files as Q1/Q2 evidence.
EOF
