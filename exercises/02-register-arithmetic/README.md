# Exercise 02 — Registers and arithmetic

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
