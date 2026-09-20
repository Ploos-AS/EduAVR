# EduAVR Roadmap

## Current implementation status

- **M0:** complete.
- **M1:** complete; reproducible toolchain and CI qualification are active.
- **M2:** substantially implemented in bilingual course material, exercises and paired C/assembly examples.
- **M3:** substantially implemented; timer/interrupt/PWM paths are exercised by Q1.
- **M4:** substantially implemented; USART0/1 polling and IRQ/ring buffers, dual-UART bridges, SPI and TWI/I2C have Q1 coverage.
- **M5:** complete at published-course/Q1 level; EEPROM and ADC have paired C/Assembly implementations, deterministic Q1 evidence and bilingual core lessons. Physical analog/electrical behaviour remains Q2.
- **M6:** complete and CI-qualified at course/Q1 level (GitHub Actions run 524). Bilingual chapters and paired C/Assembly Q1 evidence cover data structures, ISR/main shared-state atomicity, SRAM/stack resource budgeting, optimization/code analysis, code/SRAM analysis, and an integrated systems capstone.
- **M7-M8:** planned/incremental material only; not complete.
- **M9/Q2:** in progress through EduBoard-AVR convergence; physical qualification remains separate from simulator claims.


## M0 — Foundation
- Define course identity and learning philosophy
- ATmega1284P-PU as first reference MCU
- EduBoard-AVR as the primary course board; Atmel STK500 retained as a supported reference/development platform
- English and Norwegian are equal first-class course tracks; substantive course/reference material must be kept in sync
- Open-source command-line toolchain
- Assembly first, then equivalent register-level C; generated assembly reconnects C to the hardware
- Arduino reserved for an appendix
- Establish licensing policy

## M1 — Reproducible toolchain
- Document Linux installation
- Verify avr-gcc, GNU AVR binutils, avr-libc, avrdude and make
- Add reproducible blink builds in assembly and C
- Add compiler-disassembly workflow
- Add automated host-side build checks

## M2 — AVR foundations
Architecture, memory, datasheet navigation, registers, instructions, stack, subroutines and GPIO labs.

## M3 — Timers and interrupts
Timers/counters, interrupt vectors, ISRs, PWM, generated-code analysis and timing.

## M4 — Communications
USART0/1, SPI, TWI/I2C, buffered serial I/O and terminal labs.

## M5 — Analog and persistent data
ADC, EEPROM, sensors and data acquisition.

## M6 — Systems programming
Pointers, structs, buffers, volatile, stack use, optimization and code/SRAM analysis.

Completed M6 extensions: **optimization and generated-code analysis** is lesson 17, **code-size and SRAM analysis** is lesson 18, and **integrated systems capstone** is lesson 19. The capstone combines Timer, ADC, EEPROM and USART in paired C/Assembly implementations with dedicated Q1 integration evidence. M6 is closed at the course/Q1 level; `tools/check_m6.sh` remains its regression gate and `docs/M6_QUALIFICATION.md` records the qualification boundary.

## M7 — Networking / Home Assistant

**Course outline mapping:** planned core expansion — networking, MQTT and Home Assistant integration.
Ethernet experiments, MQTT concepts and Home Assistant integration.

## M8 — Capstones

**Course outline mapping:** planned core expansion — final integrated/capstone projects.
Serial/retro gateway, sensor node, protocol/debug tool and terminal/BBS controller candidates.

## M9 — EduBoard-AVR convergence and qualification
EduBoard-AVR is developed in parallel with the course, not after it. Use board-validating exercises to feed requirements back into EduBoard before schematic/PCB freeze. After a stable Q2-qualified board revision exists, freeze the course hardware mapping and resume broad board-specific lesson expansion. STK500 remains a useful secondary/reference platform.

## Language parity
The canonical course is published in both **English (`docs/en`) and Norwegian (`docs/no`)**. Neither language is a reduced summary track. New or materially changed chapters, appendices and learner-facing reference material should receive equivalent content in both tracks; temporary translation lag should be treated as work-in-progress and not as completion.

## Appendices — reference and advanced practice
- **A — AVR and Arduino:** comprehensive mapping from Arduino IDE/CLI, sketches, libraries and bootloaders to registers, avr-gcc and generated assembly.
- **B — Debugging AVR:** avr-gdb, simavr, AVaRICE, breakpoints, registers, SRAM, stack, disassembly and ISR debugging.
- **C — Disassembly and reverse engineering:** ELF/HEX, sections, vectors, symbols, GCC patterns and controlled firmware-analysis labs.
- **D — C ↔ Assembly and compiler behaviour:** optimization levels, ABI, volatile, inlining, stack frames and code-generation analysis.
- **E — Memory internals:** Flash/SRAM/EEPROM, Harvard architecture, sections, startup, PROGMEM, stack and heap.
- **F — Programming and bootloaders:** ISP, STK500, AVRDUDE, fuses, lock bits, boot sections and recovery.
- **G — Electronics for AVR programmers:** pull-ups, current limits, debounce, drivers, level shifting, decoupling and clocks.
- **H — Protocol analysis:** UART/SPI/TWI captures with logic analyzers and correlation with firmware.
- **I — Performance and optimization:** cycles, latency, interrupt latency, size, SRAM and measured C/ASM comparisons.
- **J — Testing and qualification:** Q0 build/static, Q1 simulation, Q2 hardware, regression, CI and HIL.
- **K — Build your own AVR board:** minimal ATmega1284P system through breadboard and PCB.
- **L — AVR for retro computing:** serial bridges, terminal interfaces, protocol tools and retro gateways.
- **M — Datasheet survival guide:** register maps, timing diagrams, electrical characteristics and errata.

# Course 2 — EduAVR Secure Programming

**Working tagline:** *Embedded security from the silicon up.*

Course 2 builds on Course 1 and uses deliberately vulnerable firmware only in controlled EduAVR simulator/lab targets. The recurring lab method is **observe → reproduce → debug → fix → regression-test**.

## S1 — Embedded security foundations
Threat models, trust boundaries, AVR memory layout, attack surface and differences between embedded and hosted systems.

## S2 — Unsafe C and memory corruption
Arrays, pointers, length handling, off-by-one errors, unsafe copies, signedness and integer truncation.

## S3 — Stack internals
Stack pointer, call/return, local storage and return addresses, correlated with generated AVR assembly.

## S4 — Buffer-overflow labs
Deliberately vulnerable local firmware used to observe crashes and memory corruption with simavr/GDB.

## S5 — Stack-smashing analysis
Controlled simulator labs that demonstrate corrupted control flow and then trace it at instruction level.

## S6 — Defensive programming
Bounds checking, length-aware interfaces, input validation, safer parsers and remediation of the vulnerable labs.

## S7 — Integer vulnerabilities
Overflow/wraparound, signed/unsigned mistakes and unsafe size calculations.

## S8 — Parser and protocol security
Malformed UART frames, length fields, state machines, host-side fuzzing and regression tests.

## S9 — Interrupt and concurrency hazards
Shared ISR/main state, volatile, atomicity, race-like failures and defensive design.

## S10 — Firmware integrity
Flash/EEPROM trust, checksums/hashes, bootloader boundaries, lock/fuse capabilities and limitations.

## S11 — Hardening
Compiler diagnostics, host-side sanitizers where applicable, stack guards/canaries, assertions, watchdogs and fail-safe behaviour.

## S12 — Security qualification
Static analysis, host fuzzing, Q1 simulator regression and targeted Q2 hardware qualification.

## Course 2 appendices

### Appendix S-A — Extended debugging
Advanced debugging for security work: instruction-level GDB/simavr sessions, stack and SRAM forensics, watchpoints, corrupted-state reconstruction, interrupt-aware debugging, crash triage, fault localization, optimized-code debugging and repeatable debugger-driven security labs. Builds directly on Course 1 Appendix B.

### Appendix S-B — Extended reverse engineering
Advanced analysis of controlled AVR firmware: stripped ELF and raw HEX, vector-table reconstruction, function discovery, call/control-flow analysis, compiler idioms, data/code identification, peripheral-register inference, protocol-behaviour reconstruction and comparison of recovered behaviour with source. Builds directly on Course 1 Appendix C.

### Appendix S-C — Firmware forensics
Crash-state capture, SRAM/EEPROM inspection, persistent-state analysis, firmware/version identification, integrity evidence and reproducible incident-analysis exercises on EduAVR lab firmware.

### Appendix S-D — Fuzzing and adversarial testing
Host-side fuzz harnesses, corpus design, malformed serial/protocol inputs, deterministic reproduction, minimization of failing cases and replay against Q1 simulator targets.

The extended security appendices use only deliberately vulnerable or controlled EduAVR targets and focus on understanding, diagnosis, remediation and verification.

## Security lab infrastructure
Planned controlled targets include `unsafe-copy`, `off-by-one`, `integer-wrap`, `stack-corruption`, `uart-parser`, `ringbuffer-overrun` and `eeprom-trust`. Labs must remain deterministic, educational and isolated from real-world targets.

Course 1 remains the current implementation priority. Course 2 infrastructure should reuse the reproducible OCI toolchain, simulator-first qualification and C/AVR-assembly comparison workflow.
