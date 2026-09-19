# Exercise 09 — TWI / I2C

## Metadata
- **Mode:** SIM → BOARD
- **Level:** 2 Intermediate
- **Primary language phase:** ASM → C
- **Hardware:** EduBoard-AVR or STK500; I2C peripheral for Q2
- **Qualification:** Q1 + Q2
- **Concepts:** TWI/I2C, pull-ups, bus clock, TWBR, TWSR, TWCR

## Learning objectives
Explain open-drain/open-collector bus behavior and pull-ups, calculate a TWI clock, follow START/address/data/STOP states and connect status codes to protocol progress.

## Mental model
```text
VCC -- pull-up --+-- SDA <-> controller/peripheral open-drain drivers
                 |
VCC -- pull-up --+-- SCL <-> bus clock/control

software -> TWCR/TWDR -> TWI state machine -> SDA/SCL
                    <- TWSR status <--------
```

## Short theory
Unlike a push-pull GPIO output, I2C/TWI devices normally pull a line low and rely on pull-up resistors for the high state. The AVR TWI peripheral implements much of the protocol state machine, while software responds to status states.

## Part A — Assembly / Q1
Calculate TWBR for 100 kHz at F_CPU=8 MHz with prescaler 1. Configure the peripheral and step through a simple controller transaction sequence: START, address, data and STOP.

## Observe
Record TWBR, TWSR and TWCR at meaningful states. Draw the protocol sequence next to the status transitions.

## Part B — C / Q1
Implement equivalent register-level initialization/transaction logic in C. Disassemble initialization and one state transition.

Calculate the nominal setting for 400 kHz and discuss why a mathematically valid register value does not guarantee a reliable physical bus.

## Under the hood
```text
C operation -> TWCR/TWDR writes -> TWI state machine -> SDA/SCL
           <- TWSR status       <- bus events
```

## Part C — Board / Q2
Connect an external TWI/I2C peripheral using suitable pull-ups. Verify addressing and a simple transfer. Where possible, inspect SDA/SCL with a logic analyzer.

## Task
Read or write one simple register on a known peripheral and document the complete address/data transaction.

## Expected result
The software state sequence matches the protocol transaction, while Q2 demonstrates that the electrical bus and external device actually operate.

## Questions
- Why are pull-ups required?
- Why can multiple devices share SDA/SCL?
- What information does TWSR provide?
- Why does 400 kHz place greater demands on the physical bus?
- Which parts can a simulator not prove?

## Challenge
Add error handling for an unexpected status/NACK and return a meaningful result to the caller.

## Qualification boundary
Q1 covers modeled register/state-machine behavior. Q2 covers pull-ups, rise time, physical timing and communication with a real peripheral.
