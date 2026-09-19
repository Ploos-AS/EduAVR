# Exercise 02 — Registers and arithmetic

## Metadata

- **Mode:** SIM
- **Level:** 1 Beginner
- **Primary language phase:** ASM → C
- **Hardware:** None
- **Qualification:** Q1 simulator
- **Concepts:** registers, arithmetic, SREG, carry, zero, overflow

Write the same tiny calculation twice:

1. directly in AVR assembly;
2. in C using `uint8_t`.

Use values that fit in eight bits. Then:

- build both programs;
- inspect the disassembly;
- single-step both with avr-gdb;
- record which registers change;
- repeat with a calculation that overflows 8 bits;
- inspect SREG and explain the carry/zero flags you observe.

Do not judge the C version by whether it uses exactly the registers you expected. Explain why the compiler is free to choose registers and optimize operations.

**Required qualification:** Q1 simulator.


## Under the hood

Relate the implementation back through the full EduAVR chain: **C (where used) → generated AVR instructions → registers/memory → peripheral behavior → physical result (where applicable)**. Explain compiler choices instead of expecting C and hand-written assembly to be instruction-for-instruction identical.
