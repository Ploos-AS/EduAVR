# Dual-UART bridge: from polling to interrupts

The ATmega1284P has two independent USARTs. That makes it useful as a small protocol bridge: one serial link can face a modern PC while the other faces a retro computer, terminal, modem, radio, or embedded device.

## Learning goals

After this lesson you should be able to explain why a bidirectional bridge needs independent receive and transmit paths, compare polling with interrupt-driven I/O, and describe why ring buffers matter when both sides can transmit at arbitrary times.

## Stage 1: polling bridge

The paired examples in `examples/c/dual-uart-bridge` and `examples/asm/dual-uart-bridge` configure USART0 and USART1 for 9600 baud, 8 data bits, no parity, one stop bit. The main loop checks each receiver and forwards each byte to the opposite transmitter.

This version is intentionally simple. It exposes the hardware registers and control flow clearly, but waiting for a transmitter can delay servicing the other direction.

## Stage 2: interrupt-driven bridge

The examples in `examples/c/dual-uart-irq-bridge` and `examples/asm/dual-uart-irq-bridge` separate the data path into four interrupt-driven events:

- USART0 receive
- USART0 data-register-empty transmit
- USART1 receive
- USART1 data-register-empty transmit

Receive ISRs put bytes into RX ring buffers. The foreground loop transfers bytes to the opposite TX ring buffer. UDRE ISRs drain those TX buffers when hardware is ready.

This structure allows reception and transmission on both interfaces to progress independently and is the basis for more advanced terminal and gateway software.

## Q1 simulator qualification

EduAVR's simavr Q1 harness injects data into both virtual UARTs and requires byte-identical output from the opposite UART. Both the polling and interrupt/ring-buffer implementations are qualified in C and AVR assembly.

Q1 proves modeled firmware behavior. It does **not** prove voltage levels, cabling, clock accuracy, signal integrity, RS-232 level conversion, or behavior of a physical STK500. Those belong to Q2 hardware qualification.

## Practical lab topology

A useful physical experiment is:

```text
PC / USB serial
      |
   USART0
 ATmega1284P
   USART1
      |
retro computer / terminal / device
```

Use TTL-level serial only where voltage levels are compatible. Real RS-232 equipment requires an appropriate level translator such as a MAX232-class interface.

## Exercises

1. Trace one byte from USART0 RX to USART1 TX in both C and assembly.
2. Identify every register involved in configuring both USARTs.
3. Explain what happens when an RX ring buffer becomes full.
4. Change one side to a different baud rate and explain why the bridge can still translate between the two asynchronous links.
5. Add counters for received, transmitted, and dropped bytes.
6. Advanced: add a simple line-oriented command mode without corrupting transparent bridge traffic.

The next progression is flow control, error/status handling, configurable serial parameters, and eventually the retro terminal/gateway capstone.
