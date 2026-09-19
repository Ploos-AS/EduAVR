# EduAVR course outline

1. Microcontrollers and ATmega1284P
2. Toolchain: build, flash and inspect
3. AVR architecture and memory
4. AVR assembly fundamentals
5. C on a microcontroller
6. GPIO
7. Functions, stack and calling conventions
8. Timers and counters
9. Interrupts
10. PWM
11. USART and terminals
12. ADC
13. SPI
14. TWI/I2C
15. EEPROM
16. Buffers, pointers, structs and volatile
17. Compiler optimization and disassembly
18. Small reusable drivers
19. Systems integration
20. Capstone

## Reference appendices

- **A — AVR and Arduino** — framework abstractions mapped back to AVR hardware/toolchain.
- **B — Debugging AVR** — avr-gdb, simulation and hardware-debug workflows.
- **C — Disassembly and reverse engineering** — ELF/HEX, vectors, symbols and controlled firmware analysis.
- **D — C ↔ Assembly and compiler behaviour** — ABI, volatile, optimization and generated code.
- **E — Memory internals** — Flash, SRAM, EEPROM, sections, startup, stack and PROGMEM.
- **F — Programming and bootloaders** — ISP, AVRDUDE, fuses, lock bits, boot sections and recovery.
- **G — Electronics for AVR programmers** — inputs, loads, drivers, decoupling, clocks and voltage domains.
- **H — Protocol analysis** — UART/SPI/TWI captures correlated with firmware.
- **I — Performance and optimization** — cycles, latency, size, SRAM and measurement.
- **J — Testing and qualification** — Q0/Q1/Q2, regression, CI and HIL.
- **K — Build your own AVR board** — minimum system, breadboard, bring-up and PCB.
- **L — AVR for retro computing** — observable serial/protocol bridges and retro interfaces.
- **M — Datasheet survival guide** — registers, timing, electrical tables and errata.

The appendices are reference material and advanced practice. They can mature while EduBoard-AVR hardware is being stabilized because most are not tied to a moving board revision.
