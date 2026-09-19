# Exercise 12 — Switch bounce and external interrupts

## Metadata
- **Mode:** SIM → BOARD
- **Level:** 2 Intermediate
- **Primary language phase:** ASM → C
- **Hardware:** EduBoard-AVR pushbutton or STK500 switch
- **Qualification:** Q1 + Q2
- **Concepts:** external/pin interrupts, switch bounce, debounce, state machines, timing

## Learning objectives
Explain why a physical switch may generate multiple transitions, configure an interrupt source and implement debounce without confusing electrical behavior with ideal simulator input.

## Mental model
```text
ideal press:    ____|--------
real switch:    ____|_|-|_---
                    bounce

pin -> interrupt flag/vector -> ISR -> event state -> debounce logic -> application
```

## Short theory
Mechanical contacts do not necessarily change state once. Bounce is a physical phenomenon. Interrupts can detect transitions quickly, but software must decide which transitions represent one user action.

## Part A — Assembly / Q1
Configure a suitable interrupt source. Implement a minimal ISR that records an event rather than doing lengthy work inside the ISR.

## Part B — C / Q1
Implement equivalent interrupt handling and a timer/state-based debounce strategy. Disassemble the ISR and inspect shared state.

## Observe
Feed controlled simulated transitions where practical, including deliberately repeated transitions. Verify that the application counts one logical press.

## Under the hood
```text
pin edge -> interrupt hardware -> vector -> ISR -> shared event state
timer/time policy -> debounce decision -> one logical button press
```

## Part C — Board / Q2
Use a real pushbutton. First observe/count raw transitions, then enable debounce and compare behavior. A logic analyzer/oscilloscope is useful but not required for the basic observation.

## Task
Make each physical press advance an LED pattern exactly once.

## Expected result
Without debounce, some presses may be observed as multiple transitions; the debounced design produces one application event per intended press.

## Questions
- Why should an ISR normally be short?
- Why is switch bounce impossible to prove from an ideal digital model alone?
- What is the difference between an electrical edge and a logical button event?
- Why is a state/timer approach preferable to a long blocking delay?
- Which shared variables require special care?

## Challenge
Support short press and long press without blocking the main loop.

## Qualification boundary
Q1 validates interrupt/debounce logic with controlled inputs. Q2 is required to characterize real mechanical bounce.
