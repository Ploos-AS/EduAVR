# Timers and interrupts

Timers let firmware react to time without wasting the CPU in delay loops. Interrupts let hardware events transfer control to an interrupt service routine (ISR).

## From clock to timer tick

For a timer driven from the CPU clock:

```text
timer frequency = CPU frequency / prescaler
tick period      = 1 / timer frequency
```

With an 8 MHz CPU clock and prescaler 64, the timer receives 125000 ticks per second, so one tick is 8 microseconds.

Always derive timing from the configured clock and registers rather than copying a magic constant.

## Polling first

Before interrupts, configure a timer and poll its status flag. This makes the hardware state visible:

1. configure timer mode;
2. choose clock/prescaler;
3. wait for a compare/overflow flag;
4. clear/acknowledge the flag as specified by the datasheet;
5. perform the action.

## Interrupts

An interrupt adds several concepts:

- interrupt vector;
- global interrupt enable;
- peripheral-specific interrupt enable;
- ISR entry/exit;
- saved machine state;
- `reti`;
- shared data between normal code and ISR.

In C, AVR-LibC provides the ISR machinery. In assembly, the programmer can see and manage the required state directly.

## volatile

A variable changed asynchronously by an ISR may need `volatile` so the compiler does not assume the value remains unchanged between accesses.

`volatile` does not make multi-byte access atomic and is not a general concurrency primitive. Later lessons examine those problems separately.

## ASM ↔ C

For each timer lab:

- configure the registers in assembly;
- configure the same registers in C;
- inspect compiler output;
- inspect the vector/ISR code;
- compare register saving and restoration;
- observe timer state and ISR execution in the simulator.

## Qualification

Timer register logic and modeled interrupt behavior are Q1 when simavr models the required peripheral behavior.

Real oscillator accuracy, electrical outputs and board-level timing measurements require Q2.
