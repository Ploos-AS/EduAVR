# Dual-UART bridge: from polling to interrupts

!!! abstract "Learning goals"
    Explain why a bidirectional bridge needs independent receive/transmit paths, compare polling with interrupt-driven I/O, and describe why ring buffers matter when both sides can transmit at arbitrary times.

!!! info "Prerequisites"
    Complete [USART](07-usart.md) and understand polling, interrupts and basic ring-buffer concepts.

The ATmega1284P has two independent USARTs, making it useful as a protocol bridge between a modern PC and a retro computer, terminal, modem, radio or embedded device.

## Stage 1: polling bridge

The paired examples in `examples/c/dual-uart-bridge` and `examples/asm/dual-uart-bridge` configure USART0 and USART1 for 9600 baud, 8N1. The main loop checks each receiver and forwards each byte to the opposite transmitter.

This exposes hardware registers and control flow clearly, but waiting for one transmitter can delay servicing the other direction.

## Stage 2: interrupt-driven bridge

The examples in `examples/c/dual-uart-irq-bridge` and `examples/asm/dual-uart-irq-bridge` separate the data path into four events: USART0 RX, USART0 UDRE TX, USART1 RX and USART1 UDRE TX.

Receive ISRs place bytes into RX ring buffers. The foreground transfers them to the opposite TX ring buffer. UDRE ISRs drain those buffers when hardware is ready.

## Under the hood

Trace one byte through both implementations. Compare the polling loops with the interrupt vectors, ring-buffer head/tail updates and UDRE interrupt enable/disable logic.

## Try it

Run the Q1 harness and trace traffic in both directions. Then inspect what happens when producer and consumer rates differ.

!!! success "Expected result"
    Data injected into either modeled UART emerges byte-identically from the opposite UART, and you can explain the buffering and control flow that makes this possible.

## Qualification

EduAVR's simavr Q1 harness injects data into both virtual UARTs and requires byte-identical output from the opposite UART. Both polling and interrupt/ring-buffer implementations are qualified in C and AVR Assembly.

Q1 does **not** prove voltage levels, cabling, clock accuracy, signal integrity, RS-232 level conversion or physical STK500 behavior. Those belong to Q2.

## Practical lab topology

```text
PC / USB serial
      |
   USART0
 ATmega1284P
   USART1
      |
retro computer / terminal / device
```

Use TTL-level serial directly only where voltage levels are compatible. Real RS-232 equipment requires an appropriate level translator such as a MAX232-class interface.

## Exercises

1. Trace one byte from USART0 RX to USART1 TX in C and Assembly.
2. Identify every register involved in configuring both USARTs.
3. Explain what happens when an RX ring buffer becomes full.
4. Configure different baud rates on the two sides and explain why bridging remains possible.
5. Add counters for received, transmitted and dropped bytes.
6. Advanced: add a line-oriented command mode without corrupting transparent bridge traffic.

!!! tip "Next"
    Continue to [SPI](10-spi.md). Later capstone work can add flow control, error handling and configurable serial parameters.
