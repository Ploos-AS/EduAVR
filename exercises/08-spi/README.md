# Exercise 08 — SPI

## Metadata

- **Mode:** SIM → BOARD
- **Level:** 2 Intermediate
- **Primary language phase:** ASM → C
- **Hardware:** EduBoard-AVR or STK500; SPI peripheral for Q2
- **Qualification:** Q1 + Q2
- **Concepts:** SPI, clock divider, controller mode, SPCR, SPSR, SPDR

1. Build the C and assembly SPI examples.
2. Identify DDRB, SPCR, SPSR and SPDR in source and disassembly.
3. Calculate the SPI clock for an 8 MHz CPU with F_CPU/16.
4. Change the divider and predict the new clock before rebuilding.
5. Compare the C transfer loop with the assembly implementation.
6. Explain why SS is configured as an output in controller mode.

Q1: configuration and modeled peripheral behavior. Q2: inspect SCK/MOSI/SS and communicate with a real SPI peripheral.


## Under the hood

Relate the implementation back through the full EduAVR chain: **C (where used) → generated AVR instructions → registers/memory → peripheral behavior → physical result (where applicable)**. Explain compiler choices instead of expecting C and hand-written assembly to be instruction-for-instruction identical.
