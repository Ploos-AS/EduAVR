# Exercise 16 — DIP switches and binary input

## Metadata
- **Mode:** SIM → BOARD
- **Level:** 1 Beginner
- **Primary language phase:** ASM → C
- **Hardware:** EduBoard-AVR DIP0..DIP3 and LED0..LED7/DISP0
- **Qualification:** Q1 + Q2
- **Concepts:** binary representation, masks, shifts, static inputs, lookup/display

## Learning objectives
Read multiple static digital inputs as a binary value, use masks/shifts, and connect physical switch positions to binary, hexadecimal and decimal representations.

## Mental model
```text
DIP3 DIP2 DIP1 DIP0 -> input bits -> 4-bit value -> binary/hex/decimal -> LEDs/display
  8    4    2    1
```

## Part A — Assembly / Q1
Read the documented DIP inputs, mask the relevant bits and form a value 0..15. Display the value on LEDs. If inputs are not contiguous, explicitly assemble the value with bit operations.

## Part B — C / Q1
Implement the same operation in direct register-level C. Compare compiler output with your masks/shifts.

## Under the hood
```text
physical switches -> PIN bits -> AND/shift/branch instructions -> numeric value -> output
```

## Part C — Board / Q2
Try all 16 switch combinations. Record physical ON/OFF polarity and confirm the numeric interpretation. Use DISP0 later if desired, but the LED-bank version must remain sufficient.

## Task
Use the four switches to select one of 16 LED patterns or parameter values.

## Expected result
Each physical switch combination maps deterministically to one 4-bit value.

## Questions
- Why is a group of switches naturally represented as bits?
- What is a mask?
- Why might board wiring make logical ON electrically low?
- How would non-contiguous GPIO pins change the code?
- Why is this useful for configuration inputs?

## Challenge
Treat the same four bits as two 2-bit fields and decode each independently.

## Qualification boundary
Q1 covers bit manipulation and modeled inputs. Q2 confirms physical switch polarity, isolation and mapping.
