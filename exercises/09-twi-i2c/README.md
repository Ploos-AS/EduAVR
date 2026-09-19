# Exercise 09 — TWI / I2C

## Metadata

- **Mode:** SIM → BOARD
- **Level:** 2 Intermediate
- **Primary language phase:** ASM → C
- **Hardware:** EduBoard-AVR or STK500; I2C peripheral for Q2
- **Qualification:** Q1 + Q2
- **Concepts:** TWI/I2C, pull-ups, bus clock, TWBR, TWSR, TWCR

1. Build the C and assembly examples.
2. Locate TWBR, TWSR and TWCR in source and disassembly.
3. Calculate TWBR for 100 kHz at F_CPU=8 MHz with prescaler 1.
4. Calculate the value for 400 kHz and discuss practical bus limitations.
5. Explain why SDA and SCL require pull-ups on real hardware.
6. Compare the C initialization with the assembly instructions.

Q1 covers modeled configuration. Q2 covers electrical signaling, pull-ups, real timing and communication with an external TWI/I2C peripheral.


## Under the hood

Relate the implementation back through the full EduAVR chain: **C (where used) → generated AVR instructions → registers/memory → peripheral behavior → physical result (where applicable)**. Explain compiler choices instead of expecting C and hand-written assembly to be instruction-for-instruction identical.
