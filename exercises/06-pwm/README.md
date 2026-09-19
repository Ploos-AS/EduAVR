# Exercise 06 — PWM

## Metadata

- **Mode:** SIM → BOARD
- **Level:** 2 Intermediate
- **Primary language phase:** ASM → C
- **Hardware:** EduBoard-AVR or STK500
- **Qualification:** Q1 + Q2
- **Concepts:** timer, PWM, compare registers, frequency, duty cycle

Configure an ATmega1284P timer for PWM in both AVR assembly and C.

## Q1

- derive the timer mode and prescaler from the datasheet;
- configure the output pin;
- start with approximately 25% duty cycle;
- inspect the timer and compare registers in avr-gdb;
- change to approximately 75%;
- compare hand-written ASM with compiler-generated code;
- explain why the CPU does not need to toggle the output every cycle.

Do not claim an electrical waveform solely from register values.

## Q2 hardware checkpoint

Route the timer output to an STK500-accessible pin.

Observe the signal with an LED and, where available, an oscilloscope or logic analyzer. Record:

- configured CPU clock;
- prescaler;
- PWM mode;
- compare value;
- calculated frequency/duty cycle;
- measured frequency/duty cycle.

Explain any difference between calculated and measured values.


## Under the hood

Relate the implementation back through the full EduAVR chain: **C (where used) → generated AVR instructions → registers/memory → peripheral behavior → physical result (where applicable)**. Explain compiler choices instead of expecting C and hand-written assembly to be instruction-for-instruction identical.
