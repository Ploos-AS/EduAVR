# Exercise 04 — Calling convention

## Metadata
- **Mode:** SIM
- **Level:** 2 Intermediate
- **Primary language phase:** ASM → C
- **Hardware:** None
- **Qualification:** Q1 simulator
- **Concepts:** ABI, registers, stack, call/return, compiler output

## Learning objectives
Explain how separately written C and assembly functions agree on arguments, return values and preserved state; observe CALL/RET and stack-pointer changes; and understand why an ABI is a contract.

## Mental model
```text
caller -> argument registers -> CALL -> callee
          saved state          stack    |
caller <- return register  <- RET <------+
```

## Short theory
A function call is not magic. The AVR-GCC ABI defines where arguments and return values live and which registers a callee must preserve. CALL/return-address handling also changes stack state.

## Part A — Assembly
Write an AVR-GCC-compatible `add8` routine. Identify its argument and return registers from the ABI before writing code. Call it from a minimal test harness and single-step across the call.

## Observe
Record SP immediately before CALL, inside the function and immediately after return. Record relevant registers at the same points.

## Part B — C
Implement `uint8_t add8(uint8_t a, uint8_t b)`. Build at `-O0` and `-Os`, disassemble both and compare them with your assembly routine. Then call your assembly implementation from C.

## Under the hood
Trace:
```text
C function call -> ABI argument registers -> CALL -> stack/return address
                -> function instructions -> return register -> caller
```

## Task
Add a second function taking three 8-bit arguments. Predict argument placement before inspecting the disassembly.

## Expected result
C and assembly implementations interoperate correctly, and stack/register state returns to the expected caller-visible state.

## Questions
- Why is an ABI necessary?
- What does CALL place on the stack?
- Why must some registers be preserved?
- Why can `-Os` produce a radically different-looking function?
- What happens if assembly violates the ABI?

## Challenge
Deliberately violate one preservation rule in the simulator, observe corrupted caller state, then repair it and document the failure mechanism.

## Qualification boundary
Q1 is sufficient because the lesson concerns deterministic CPU, ABI, register and stack behavior.
