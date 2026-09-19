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

The published navigation currently contains eleven core chapters in each language:

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
11. TWI/I2C.

ADC and EEPROM are **not yet published core chapters**.

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
- EEPROM.

This means EEPROM implementation and qualification are ahead of the published curriculum.

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

ADC has no equivalent core example or Q1 qualification yet.

## Published appendices

Both language tracks currently publish appendices A-I:

- A — AVR and Arduino;
- B — Debugging;
- C — Disassembly and reverse engineering;
- D — C, Assembly and compiler behaviour;
- E — Memory internals;
- F — Programming and bootloaders;
- G — Electronics;
- H — Protocol analysis;
- I — Reading AVR datasheets.

The broader roadmap also describes future appendices J-M and Course 2 security material. Those are roadmap scope, not current published-course completion.

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
- **M5:** started. EEPROM implementation and Q1 evidence exist, but ADC is missing and neither ADC nor EEPROM is yet a published core chapter.
- **M6-M8:** planned/incremental; not complete.
- **M9/Q2:** board convergence is in progress; physical qualification remains separate.

## Known reconciliation items / next work

1. Promote EEPROM from implementation-only material to a bilingual core lesson and add it to MkDocs navigation.
2. Design and validate ADC simulation support before making a Q1 claim; analog/electrical accuracy remains Q2.
3. Continue language-parity checks as new chapters are added.
4. Expand appendices J-M only when their actual Markdown content exists.
5. Add real EduBoard CAD/Q2 visuals only from stable board revisions and physical evidence.

This file should be updated whenever a milestone changes materially. The executable tests and CI are authoritative for qualification claims; the published navigation is authoritative for what is currently part of the course.
