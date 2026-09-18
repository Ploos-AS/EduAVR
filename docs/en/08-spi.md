# SPI — Serial Peripheral Interface

SPI is the first synchronous serial bus in EduAVR. The ATmega1284P exposes MOSI, MISO, SCK and SS and can operate as controller or peripheral.

## Learning goals

After this lesson you should be able to explain full-duplex shifting, clock generation, chip select, CPOL/CPHA modes, and the relationship between SPCR, SPSR and SPDR. You should also be able to implement the same blocking byte transfer in AVR assembly and C and inspect the generated machine code.

## First configuration

The paired example configures SPI as controller, mode 0, MSB first, clock F_CPU/16. SS is configured as an output so the AVR remains in controller mode. MOSI and SCK are outputs and MISO is an input.

A transfer starts by writing a byte to SPDR. Hardware shifts one bit in and one bit out for each SCK edge. SPIF in SPSR indicates completion; reading SPDR then obtains the received byte.

## Qualification

Q0 builds and disassembles both implementations. Q1 verifies the modeled SPI register configuration in simavr. Q2 later verifies real pins, voltage levels, clock waveform and communication with an external SPI device on the STK500.

Simulation must not be used as evidence for electrical behavior.
