# EduAVR course outline

EduAVR teaches AVR from the hardware upward, with **Assembly and C side by side**.

!!! info "Single source of truth"
    This Markdown file and the course lessons are the course source. GitHub Pages generates the HTML edition directly from the Markdown sources.

## Current core course

1. [Course principles](00-course-principles.md)
2. [Open AVR toolchain](01-toolchain.md)
3. [AVR architecture](02-avr-architecture.md)
4. [GPIO](03-gpio.md)
5. [Stack and functions](04-stack-functions.md)
6. [Timers and interrupts](05-timers-interrupts.md)
7. [PWM](06-pwm.md)
8. [USART](07-usart.md)
9. [Dual-UART bridge](08-dual-uart-bridge.md)
10. [SPI](08-spi.md)
11. [TWI / I2C](09-twi-i2c.md)

## Planned core expansion

The original curriculum also identifies these topics for dedicated lessons as the course grows:

- ADC
- EEPROM
- buffers, pointers, structs and `volatile`
- compiler optimization and disassembly
- small reusable drivers
- systems integration
- capstone project

These are roadmap items rather than published core lessons until their Markdown lesson, examples and appropriate qualification evidence exist.

## Working method

Each lesson combines theory with practical inspection of the machine. Build C and Assembly, inspect disassembly, use simulation where it provides valid evidence, and move to physical hardware when the claim concerns electrical behavior.

## Reference appendices

Published appendices currently cover:

- **A — AVR and Arduino**
- **B — Debugging AVR**
- **C — Disassembly and reverse engineering**
- **D — C ↔ Assembly and compiler behaviour**
- **E — Memory internals**
- **F — Programming and bootloaders**
- **G — Electronics for AVR programmers**
- **H — Protocol analysis**

The curriculum also reserves future appendices for performance/optimization, testing/qualification, building an AVR board, retro-computing interfaces and datasheet reading. They should be added to the published course only when their Markdown sources exist.

The appendices are reference material and advanced practice. They can mature while EduBoard-AVR hardware is being stabilized because most are not tied to a moving board revision.
