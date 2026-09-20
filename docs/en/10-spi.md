# SPI — Serial Peripheral Interface

!!! abstract "Learning goals"
    Explain full-duplex shifting, clocking, chip select and CPOL/CPHA, and implement the same blocking byte transfer in AVR Assembly and C.

!!! info "Prerequisites"
    You should understand GPIO direction, polling and peripheral registers.

SPI is a synchronous serial bus. The ATmega1284P exposes MOSI, MISO, SCK and SS and can operate as controller or peripheral.

## First configuration

The paired examples configure SPI as controller, mode 0, MSB first and clock `F_CPU/16`. SS is configured as an output so the AVR remains in controller mode. MOSI and SCK are outputs while MISO is an input.

A transfer starts by writing a byte to SPDR. Hardware shifts one bit in and one bit out for each SCK edge. SPIF in SPSR indicates completion; SPDR then contains the received byte.

## Under the hood

Compare the C and Assembly versions and identify operations configuring DDR, SPCR and, where relevant, SPSR. Trace one byte from the write to SPDR, through polling SPIF, to reading the received data.

## Try it

Build both implementations and trace a blocking byte transfer. Then change the clock setting and identify which register bits change.

!!! success "Expected result"
    You can explain why one SPI transfer both transmits and receives data and identify the registers controlling and reporting the transfer.

## Qualification

Q0 builds and disassembles both implementations. Q1 verifies modeled SPI register configuration in simavr. Q2 verifies real pins, voltage levels, clock waveform and communication with an external SPI device.

## Check your understanding

1. Why is SPI called full-duplex?
2. What does chip select do?
3. What do CPOL and CPHA specify?
4. Why can simulation not qualify the electrical SCK waveform?

!!! tip "Next"
    Continue to [TWI / I2C](09-twi-i2c.md).
