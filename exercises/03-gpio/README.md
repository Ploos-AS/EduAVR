# Exercise 03 — GPIO

## Metadata

- **Mode:** SIM → BOARD
- **Level:** 1 Beginner
- **Primary language phase:** ASM → C
- **Hardware:** EduBoard-AVR or STK500
- **Qualification:** Q1 + Q2
- **Concepts:** DDRx, PORTx, PINx, bit operations, input, output, pull-up

## Part A — Q1

Implement PB0 output control twice:

1. AVR assembly;
2. C.

Build and disassemble both. In avr-gdb, stop after GPIO initialization and inspect the relevant I/O state. Compare the generated C instructions with the hand-written implementation.

Then implement an active-low button decision using an input bit and explain the branch/control flow in both languages.

## Part B — Q2 hardware checkpoint

On the STK500:

- connect/use a board LED and switch according to the STK500 documentation;
- verify output on the LED;
- verify the input in released and pressed states;
- verify internal pull-up behavior where the selected connection permits it.

Record the actual port/pin wiring used. Do not assume PB0 is wired to a particular STK500 LED without checking the board setup.

## Boundary

Part A can pass without hardware. Part B is a hardware observation and cannot be replaced by simulator evidence.


## Under the hood

Relate the implementation back through the full EduAVR chain: **C (where used) → generated AVR instructions → registers/memory → peripheral behavior → physical result (where applicable)**. Explain compiler choices instead of expecting C and hand-written assembly to be instruction-for-instruction identical.
