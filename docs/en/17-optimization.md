# Optimization and generated code

!!! abstract "Learning goals"
    Compare GCC optimization levels on AVR, explain why optimization changes instructions, register allocation and stack use without changing the required result, and use disassembly and size measurements as evidence.

!!! info "Prerequisites"
    Complete the systems-programming lessons on pointers, data structures, volatile/atomicity, and SRAM/stack budgets.

Optimization changes compiler decisions about instruction selection, register allocation, control flow and sometimes stack usage. The source-level contract must remain intact.

## The paired example

EduAVR provides `examples/c/optimization/main.c` and `examples/asm/optimization/main.S`.

The C implementation calculates a deterministic weighted sum over eight bytes. The repository builds the C version at **O0**, **Os** and **O2**, plus a hand-written Assembly reference.

The expected result is **0x03f8**.

## Compare the builds

```sh
make optimize
make disasm
make size
```

Compare the four ELF files and inspect `weighted_sum` in the generated listings.

## What optimization may change

Different levels can change instruction count, register allocation, loop structure, constant handling, function prologues/epilogues, stack depth and code size.

A smaller program is not automatically faster, and a faster implementation is not automatically smaller. Embedded optimization must be measured against the actual requirement.

## C versus Assembly

The Assembly implementation is intentionally explicit. The compiler may reach the same observable result through a different instruction sequence. Generated-assembly inspection therefore reconnects the C abstraction to the AVR instruction set and ABI.

## Qualification boundary

Q1 verifies that O0, Os, O2 and the Assembly reference produce the same deterministic result. It also verifies that their ELF `.text` sections can be measured.

Q1 does **not** claim that one optimization level is universally faster, smaller or better. Cycle-level conclusions require a defined workload and measurement method.

!!! success "Qualified behavior"
    All four variants preserve the required result while their generated code may differ.

## Exercises

1. Compare `weighted_sum` at O0 and Os. Which compiler decisions are visibly different?
2. Compare Os and O2. Does O2 necessarily produce smaller code?
3. Find the function prologue/epilogue at each level.
4. Explain why `noinline` is useful for this lesson.
5. Explain why a deterministic functional result is necessary but insufficient evidence for a performance claim.
6. Identify where the Assembly reference follows the AVR ABI.

!!! tip "Next"
    Continue with broader code-size and SRAM analysis, using optimization results as evidence rather than assumptions.
