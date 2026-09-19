# Exercise 06 — PWM

## Metadata
- **Mode:** SIM → BOARD
- **Level:** 2 Intermediate
- **Primary language phase:** ASM → C
- **Hardware:** EduBoard-AVR or STK500
- **Qualification:** Q1 + Q2
- **Concepts:** timer, PWM, compare registers, frequency, duty cycle

## Learning objectives
Explain PWM as timer-driven hardware behavior, calculate frequency/duty cycle, configure it without manually toggling a pin, and relate compare-register values to a measured output.

## Mental model
```text
clock -> prescaler -> timer counter ----+
                                        +-> compare logic -> OC pin -> waveform
compare register -----------------------+
```

## Short theory
PWM repeatedly compares a hardware counter with a programmed value. Once configured, the timer peripheral can drive the output pin while the CPU performs unrelated work.

## Part A — Assembly / Q1
Derive the required mode and prescaler from the datasheet. Configure the output pin and produce approximately 25% duty cycle. Inspect timer and compare registers.

Change to approximately 75% and predict the new compare value before running.

## Part B — C / Q1
Implement the same configuration with direct register-level C. Disassemble and compare the initialization with the hand-written assembly.

## Observe
Record TOP/range, prescaler, compare value, calculated PWM frequency and duty cycle. Explain which values affect frequency and which affect duty cycle.

## Under the hood
```text
C register writes -> AVR instructions -> timer registers
timer counter + compare hardware -> OC pin (without per-cycle CPU toggles)
```

## Part C — Board / Q2
Route the timer output to an accessible pin. Observe an LED and, where available, use a logic analyzer or oscilloscope. Record calculated and measured values.

## Task
Create three visibly different brightness levels without software delay loops.

## Expected result
Duty-cycle changes alter the output while the CPU does not manually generate each edge.

## Questions
- Why is PWM different from a delay-loop blink?
- Which hardware block generates the edges?
- Why can an LED demonstrate duty-cycle change but not accurately measure frequency?
- What does C hide in the configuration?
- Why is Q2 needed before claiming a waveform was physically produced?

## Challenge
Implement a slow fade by periodically changing the compare value while leaving PWM edge generation to hardware.

## Qualification boundary
Q1 validates configuration/model behavior. Q2 validates the real pin waveform and timing.
