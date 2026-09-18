# Exercise 06 — PWM

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
