# Exercise 02 — Registers and arithmetic

## Metadata
- **Mode:** SIM
- **Level:** 1 Beginner
- **Primary language phase:** ASM → C
- **Hardware:** None
- **Qualification:** Q1 simulator
- **Concepts:** registers, arithmetic, SREG, carry, zero, overflow

## Learning objectives
After this exercise you should be able to explain what an 8-bit register is, follow values through AVR instructions, predict simple arithmetic results and identify why SREG flags change. You should also see how a simple C expression becomes AVR instructions.

## Mental model
```text
constant -> register r16 --+
                           +-> ADD -> result register
constant -> register r17 --+           |
                                       +-> SREG flags (Z, C, ...)
```

## Short theory
An AVR register stores a fixed-width binary value. Arithmetic produces both a result and status information in SREG. With 8-bit arithmetic, values can wrap when the mathematical result no longer fits.

## Part A — Assembly
Load two small constants into registers and add them. Before running, write down the expected binary and hexadecimal result. Single-step the program and observe both registers and SREG.

Repeat with values that:
1. produce an ordinary non-zero result;
2. produce zero;
3. overflow the unsigned 8-bit range.

## Observe
Record a table with operands, predicted result, actual result, Z flag and C flag. Explain every difference between prediction and observation.

## Part B — C
Implement the same calculations with `uint8_t`. Build and disassemble the program, then single-step it. Do not expect GCC to choose the same registers as your hand-written program.

## Under the hood
Trace one expression through:
```text
a + b -> compiler -> AVR arithmetic instruction(s) -> result register -> SREG
```
Identify where the C abstraction stops exposing details you could see directly in assembly.

## Task
Write a tiny program that adds three 8-bit values. Predict the final value and flags before running it. Then choose inputs that make the final result wrap.

## Expected result
Your predicted and simulated register values should agree, and you should be able to explain the relevant SREG flags rather than merely report them.

## Questions
- Why can 255 + 1 become 0 in an 8-bit register?
- What is the difference between the zero and carry flags?
- Does C guarantee which AVR register stores a variable?
- Why might optimized C use fewer instructions than expected?
- What did simulation prove here that did not require hardware?

## Challenge
Implement a 16-bit addition using two 8-bit register pairs and explain how carry propagates from the low byte to the high byte.

## Qualification boundary
Q1 simulation is sufficient because this exercise concerns deterministic CPU/register behavior. No electrical claim is made.
