# USART — bytes between machines

The ATmega1284P has two USARTs. That makes it especially useful for learning serial communication and later building bridges between a development terminal and another computer.

## Start with the wire format

For a common asynchronous 8N1 link, each character is transmitted as:

- one start bit;
- eight data bits;
- no parity bit;
- one stop bit.

Both ends must agree on parameters such as baud rate and frame format.

## Baud-rate generator

The USART derives its bit timing from the MCU clock and a baud-rate divisor. Calculate the required UBRR value from the datasheet formula, then calculate the resulting baud error.

Do not copy a UBRR constant without recording `F_CPU` and the selected USART mode.

## Transmit path

A minimal polling transmitter:

1. wait until the transmit data register is ready;
2. write one byte to the USART data register.

Implement this in AVR assembly and C, then compare the generated instructions.

## Receive path

A minimal polling receiver:

1. wait until receive-complete is set;
2. inspect error flags when relevant;
3. read the received byte.

Reading and writing peripheral registers can have side effects. The datasheet defines the required order.

## From polling to interrupts

Polling makes the mechanism easy to understand. Later, RX/TX interrupts and ring buffers allow useful work to continue while serial traffic arrives.

## Two USARTs

EduAVR initially uses one USART for terminal exercises. Later capstones can use both:

```text
PC/Linux terminal <-- USART0 --> ATmega1284P <-- USART1 --> retro computer/device
```

This creates a natural path toward terminal, BBS and retro serial gateway projects.

## Qualification

Q1 can verify register configuration, baud calculations, buffer/state-machine logic and simulated USART behavior where supported.

Q2 is required for electrical serial connections, level compatibility, cabling and measurements on real hardware.
