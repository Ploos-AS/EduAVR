# Exercise 17 — HD44780 LCD from protocol to C driver

## Metadata
- **Mode:** SIM → BOARD
- **Level:** 2 Intermediate
- **Primary language phase:** ASM → C
- **Hardware:** EduBoard-AVR LCD0 / HD44780-compatible 16x2 module
- **Qualification:** Q1 + Q2
- **Concepts:** 4-bit parallel bus, command/data protocol, timing, state, reusable driver abstraction

## Learning objectives
Understand the LCD protocol before using a driver, transfer bytes over a 4-bit interface, distinguish commands from character data, and build a small C abstraction whose hardware actions remain understandable.

## Mental model
```text
byte -> high nibble -> D4..D7 --+
       low nibble -> D4..D7 ---+-> E pulse -> LCD controller
RS ---------------- command/data
RW ---------------- direction (if used)
```

## Short theory
An HD44780-compatible module contains its own controller. In 4-bit mode each byte is transferred as two nibbles. Control lines tell the module whether the byte is a command or display data, and timing/initialization requirements are part of the protocol.

## Part A — Assembly / Q1
Using the documented LCD0 mapping, implement the essential 4-bit write primitive: place a nibble, set RS appropriately and generate the enable pulse. Build initialization and send one character.

## Observe
Trace one character from its byte value through high/low nibbles and GPIO changes. Write down the exact order before running.

## Part B — C / Q1
Implement a minimal driver with operations such as `lcd_command`, `lcd_data`, `lcd_putc` and `lcd_puts`. Disassemble `lcd_putc` and relate it back to the assembly primitive.

## Under the hood
```text
lcd_putc('A') -> byte/nibbles -> PORT writes -> RS/E/D4..D7 -> LCD controller -> pixels
```
The C API is useful only after the learner understands the bus transactions it hides.

## Part C — Board / Q2
Attach a compatible 16x2 module to LCD0, set contrast and verify initialization, text output and cursor/clear commands. Record actual jumper/shared-pin configuration.

## Task
Display a counter or ADC value while another board task continues.

## Expected result
The LCD displays stable text produced through the learner's own protocol implementation rather than an opaque framework.

## Questions
- Why are two transfers needed per byte in 4-bit mode?
- What does RS select?
- What does the enable pulse mean?
- Why does initialization order matter?
- Which timing assumptions can simulation not physically qualify?
- What useful complexity does the C driver hide after we understand it?

## Challenge
Add cursor positioning and a fixed-width numeric output routine without using a third-party LCD library.

## Qualification boundary
Q1 covers protocol/control logic where modeled. Q2 validates actual module timing, contrast, wiring and display behavior.
