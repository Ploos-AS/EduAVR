# Exercise 07 — USART0 terminal

## Metadata
- **Mode:** SIM → BOARD
- **Level:** 2 Intermediate
- **Primary language phase:** ASM → C
- **Hardware:** EduBoard-AVR or STK500 with serial interface
- **Qualification:** Q1 + Q2
- **Concepts:** USART, baud rate, polling, interrupts, ring buffer

## Learning objectives
Calculate a baud configuration, configure an asynchronous 8N1 USART, transmit/receive bytes, explain polling versus interrupt-driven reception and connect firmware bytes to a terminal.

## Mental model
```text
CPU byte -> data register -> USART shift logic -> TX pin ---> terminal
terminal ---> RX pin -> USART shift logic -> data register -> CPU
                               |
                          status/interrupt
```

## Short theory
The USART converts parallel bytes used by the CPU into timed serial bits and back. Baud configuration is derived from the CPU clock; framing determines how receiver and transmitter interpret the bit stream.

## Part A — Assembly polling / Q1
Choose a baud rate, calculate UBRR, actual baud and percentage error. Configure 8N1, transmit bytes, receive a byte and build an echo loop.

## Observe
Inspect USART control/status and data-register behavior. Identify which status bit tells software when transmission/reception can proceed.

## Part B — C / Q1
Implement the same polling link in register-level C and inspect compiler output.

Then add interrupt-driven receive with a small ring buffer. Draw head/tail movement for at least four received bytes.

## Under the hood
```text
C putchar -> status test/instructions -> UDR -> USART shifter -> TX pin
RX pin -> USART shifter -> RX interrupt -> ISR -> SRAM ring buffer -> main
```

## Part C — Board / Q2
Connect the correct serial interface to a terminal. Verify transmit, receive and echo. Intentionally select a mismatched baud rate and describe the visible failure. Record electrical/level assumptions.

## Task
Build a tiny command interface accepting one-character commands to turn an LED on/off and return a textual status.

## Expected result
Correct settings produce readable bidirectional communication; a deliberate mismatch demonstrates why timing/configuration must agree.

## Questions
- Why is UBRR derived from F_CPU?
- What is framing?
- What does polling prevent the CPU from doing efficiently?
- Why do ISR/main ring-buffer variables need careful treatment?
- Why must TTL/CMOS UART and RS-232 voltage levels not be assumed identical?

## Challenge
Implement a non-blocking line receiver using the ring buffer and recognize a short command terminated by Enter.

## Qualification boundary
Q1 covers firmware/model behavior. Q2 is required for physical serial levels, wiring and real terminal communication.
