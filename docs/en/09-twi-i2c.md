# TWI / I2C

The ATmega1284P calls its I2C-compatible two-wire peripheral TWI. The bus uses SDA for data and SCL for clock, with open-drain/open-collector signaling and external pull-up resistors.

## Learning goals

Understand START and STOP conditions, addresses, read/write direction, ACK/NACK, bus status codes and the roles of TWBR, TWSR, TWAR, TWDR and TWCR. Implement the same controller transaction primitives in AVR assembly and C.

## First configuration

The paired examples configure TWI for approximately 100 kHz SCL with an 8 MHz CPU clock and prescaler 1. From the datasheet relation:

SCL = F_CPU / (16 + 2 * TWBR * prescaler)

TWBR=32 gives 100 kHz.

The first firmware milestone initializes the peripheral and exposes a stable qualification point. Later exercises add START, address, byte transfer, ACK handling and STOP.

## Qualification

Q0 builds and disassembles both versions. Q1 verifies modeled register configuration. Stronger Q1 data-path tests are added only where simavr models the relevant TWI behavior reliably. Q2 verifies the real SDA/SCL electrical bus, pull-ups, timing and external devices on STK500.
