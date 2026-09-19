# Appendix B — Debugging AVR

## Purpose
Use the debugger to observe the machine rather than guess what firmware is doing.

## Core workflow
Build with debug information, start the simulator or debug server, connect avr-gdb, load symbols, reset, set a breakpoint and step at source or instruction level.

Useful GDB activities:
- inspect general-purpose registers and SREG;
- inspect I/O registers and SRAM;
- examine the stack pointer and stack memory;
- use source, assembly and mixed disassembly views;
- set breakpoints at functions and interrupt handlers;
- use watchpoints where the target/debug backend supports them;
- compare C source with generated AVR instructions.

## Simulator versus hardware
simavr is appropriate for deterministic Q1 CPU/peripheral experiments. Hardware debugging is Q2 and depends on the board and debug interface. AVaRICE/JTAG-class workflows belong here as a hardware-debug option, not as a requirement for every lab.

## Debugging interrupts
When debugging an ISR:
1. identify its vector;
2. inspect the interrupt enable and flag state;
3. inspect SREG/global interrupt state;
4. break at ISR entry;
5. inspect compiler-generated prologue/epilogue in C builds;
6. verify shared state after return.

## Stack inspection
Record SP before CALL, inside the callee/ISR, and after RET/RETI. Correlate memory changes with return addresses and saved registers.

## Common traps
- optimized code may not map one-to-one to source lines;
- peripheral models are not electrical qualification;
- a breakpoint changes timing;
- an ISR bug may appear to be a main-loop bug;
- stale symbols from an old ELF can make a correct session misleading.

## Practice
Repeat one existing EduAVR exercise entirely from the debugger: predict a register change, step the responsible instruction, verify it, then explain the physical consequence that would occur on the board.
