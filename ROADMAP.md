# EduAVR Roadmap

## M0 — Foundation
- Define course identity and learning philosophy
- ATmega1284P-PU as first reference MCU
- Atmel STK500 as first reference board
- English and Norwegian course tracks
- Open-source command-line toolchain
- Assembly and C taught side by side
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

## M7 — Networking / Home Assistant
Ethernet experiments, MQTT concepts and Home Assistant integration.

## M8 — Capstones
Serial/retro gateway, sensor node, protocol/debug tool and terminal/BBS controller candidates.

## M9 — EduAVR Trainer
Design a maker-friendly educational board after STK500-based course requirements are validated.

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

## Security lab infrastructure
Planned controlled targets include `unsafe-copy`, `off-by-one`, `integer-wrap`, `stack-corruption`, `uart-parser`, `ringbuffer-overrun` and `eeprom-trust`. Labs must remain deterministic, educational and isolated from real-world targets.

Course 1 remains the current implementation priority. Course 2 infrastructure should reuse the reproducible OCI toolchain, simulator-first qualification and C/AVR-assembly comparison workflow.
