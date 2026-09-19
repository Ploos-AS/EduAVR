# Appendix D — C ↔ Assembly and compiler behaviour

## Purpose
Make C understandable as generated machine behavior rather than a separate layer of magic.

## Comparison method
For a small function:
1. write the behavior in AVR assembly;
2. write a clear C equivalent;
3. compile at selected optimization levels;
4. disassemble;
5. compare instructions, register allocation, memory accesses, calls and size;
6. explain differences rather than assuming shorter is always better.

## ABI
Track argument registers, return-value registers, call-used versus call-saved registers, the zero-register convention and stack use. Hand-written assembly called from C must obey the ABI.

## Topics to inspect
- constants and arithmetic;
- loops and branches;
- pointers and arrays;
- 16/32-bit operations on an 8-bit CPU;
- structs;
- function calls;
- ISR entry/exit;
- inline versus out-of-line code.

## volatile
`volatile` tells the compiler that accesses are observable and must not be optimized away as ordinary memory operations. It is important for MMIO and some shared state, but it does not make multi-byte access atomic and is not a general concurrency solution.

## Optimization
Compare at least an unoptimized/debug-friendly build with an optimized build. Source order, variable visibility and instruction count can change substantially while program semantics remain equivalent.

## Rule
Always ask: **which AVR instructions, registers, memory locations and peripherals implement this C construct?**
