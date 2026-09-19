# Timers and interrupts

!!! abstract "Learning goals"
    Understand timer ticks, prescalers, compare/overflow events, interrupt vectors and the difference between polling and interrupt-driven firmware.

!!! info "Prerequisites"
    You should understand registers, control flow, the stack and basic AVR I/O configuration.

## From clock to timer tick

For a timer driven from the CPU clock:

```text
timer frequency = CPU frequency / prescaler
tick period      = 1 / timer frequency
```

With an 8 MHz CPU clock and prescaler 64, the timer receives 125000 ticks per second, so one tick is 8 microseconds.

Always derive timing from the configured clock and registers rather than copying a magic constant.

## Polling first

Before interrupts, configure a timer and poll its status flag:

1. configure timer mode;
2. choose clock/prescaler;
3. wait for a compare/overflow flag;
4. clear or acknowledge the flag as specified by the datasheet;
5. perform the action.

## Interrupts

An interrupt introduces an interrupt vector, global and peripheral interrupt enables, ISR entry/exit, saved machine state, `reti`, and data shared between foreground code and the ISR.

In C, AVR-LibC provides ISR machinery. In Assembly, the programmer can see and manage the required state directly.

## volatile

A variable changed asynchronously by an ISR may need `volatile` so the compiler does not assume it remains unchanged between accesses.

`volatile` does not make multi-byte access atomic and is not a general concurrency primitive.

## Under the hood

Configure the same timer in Assembly and C. Inspect the compiler output and vector/ISR code, then compare register saving/restoration and the instructions used to acknowledge the timer event.

## Try it

Implement a compare-match experiment first with polling and then with an ISR. Observe timer state and control flow in the simulator.

!!! success "Expected result"
    You can derive the timer tick from `F_CPU` and the prescaler, identify the interrupt vector, and explain the modeled transition into and out of the ISR.

## Qualification

Timer register logic and modeled interrupt behavior are Q1 where simavr models the required peripheral behavior. Real oscillator accuracy, electrical outputs and board-level timing measurements require Q2.

## Check your understanding

1. What does the prescaler change?
2. Why should an ISR normally be short?
3. Why can `volatile` be necessary?
4. What can Q1 not prove about a physical timer output?

!!! tip "Next"
    Continue to [PWM](06-pwm.md).
