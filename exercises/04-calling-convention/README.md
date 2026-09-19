# Exercise 04 — Calling convention

## Metadata

- **Mode:** SIM
- **Level:** 2 Intermediate
- **Primary language phase:** ASM → C
- **Hardware:** None
- **Qualification:** Q1 simulator
- **Concepts:** ABI, registers, stack, call/return, compiler output

Implement `uint8_t add8(uint8_t a, uint8_t b)` in C and as an AVR assembly routine compatible with AVR-GCC.

Then:

1. build the C implementation at `-O0` and `-Os`;
2. disassemble both;
3. identify argument and return registers;
4. single-step a call in avr-gdb;
5. inspect the stack pointer before the call, inside the function and after return;
6. identify which state the callee is responsible for preserving;
7. call the assembly implementation from a C program;
8. verify the result in the simulator.

As a deliberate failure experiment, temporarily violate one preservation rule and observe how caller state can be corrupted. Restore the correct implementation before committing results.

**Required qualification:** Q1 simulator.


## Under the hood

Relate the implementation back through the full EduAVR chain: **C (where used) → generated AVR instructions → registers/memory → peripheral behavior → physical result (where applicable)**. Explain compiler choices instead of expecting C and hand-written assembly to be instruction-for-instruction identical.
