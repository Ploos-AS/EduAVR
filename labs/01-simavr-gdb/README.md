# Lab 01 — From source to simulated AVR

This lab introduces the EduAVR execution ladder without requiring physical hardware.

## Goals

- build the C and AVR assembly Blink examples;
- inspect the generated AVR instructions;
- start the firmware in simavr for ATmega1284P;
- attach avr-gdb;
- single-step instructions;
- inspect registers, SRAM and I/O state;
- understand what simulation proves and what still requires hardware.

## Build

```sh
make clean all disasm
```

## Start simavr

Terminal 1:

```sh
simavr -m atmega1284p -f 8000000 -g build/blink-c.elf
```

The `-g` option enables the GDB server.

## Debug

Terminal 2:

```sh
avr-gdb build/blink-c.elf
```

At the GDB prompt:

```gdb
target remote :1234
break main
continue
layout asm
stepi
info registers
```

Repeat with `build/blink-asm.elf`.

## Compare

Find the GPIO setup and toggle in both programs. Compare the hand-written assembly with the instructions emitted for the C implementation.

## Qualification boundary

A simulator can qualify deterministic CPU/software behaviour such as instruction flow, register operations, memory use, many peripheral interactions and protocol state machines.

Simulation does **not** prove electrical behaviour, oscillator accuracy, voltage levels, signal integrity, real switch bounce, programmer wiring, physical UART levels, ADC noise/accuracy or that a particular STK500 setup works.

EduAVR therefore uses simulation-first qualification and a smaller set of explicit hardware checkpoints.
