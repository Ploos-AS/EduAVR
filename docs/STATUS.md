# EduAVR implementation status

This is the repository-level status snapshot. It distinguishes published course material, executable examples and qualification evidence so that planned material is not confused with implemented material.

## Current baseline

- Reference MCU: ATmega1284P-PU.
- Primary course board: EduBoard-AVR; Atmel STK500 remains supported.
- Languages: English and Norwegian are equal first-class tracks.
- Method: Assembly first, equivalent register-level C, then generated-assembly inspection.
- Q1 simulation is the default runtime qualification; electrical/physical claims remain Q2.
- The development environment is available as a Debian-based OCI image and is qualified by CI.
- Markdown is the source of truth for the MkDocs/GitHub Pages course.

## Published core course

The published navigation currently contains eighteen core chapters in each language:

1. course principles;
2. toolchain;
3. AVR architecture;
4. GPIO;
5. stack and functions;
6. timers and interrupts;
7. PWM;
8. USART;
9. dual-UART bridge;
10. SPI;
11. TWI/I2C;
12. EEPROM;
13. ADC;
14. pointers, buffers and structs;
15. volatile, interrupts and atomicity;
16. SRAM and stack resource budgets;
17. optimization and generated code;
18. code size and SRAM analysis.

## Executable paired C/Assembly examples

The build currently contains paired C and hand-written Assembly firmware for:

- blink;
- GPIO;
- stack/functions;
- Timer0 interrupt;
- PWM;
- USART0 polling echo;
- USART0 interrupt/ring buffer;
- USART1 polling echo;
- USART1 interrupt/ring buffer;
- dual-UART polling bridge;
- dual-UART interrupt/ring-buffer bridge;
- robust USART;
- SPI;
- TWI/I2C;
- EEPROM;
- ADC;
- data structures;
- shared ISR/main state;
- SRAM/stack resource budgeting;
- optimization-level comparison and generated-code analysis;
- reproducible code-size and static-SRAM analysis.

EEPROM and ADC implementation, qualification and published curriculum are now aligned.

## Q1 simulator qualification

Current automated Q1 evidence covers:

| Area | Q1 evidence |
| --- | --- |
| Blink | execution plus GDB/ELF inspection |
| GPIO | deterministic DDRB/PORTB state plus PINB observation |
| Stack/functions/ABI | argument/result flow, stack movement and restored SP |
| Timer0 | compare ISR reaches stable probe |
| PWM | configuration plus modeled OC0A/PB3 edges and ~25% duty cycle |
| USART0/1 polling | deterministic RX -> firmware -> TX |
| USART0/1 IRQ | deterministic interrupt/ring-buffer data path |
| Dual UART | bidirectional polling and IRQ/ring-buffer data paths |
| Robust USART | normal modeled data path; no unsupported electrical/error-injection claim |
| SPI | controller configuration plus virtual peripheral transfer |
| TWI/I2C | controller configuration plus virtual EEPROM roundtrip |
| EEPROM | paired firmware writes 0x5a at address 0x12 and reads 0x5a back |
| ADC | paired firmware converts modeled ADC0 2500 mV input to approximately 775 |
| Data structures | deterministic buffer, pointer, struct layout and sum state |
| Shared state | Timer0 interrupt progress plus coherent protected 16-bit snapshot in paired C/Assembly |
| Resource budget | paired C/Assembly stack-depth observation, balanced SP and deterministic worker result |
| Optimization | O0/Os/O2 plus Assembly preserve deterministic weighted-sum result; ELF `.text` is measurable |
| Code/SRAM analysis | reproducible ELF section/symbol report plus explicit static-SRAM/Flash budgeting model |

## Published appendices

Both language tracks now publish appendices A-M, plus an extended datasheet-reading guide:

- A — AVR and Arduino;
- B — Debugging;
- C — Disassembly and reverse engineering;
- D — C, Assembly and compiler behaviour;
- E — Memory internals;
- F — Programming and bootloaders;
- G — Electronics;
- H — Protocol analysis;
- I — Performance and optimization;
- J — Testing and qualification;
- K — Build your own AVR board;
- L — AVR for retro computing;
- M — Datasheet survival guide;
- Extended guide — Reading AVR datasheets.

Appendices A-M have now completed a semantic EN/NO parity pass. The extended datasheet-reading guide also exists in both languages. Future edits must preserve this parity; publication or file presence alone is not sufficient. Course 2 security material remains roadmap scope.

## Infrastructure

Implemented repository infrastructure includes:

- reproducible AVR-GCC/Binutils/avr-libc/AVRDUDE toolchain;
- simavr and avr-gdb Q1 qualification;
- native Debian workflow;
- OCI development image usable with Docker or Podman;
- container CI that repeats M1/Q0 and Q1 before publishing the image;
- MkDocs Material site generated from Markdown;
- strict documentation build;
- GitHub Pages deployment;
- automated V1/Q1 visual-source artifacts based on real build/debug evidence.

## Milestone interpretation

- **M0:** complete.
- **M1:** complete and CI-qualified.
- **M2:** substantially implemented and represented in the published bilingual core.
- **M3:** substantially implemented with Q1 timers/interrupts/PWM evidence.
- **M4:** substantially implemented with Q1 USART/SPI/TWI evidence.
- **M5:** complete at Q1/course level. EEPROM and ADC both have paired C/Assembly examples, deterministic simulator evidence and bilingual core lessons. Physical ADC behavior remains Q2.
- **M6:** in progress with five published bilingual lessons: data structures, volatile/interrupt atomicity, SRAM/stack resource budgeting, optimization/code analysis, and code-size/static-SRAM analysis. The latter has a reproducible `make analyze` report; dynamic stack remains separately qualified.
- **M7-M8:** planned/incremental; not complete.
- **M9/Q2:** board convergence is in progress; physical qualification remains separate.

## Recent course changes

- Core lesson source filenames have been normalized to match the published lesson numbering: 09–16 now use matching `09-` through `16-` prefixes in both language tracks.
- The course outline now maps planned core expansion explicitly to M7/M8.
- Learner-facing changelog and project-documentation license pages are now part of the published site.

## Known reconciliation items / next work

1. Continue language-parity checks as new chapters are added.
2. Extend M6 with broader code-size/SRAM analysis after the optimization lesson.
3. Preserve semantic EN/NO parity for appendices A-M and the extended datasheet-reading guide as they evolve.
4. Add real EduBoard CAD/Q2 visuals only from stable board revisions and physical evidence.

This file should be updated whenever a milestone changes materially. The executable tests and CI are authoritative for qualification claims; the published navigation is authoritative for what is currently part of the course.
