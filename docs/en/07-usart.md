# USART — bytes between machines

!!! abstract "Learning goals"
    Understand 8N1 framing, baud-rate generation, polling-based transmit/receive, and how the same USART mechanism is expressed in AVR Assembly and C.

!!! info "Prerequisites"
    You should understand register I/O, bit masks, polling and basic interrupt concepts.

The ATmega1284P has two USARTs, making it useful for serial communication and later bridges between a development terminal and other machines.

## 8N1

A common asynchronous 8N1 link sends one start bit, eight data bits, no parity and one stop bit. Both ends must agree on baud rate and frame format.

## Baud-rate generator

Calculate UBRR from the datasheet formula and then calculate the resulting baud error. Do not copy a UBRR constant without documenting `F_CPU` and the selected USART mode.

## Transmit and receive

A minimal polling transmitter waits until the transmit data register is ready and writes one byte. A minimal receiver waits for receive-complete, checks relevant error flags and reads the received byte.

Peripheral-register accesses can have side effects; the datasheet defines the required read order.

## ASM ↔ C

Implement the same polling operation in AVR Assembly and C. Compare the register accesses and generated machine instructions.

## Under the hood

Identify the C expressions that become the polling loop, status-register test and data-register access. Separate the language abstraction from the USART hardware that performs the serial transfer.

## From polling to interrupts

RX/TX interrupts and ring buffers allow useful foreground work while traffic arrives.

## Two USARTs

```text
PC/Linux terminal <-- USART0 --> ATmega1284P <-- USART1 --> retro computer/device
```

This leads naturally to terminal, BBS and retro serial gateway projects.

## Try it

Build the C and Assembly examples. Derive the baud configuration from `F_CPU`, trace one transmitted and one received byte, and compare instruction flow.

!!! success "Expected result"
    You can explain the frame format, derive the baud configuration and identify the register accesses that transmit and receive a byte.

## Qualification

Q1 can verify register configuration, baud calculations, buffer/state-machine logic and simulated USART behavior where supported. Q2 is required for electrical serial connections, level compatibility, cabling and physical measurements.

## Check your understanding

1. What does 8N1 mean?
2. Why must `F_CPU` be known?
3. What pedagogical advantage does polling provide?
4. What must be tested physically in Q2?

!!! tip "Next"
    Continue to [Dual-UART bridge](09-dual-uart-bridge.md).
