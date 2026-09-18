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

## Appendix A — AVR and Arduino
Map Arduino concepts to the AVR hardware already learned. Arduino is not required for the course.
