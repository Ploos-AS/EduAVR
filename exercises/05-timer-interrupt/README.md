# Exercise 05 — Timer and interrupt

## Metadata
- **Mode:** SIM → BOARD
- **Level:** 2 Intermediate
- **Primary language phase:** ASM → C
- **Hardware:** EduBoard-AVR or STK500
- **Qualification:** Q1 + Q2
- **Concepts:** timers, polling, interrupts, vectors, ISR, timing

## Learning objectives
Derive a timer period, configure a timer directly, distinguish polling from interrupts, follow interrupt control flow and connect an ISR to a periodic physical event.

## Mental model
```text
CPU clock -> prescaler -> timer counter -> compare/overflow -> flag
                                                     |
                          polling <-------------------+
                          interrupt -> vector -> ISR -> RETI
```

## Short theory
A hardware timer counts independently of ordinary instruction flow. Software may repeatedly poll a flag or let the timer request an interrupt. Interrupts redirect execution through a vector and require carefully preserved machine state.

## Part A — Assembly polling / Q1
Choose a timer configuration and calculate its expected period before running anything. Configure it in assembly, poll the event flag and increment a software counter.

## Observe
Watch control registers, timer count, event flag and software counter. Compare the observed event interval with your calculation.

## Part B — Assembly interrupt / Q1
Replace polling with an ISR. Identify the vector, enable source and global interrupts, preserve required state and return with the appropriate instruction.

## Part C — C / Q1
Implement the same interrupt-driven behavior in C. Mark shared asynchronous state appropriately. Disassemble the ISR and identify compiler-generated prologue/epilogue work.

## Under the hood
```text
C ISR declaration -> vector entry -> generated save/restore -> ISR body -> RETI
timer hardware -> interrupt request -> CPU control-flow change
```

## Part D — Board / Q2
Expose the periodic event on an LED or output pin. Record configured clock, prescaler and timer values. Observe or measure the period and compare it with the calculation.

## Task
Produce a 1 Hz visible state change using a timer rather than a software delay loop.

## Expected result
The main program can perform other work while the timer/ISR maintains the periodic event.

## Questions
- What work does the timer perform without CPU instructions?
- Why is polling wasteful in some designs?
- What is the purpose of the interrupt vector?
- Why must an ISR preserve state?
- Why can simulation validate logic but not oscillator accuracy?

## Challenge
Run two software activities at different rates from one hardware timer tick without blocking delays.

## Qualification boundary
Q1 establishes modeled timer/interrupt behavior. Q2 is required for real timing, oscillator and physical output claims.
