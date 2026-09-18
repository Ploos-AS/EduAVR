# AVR architecture and the ATmega1284P

EduAVR starts with the machine, not a framework.

## The execution model

The ATmega1284P is an 8-bit AVR microcontroller. A program is stored in Flash and executed by the CPU. Working data normally lives in SRAM; persistent data can live in EEPROM. Peripherals are controlled through registers that software can read and write.

The most important idea for the first lessons is simple:

**C and assembly ultimately manipulate the same machine state.**

## CPU registers

AVR has 32 general-purpose 8-bit registers, `r0` through `r31`.

The register pairs `r26:r27`, `r28:r29`, and `r30:r31` can act as the X, Y, and Z pointer registers.

Other important CPU state includes:

- the program counter;
- the stack pointer;
- the status register (SREG);
- condition flags such as zero, carry and negative.

## Memory spaces

For the ATmega1284P reference MCU, learn to distinguish:

- Flash — program storage;
- SRAM — variables, buffers and stack;
- EEPROM — non-volatile application data;
- I/O/register space — control and status of the MCU and peripherals.

Do not assume that every address belongs to one flat memory space. AVR instructions and the compiler toolchain reflect these distinctions.

## First instruction set

Start with a deliberately small vocabulary:

- `ldi` — load an immediate value;
- `mov` — copy between registers;
- `add` / `sub` — arithmetic;
- `and` / `or` / `eor` — bit operations;
- `inc` / `dec` — increment/decrement;
- `cp` — compare;
- `breq` / `brne` — conditional branches;
- `rjmp` — relative jump;
- `call` / `ret` — subroutines.

GPIO-specific instructions and register operations are introduced in the GPIO lesson.

## ASM ↔ C

C:

```c
uint8_t a = 5;
uint8_t b = 3;
uint8_t result = a + b;
```

A simplified assembly view may resemble:

```asm
ldi r24, 5
ldi r25, 3
add r24, r25
```

The exact compiler output depends on context and optimization. EduAVR therefore does not ask students to memorize a fictional one-to-one translation. Build the real C program and inspect the actual output with `avr-objdump`.

## Simulator exercise

Build the examples and start an ELF under simavr + avr-gdb. Use `stepi` and `info registers` to watch the CPU state change one AVR instruction at a time.

The goal is to connect source code to actual machine state before adding higher-level abstractions.
