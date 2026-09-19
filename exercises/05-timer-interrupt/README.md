# Exercise 05 — Timer and interrupt

## Metadata

- **Mode:** SIM → BOARD
- **Level:** 2 Intermediate
- **Primary language phase:** ASM → C
- **Hardware:** EduBoard-AVR or STK500
- **Qualification:** Q1 + Q2
- **Concepts:** timers, polling, interrupts, vectors, ISR, timing

Use an ATmega1284P timer to create a periodic event.

## Part A — polling, Q1

Implement the timer setup in both AVR assembly and C. Poll a timer flag and increment a counter when the event occurs.

Calculate the expected timer period from `F_CPU`, prescaler and timer configuration before running the program.

Use simavr/avr-gdb to inspect:

- timer control registers;
- counter value;
- status flags;
- software counter.

## Part B — interrupt, Q1

Replace polling with an interrupt.

Implement/inspect:

- interrupt enable;
- vector;
- ISR;
- global interrupt enable;
- shared counter;
- ISR return.

In the C version, mark asynchronously changed state appropriately and inspect the generated ISR prologue/epilogue.

Compare the C ISR with a hand-written assembly ISR and explain which machine state is preserved.

## Part C — Q2 checkpoint

On the STK500, expose the periodic event on an LED or output pin and measure/observe it.

Compare observed timing with the calculated value. Record CPU clock assumptions and actual board configuration.

Q2 is required for claims about real timing accuracy; Q1 remains sufficient for modeled firmware behavior.


## Under the hood

Relate the implementation back through the full EduAVR chain: **C (where used) → generated AVR instructions → registers/memory → peripheral behavior → physical result (where applicable)**. Explain compiler choices instead of expecting C and hand-written assembly to be instruction-for-instruction identical.
