# TWI / I2C

!!! abstract "Learning goals"
    Understand START/STOP, addressing, read/write direction, ACK/NACK and status codes, and implement basic controller primitives in AVR Assembly and C.

!!! info "Prerequisites"
    You should understand GPIO, peripheral registers and basic serial communication.

The ATmega1284P calls its I2C-compatible two-wire peripheral TWI. The bus uses SDA for data and SCL for clock, with open-drain/open-collector signaling and external pull-up resistors.

## First configuration

The paired examples configure TWI for approximately 100 kHz SCL with an 8 MHz CPU clock and prescaler 1:

```text
SCL = F_CPU / (16 + 2 * TWBR * prescaler)
```

With `TWBR=32`, the result is 100 kHz.

The first firmware milestone initializes the peripheral and provides a stable qualification point. Later exercises add START, address, byte transfer, ACK handling and STOP.

## Register model

Follow the roles of TWBR, TWSR, TWAR, TWDR and TWCR. Status codes connect firmware control flow to the current phase of the bus transaction.

## Under the hood

Compare the C and Assembly versions. Identify the register write setting the bitrate and the control bits starting a TWI operation. Relate status polling to the corresponding machine-code control flow.

## Try it

Build both versions, calculate the expected SCL frequency and trace the initialization sequence. Extend the analysis with START and status handling where the example supports it.

!!! success "Expected result"
    You can explain how the bitrate is calculated and which TWI registers carry control, status and data.

## Qualification

Q0 builds and disassembles both versions. Q1 verifies modeled register configuration. Stronger Q1 data-path tests are used only where simavr models the relevant TWI behavior reliably. Q2 verifies the real SDA/SCL bus, pull-ups, timing and external devices.

## Check your understanding

1. Why do SDA and SCL require pull-up resistors?
2. What is the difference between ACK and NACK?
3. Why are status codes important?
4. Which aspects of a physical I2C bus require Q2?

!!! tip "Next"
    This concludes the current communications core. Continue with the appendices and practical exercises.
