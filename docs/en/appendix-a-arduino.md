# Appendix A — AVR and Arduino

This appendix is intentionally outside the register-level core. Arduino is neither required nor the reference implementation.

## Purpose
After learning the MCU directly, map familiar Arduino abstractions back to the ATmega1284P hardware, avr-gcc toolchain and generated AVR instructions.

## Mapping table

| Arduino concept | AVR view |
| --- | --- |
| `pinMode()` | DDRx direction bits |
| `digitalRead()` | PINx input register |
| `digitalWrite()` | PORTx output/pull-up behavior |
| `analogRead()` | ADC mux/control/result registers |
| `analogWrite()` where supported | timer/output-compare PWM |
| `Serial` | USART registers, baud generator, polling/interrupts |
| `SPI` | native SPI registers and pins |
| `Wire` | TWI/I2C peripheral |
| `delay()` | framework timing facilities |
| `millis()` | timer interrupt plus software time state |
| `setup()/loop()` | framework startup plus repeated application control flow |

## Build stack
Treat an Arduino sketch as source entering a larger build/runtime framework. Inspect verbose build output and identify framework code, compiler, assembler, linker, ELF/HEX production and upload/programming tool.

## Comparison exercise
Implement the same LED/button behavior three ways: direct AVR assembly, direct register-level C, and Arduino API. Disassemble the builds and compare initialization, code size and peripheral configuration.

## Serial and timers
Compare a minimal direct USART implementation with `Serial`. Identify hardware versus library policy. Arduino runtime services can own/depend on timers, so determine resource ownership before mixing direct timer programming with framework functions.

## Bootloaders
An Arduino-style bootloader is one programming approach, not a requirement of AVR. Relate it to Appendix F's ISP, boot-section and fuse discussion.

## Goal
The learner should be able to use Arduino when convenient while still answering: **which AVR peripheral, registers and generated instructions implement this abstraction?**
