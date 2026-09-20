# M6 Qualification

M6 — Systems programming is complete and CI-qualified at the course/Q1 level.

## Scope

M6 covers the bilingual core lessons 14–19:

- pointers, buffers and structs;
- `volatile`, interrupts and atomicity;
- SRAM and stack resource budgeting;
- optimization and generated-code analysis;
- code-size and static-SRAM analysis;
- integrated systems capstone.

The executable material uses paired C and hand-written AVR Assembly where runtime behavior is being taught. The capstone integrates Timer0, ADC, EEPROM and USART.

## Qualification gate

The authoritative M6 exit gate is:

```sh
sh tools/check_m6.sh
```

The gate combines a clean build/disassembly/size pass, the complete Q1 simulator suite, resource regression guardrails, the dedicated capstone Q1 probe and generation of the memory report.

M6 was first accepted as CI-qualified by GitHub Actions run 524. Later repository builds continue to exercise the same qualification infrastructure.

## Q1 evidence

M6 Q1 evidence includes deterministic paired C/Assembly checks for data structures, shared ISR/main state, stack/resource behavior, optimization behavior and the integrated capstone. The capstone verifies modeled Timer/ADC/EEPROM/USART integration in simavr.

The resource policy uses course regression guardrails rather than universal ATmega1284P device limits. Static SRAM is measured from ELF data; dynamic stack behavior is qualified separately by runtime probes and must not be inferred solely from static section sizes.

## Boundary

This qualification is **Q1 simulator qualification**. It does not establish electrical or physical behavior of EduBoard-AVR/STK500, analog accuracy, oscillator accuracy, signal integrity, programming hardware, external devices or other Q2 properties.

Board-specific Q2 evidence remains separate and must be based on a stable physical EduBoard revision.

## Result

**M6: PASS — course/Q1 level.**

The executable tests and CI result are authoritative; this document records the scope and interpretation of that evidence.
