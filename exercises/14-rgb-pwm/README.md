# Exercise 14 — RGB LED and multi-channel PWM

## Metadata
- **Mode:** SIM → BOARD
- **Level:** 2 Intermediate
- **Primary language phase:** ASM → C
- **Hardware:** EduBoard-AVR RGB0
- **Qualification:** Q1 + Q2
- **Concepts:** multi-channel PWM, timer resources, duty cycle, RGB mixing, driver stages

## Learning objectives
Configure multiple PWM channels, reason about shared timer resources, mix RGB output with duty cycle, and distinguish the raw MCU PWM signal from the load-driver/LED result.

## Mental model
```text
timer(s) -> compare A/B -> PWM pins -> driver stages -> R/G/B LED channels
              ^                         |
        duty-cycle values          visible colour
```

## Part A — Assembly / Q1
Map RGB0's documented channels to timer/output-compare resources. Configure one channel first, then multiple channels. Produce several duty-cycle combinations and predict the resulting relative channel intensities.

## Part B — C / Q1
Implement a small `rgb_set(r,g,b)` abstraction using direct register-level control. Disassemble initialization and one update. Document where timer/channel constraints leak through the abstraction.

## Observe
Record timer, mode, prescaler and compare registers. Identify which channels share a timer and which settings therefore cannot be chosen independently.

## Under the hood
```text
rgb_set() -> compare registers -> OC outputs -> transistor drivers -> RGB0
```

## Part C — Board / Q2
Probe the raw PWM/test points where provided and observe RGB0. Compare raw MCU signal with the driven LED result. Verify several colour mixes and an all-off state.

## Task
Create a non-blocking colour fade through at least three colour regions.

## Expected result
Hardware PWM maintains channel outputs while software changes compare values at a much slower rate.

## Questions
- Which timer resources are shared?
- Why are driver stages used?
- Why is RGB colour not a precision measurement of duty cycle?
- What can be observed before versus after the driver?
- What would a blocking software-PWM implementation cost?

## Challenge
Implement gamma-corrected lookup values and compare perceived fades with linear duty-cycle steps.

## Qualification boundary
Q1 covers timer/register behavior. Q2 covers the physical PWM path, drivers and visible RGB output.
