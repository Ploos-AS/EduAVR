# Exercise 07 — USART0 terminal

Configure USART0 for a documented asynchronous 8N1 link.

## Q1

Implement polling transmit and receive in both AVR assembly and C.

Tasks:

1. choose a baud rate;
2. calculate UBRR from the configured `F_CPU`;
3. calculate actual baud rate and percentage error;
4. configure frame format;
5. implement `putchar`-style byte transmission;
6. implement byte reception;
7. build a one-byte echo loop;
8. inspect USART registers in avr-gdb;
9. compare hand-written ASM with compiler output.

Then replace the one-byte design with a small RX ring buffer driven by an interrupt. Explain why head/tail variables shared with an ISR need careful treatment.

## Q2 hardware checkpoint

Connect the selected STK500 serial path to a terminal using the correct electrical interface.

Verify:

- transmitted text;
- received characters;
- echo;
- selected baud/frame format;
- behavior with an intentionally mismatched baud rate.

Record the physical connection and level/interface assumptions.

Do not connect incompatible voltage standards directly.
