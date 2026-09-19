# Appendix E — Memory internals

## Purpose
Understand where program code and data live and why AVR's Harvard architecture affects programming.

## Memory domains
- **Flash:** program instructions and persistent program constants.
- **SRAM:** runtime variables, .data, .bss, stack and optional heap.
- **EEPROM:** non-volatile data managed separately from normal SRAM.
- **I/O/register space:** control/status registers for CPU and peripherals.

## Startup
Before `main()`, runtime startup normally establishes required CPU/runtime state, copies initialized data from its Flash image to SRAM and clears .bss.

## Sections
Use the ELF/map/disassembly tools to locate .text, .data and .bss. Compare their sizes with actual MCU limits.

## Stack
The stack grows and shrinks with calls, saved registers, local storage and interrupts. Measure stack movement in Exercise 04 and ISR exercises.

## PROGMEM
Large constant tables need not consume scarce SRAM. Study the AVR distinction between ordinary data access and program-memory access before hiding it behind helper macros.

## EEPROM
EEPROM is persistent but has different access semantics and write endurance. Exercise 11 provides the practical path.

## Practice
For one firmware build, account for Flash and SRAM use, identify the stack start, and explain where every global/static object is initialized from and stored at runtime.
