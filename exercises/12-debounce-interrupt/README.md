# Exercise 12 — Switch bounce, INTx and PCINT

## Metadata
- **Mode:** SIM → BOARD
- **Level:** 2 Intermediate
- **Primary language phase:** ASM → C
- **Hardware:** EduBoard-AVR pushbutton or STK500 switch
- **Qualification:** Q1 + Q2
- **Concepts:** INTx, PCINT, interrupt vectors, switch bounce, debounce, state machines, timing

## Learning objectives
Explain why a physical switch may generate multiple transitions, distinguish the AVR's dedicated external interrupts (INTx) from pin-change interrupts (PCINT), choose an appropriate mechanism, and implement debounce without confusing ideal simulator input with physical switch behavior.

## Mental model
```text
ideal press:    ____|--------
real switch:    ____|_|-|_---
                    bounce

dedicated pin -> INTx edge/level logic -> vector --+
GPIO group ---> PCINT change detect ----> vector --+-> ISR -> event -> debounce -> application
```

## Short theory
Mechanical contacts do not necessarily change state once. Bounce is a physical phenomenon. The ATmega1284P also offers two related but different ways to react to external digital changes: dedicated INTx inputs with configurable triggering, and grouped PCINT sources that report changes on enabled pins. PCINT software may need to determine which pin changed.

## Part A — INTx in assembly / Q1
Configure one dedicated external interrupt source. Document the selected trigger condition and vector. Implement a minimal ISR that records an event rather than doing lengthy work inside the ISR.

Single-step or inspect the interrupt path and identify the enable, flag, sense-control and global-interrupt mechanisms involved.

## Part B — PCINT in assembly / Q1
Configure one pin-change interrupt source. Identify its PCINT group/vector and mask bit. Trigger a controlled change and explain why grouped pin-change handling may require comparing current and previous input state.

## Compare INTx and PCINT
Record:
- which pins can use each mechanism;
- vector granularity;
- trigger capabilities;
- configuration/mask registers;
- what the ISR knows automatically;
- when INTx is preferable;
- when PCINT is preferable.

The goal is not to declare one mechanism universally better, but to understand the hardware trade-off.

## Part C — C + debounce / Q1
Implement equivalent interrupt handling in direct register-level C and add a timer/state-based debounce strategy. Disassemble the ISR and inspect shared state. Feed controlled repeated transitions where practical and verify that the application produces one logical press.

## Under the hood
```text
pin -> INTx/PCINT hardware -> flag/vector -> ISR -> shared event state
timer/time policy -> debounce decision -> one logical button press
```

Trace the C configuration back to the relevant interrupt-control, mask and flag registers.

## Part D — Board / Q2
Use a real EduBoard-AVR pushbutton path documented for interrupt experiments. First observe/count raw transitions, then enable debounce and compare behavior. If the board exposes both an INTx route and a PCINT-capable button route, repeat the logical experiment with both. A logic analyzer/oscilloscope is useful but not required.

## Task
Make each physical press advance an LED pattern exactly once. Document whether the implementation uses INTx or PCINT and why.

## Expected result
Without debounce, some presses may be observed as multiple transitions. The debounced design produces one application event per intended press, while INTx and PCINT reach that application through different interrupt hardware.

## Questions
- Why should an ISR normally be short?
- What is the architectural difference between INTx and PCINT?
- Why may a PCINT ISR need to determine which pin changed?
- Why is switch bounce impossible to prove from an ideal digital model alone?
- What is the difference between an electrical edge and a logical button event?
- Why is a state/timer approach preferable to a long blocking delay?
- Which shared variables require special care?

## Challenge
Support short press and long press without blocking the main loop, then move the input between an INTx and PCINT implementation while preserving the application-level interface.

## Qualification boundary
Q1 validates interrupt selection, control flow and debounce logic with controlled inputs. Q2 is required to characterize real mechanical bounce and the physical EduBoard button routing.
