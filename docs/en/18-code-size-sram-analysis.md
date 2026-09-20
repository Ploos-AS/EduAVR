# Code size and SRAM analysis

!!! abstract "Learning goals"
    Turn ELF information into an explicit firmware memory budget, distinguish Flash from SRAM, identify static data symbols, and document why a single avr-size number is not a complete resource analysis.

!!! info "Prerequisites"
    Complete lessons 16 and 17 first.

Optimization becomes engineering evidence when its effects are measured against resource limits. On AVR, the first important distinction is between Flash and SRAM.

## What the ELF tells us

| Section | Typical resource | Meaning |
| --- | --- | --- |
| .text | Flash | instructions and executable code |
| .rodata | Flash | read-only constants |
| .data | Flash + SRAM | initialized writable data; startup copies it to SRAM |
| .bss | SRAM | zero-initialized writable data |
| stack | SRAM | runtime call, ISR and local storage |
| heap | SRAM | dynamic allocation, if used |

The exact linker layout depends on the target and linker script, so the ELF is the source of truth for a particular build.

## Static versus dynamic SRAM

A useful first approximation is:

static_sram = .data + .bss

The stack is a separate runtime budget. Firmware can have a small .bss and still exhaust SRAM through a deep call chain or interrupt activity.

EduAVR therefore reports static SRAM and observed stack movement separately.

## Flash budgeting

A useful first model is:

flash_image = .text + .rodata + .data

The .data bytes occupy Flash in the initialization image while the writable copy also consumes SRAM. This is a budgeting model, not a replacement for the linker map or datasheet.

## The analysis tool

Run:

    make analyze

This creates build/memory-report.txt. The report contains section sizes from avr-size, Flash-oriented totals, static SRAM totals, selected .bss symbols, the resource-budget static buffer, and a reminder that stack/ISR depth remains a dynamic measurement.

## Why symbols matter

Section totals answer “how much?” but not always “what uses it?”

Use:

    avr-nm -S --size-sort build/resource-budget-c.elf

to identify large objects and functions. This is useful when a static buffer grows unexpectedly or a small change causes a resource regression.

## Comparing optimization builds

The optimization lesson produces O0, Os and O2 variants. Compare their reports and disassembly rather than assuming an optimization flag has a universal effect.

Useful evidence includes .text, .data and .bss sizes, named symbol sizes, generated instruction sequences and observed stack movement.

Do not turn these measurements into a universal ranking. The relevant constraint is the firmware's actual workload, memory limit and timing requirement.

## Qualification boundary

Q1 checks that the analysis can be generated from the ELF and that the deterministic examples remain semantically valid.

Q1 does not claim a universal worst-case stack bound, a universal maximum safe SRAM usage, a universal cycle count for an optimization level, or identical simulator and physical-board memory behaviour.

## Exercises

1. Generate reports for O0, Os and O2.
2. Identify the largest writable static object in the resource-budget example.
3. Explain why .data contributes to both Flash and SRAM budgets.
4. Increase a static buffer and observe which report fields change.
5. Explain why the report cannot prove worst-case stack depth.
6. Describe how an ISR can change the effective stack budget.

!!! success "Systems view"
    Code size, static SRAM, dynamic stack and timing are related constraints, but they are not the same measurement.
