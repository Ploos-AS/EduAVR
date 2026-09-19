# Appendix I — Reading AVR datasheets

!!! abstract "Learning goals"
    Learn to use a microcontroller datasheet as the primary hardware reference: find peripheral chapters, register descriptions, bit fields, timing information, electrical limits and the details that turn a programming task into correct register operations.

## The datasheet is part of the programming model

Register-level AVR development is impossible to do reliably from memory alone. The datasheet explains what the hardware can do, which registers control it, which bits have side effects, and which timing and electrical constraints apply.

Treat examples and tutorials as guides; treat the datasheet as the authoritative description of the selected MCU.

## Start from the task

When implementing a feature, translate the task into questions:

1. Which peripheral performs this function?
2. Which pins does it use?
3. Which registers configure it?
4. Which bits select the required mode?
5. Which status flags report progress or errors?
6. Are there ordering requirements or side effects?
7. Which clock source and timing formulas apply?
8. Does the claim require simulator evidence or physical measurement?

## A practical reading path

For an unfamiliar peripheral, use this order:

1. **Features / overview** — understand the peripheral's purpose and terminology.
2. **Block diagram** — see the data path and major functional units.
3. **Pin multiplexing** — determine which MCU pins carry the signals.
4. **Functional description** — understand modes and state transitions.
5. **Register description** — map the behavior to registers and bits.
6. **Timing / formulas** — calculate baud rate, timer periods, bus frequency, etc.
7. **Interrupts and flags** — identify events, vectors and flag-clearing rules.
8. **Electrical characteristics** — use these only when reasoning about the physical device.
9. **Errata** — check whether documented silicon issues affect the feature.

## Reading a register table

For every register, record:

- address;
- reset value;
- read/write properties;
- bit names;
- reserved bits;
- side effects;
- relationships to other registers.

Never assume that writing a 1 clears a flag, that a reserved bit can be written freely, or that register reads are side-effect free. Check the description.

## Example: USART

To configure a USART, locate the USART chapter and answer:

- Which UBRR registers set baud rate?
- How is UBRR calculated from `F_CPU`?
- Which bits enable RX and TX?
- Which bits select frame format?
- Which status flag says the transmit data register is ready?
- Which flags report receive errors?
- In what order must status and data registers be read?

Only after answering these questions should the configuration become C or Assembly.

## Datasheet ↔ Assembly ↔ C

A useful exercise is to build a three-column mental model:

| Datasheet statement | Assembly | C |
| --- | --- | --- |
| Set a control bit | load/mask/store or bit instruction | register bit-mask expression |
| Wait for a flag | read/test/branch | polling loop |
| Write peripheral data | store to I/O/data-space address | assignment to register macro |

The compiler does not replace the datasheet. C register macros simply give symbolic names to the same hardware registers.

## Simulator boundary

The datasheet describes the real device. A simulator implements a model of only part of that behavior.

Use the datasheet to define the expected MCU behavior, then verify at Q1 only what the simulator models reliably. Electrical characteristics, analog accuracy and other physical properties remain Q2.

## Exercises

1. Find the ATmega1284P GPIO direction register for Port B and explain every bit.
2. Find the Timer0 prescaler table and derive the timer tick for an 8 MHz CPU clock.
3. Find the USART baud-rate formula and calculate the setting for 9600 baud.
4. Find the SPI clock-selection table and identify the bits selecting `F_CPU/16`.
5. Find one register with a flag whose clearing behavior requires careful reading.
6. Find the device errata section and explain why it belongs in the implementation workflow.

!!! tip "Habit to keep"
    When a lesson mentions a register, open the corresponding datasheet chapter. Learning to navigate the datasheet is itself a core embedded-development skill.
