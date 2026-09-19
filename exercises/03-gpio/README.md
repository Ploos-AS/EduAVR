# Exercise 03 — GPIO

## Metadata
- **Mode:** SIM → BOARD
- **Level:** 1 Beginner
- **Primary language phase:** ASM → C
- **Hardware:** EduBoard-AVR or STK500
- **Qualification:** Q1 + Q2
- **Concepts:** DDRx, PORTx, PINx, bit operations, input, output, pull-up

## Learning objectives
Explain the difference between DDRx, PORTx and PINx; configure a pin without a framework; read an active-low button; and connect register changes to voltage/LED behavior on a physical pin.

## Mental model
```text
button -> MCU pin -> PINx bit -> test/branch -> PORTx bit -> output driver -> LED
                         ^                         ^
                       input                     state
DDRx ---------------- determines input/output ---+
```

## Short theory
A GPIO pin is controlled by registers, not by a `digitalWrite` concept inside the MCU. DDRx selects direction, PORTx controls output state or an input pull-up, and PINx reports input state. EduAVR deliberately exposes these layers first.

## Part A — Assembly / Q1
Configure PB0 as an output and another suitable pin as an active-low input with pull-up. Implement LED control from the input using explicit bit operations and branches.

Single-step initialization and the decision path. Observe DDR, PORT and PIN state.

## Observe
Before executing each configuration instruction, predict the register value after it. Draw the path from the simulated input bit to the branch and output bit.

## Part B — C / Q1
Implement the same behavior using direct register-level C. Disassemble it and identify the instructions corresponding to direction setup, pull-up, input test and output update.

## Part C — Board / Q2
On EduBoard-AVR or STK500, connect the documented LED and switch path. Record the actual pins used. Verify released/pressed input states and LED output. Where applicable, repeat with the internal pull-up disabled and explain the result.

## Under the hood
```text
C bit expression -> generated SBI/CBI/IN/OUT/etc. -> DDRx/PORTx/PINx -> pin -> LED/button
```
The exact instructions depend on register location and compiler choices.

## Task
Make the LED turn on only while the button is pressed, then invert the behavior without changing the wiring.

## Expected result
The simulated register behavior and physical board behavior should implement the same logic. Physical observations must be recorded separately from simulator observations.

## Questions
- Why are DDRx and PORTx separate registers?
- Why does an active-low button read 0 when pressed?
- What does enabling a pull-up physically accomplish?
- Which statement in the C version hides the most hardware detail?
- Which part can Q1 establish, and which requires Q2?

## Challenge
Use two buttons to select four LED states using only register-level operations.

## Qualification boundary
Q1 establishes firmware/register behavior. Q2 is required for claims about LEDs, switches, pull-ups, wiring and electrical behavior.
