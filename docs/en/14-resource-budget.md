# SRAM and stack resource budgets

!!! abstract "Learning goals"
    Measure static SRAM use and dynamic stack movement on an 8-bit AVR, distinguish the two, compare C with hand-written Assembly, and reason about the margin required to keep them from colliding.

!!! info "Prerequisites"
    Complete the stack/functions and pointers/buffers lessons first. The volatile/atomicity lesson is also useful background.

AVR SRAM is shared by global/static data and the stack. A program can compile successfully and still be unsafe if these regions can grow into each other at runtime.

## The paired example

EduAVR provides:

- `examples/c/resource-budget/main.c`
- `examples/asm/resource-budget/main.S`

Both reserve a 16-byte static buffer and call a worker that uses eight bytes of local stack storage. They record the stack pointer before the call, at the deeper point, and after return.

The worker returns the deterministic value `0x47`.

## Static SRAM versus dynamic stack

Objects in `.data` and `.bss` consume a predictable part of SRAM. The stack is different: calls, saved registers, interrupt entry and local automatic storage consume it dynamically.

That means a useful memory budget has at least two parts:

1. static SRAM visible in the ELF/map/size output;
2. worst-case stack depth along realistic call and interrupt paths.

Heap use, if introduced, adds another moving boundary and should be budgeted explicitly.

## C implementation

The C worker deliberately declares an eight-byte local array. Inspect the generated code rather than assuming the compiler implements the source exactly as imagined. Optimization, register allocation and ABI rules determine the actual stack frame.

Run:

```sh
make budget
make size
make disasm
sh tools/check_q1.sh
```

Compare the C listing with the source and identify the stack-pointer manipulation around `budget_worker`.

## Assembly implementation

The Assembly version makes the frame explicit. It saves the ABI call-saved frame-pointer registers, reserves eight bytes, records the deeper SP, restores the frame and returns with the original caller SP restored.

This is useful because it separates three costs:

- call/return mechanics;
- saved registers;
- local storage.

## Deterministic Q1 qualification

At `budget_ready`, the Q1 probe checks both implementations. It requires:

- `budget_result = 0x47`;
- the stack pointer moved downward inside the worker;
- the stack pointer after return equals the value before the call;
- the 16-byte static buffer exists as part of the executable memory footprint.

!!! success "Qualified behavior"
    The paired examples provide deterministic simulator evidence for balanced stack use and observable stack depth. Q1 does not claim a universal worst-case stack bound for arbitrary firmware.

## Building a real budget

For production firmware, do not treat one observed call as the whole answer. Include:

- the deepest call chain;
- nested calls and library routines;
- interrupt entry and ISR register saving;
- possible interrupt nesting policy;
- static buffers and protocol queues;
- safety margin for future changes.

Use `avr-size`, linker information and targeted runtime probes together. No single number tells the whole story.

## Exercises

1. Increase the local array and predict how the deepest SP should change.
2. Add another function call inside the worker and inspect the new frame.
3. Compare `avr-size` before and after doubling `budget_static`.
4. Explain why balanced SP after return does not prove sufficient worst-case SRAM margin.
5. Identify what an interrupt occurring at the deepest point would add to the stack budget.

!!! tip "Next"
    Continue by comparing optimization levels and studying how compiler choices change code size, register use and stack frames while preserving required semantics.
