# Exercise 15 — Passive buzzer and timer-generated tone

## Metadata
- **Mode:** SIM → BOARD
- **Level:** 2 Intermediate
- **Primary language phase:** ASM → C
- **Hardware:** EduBoard-AVR BUZZ0
- **Qualification:** Q1 + Q2
- **Concepts:** timer compare, frequency, output toggle, passive piezo, non-blocking sequencing

## Learning objectives
Calculate a timer-generated square-wave frequency, drive a passive piezo without bit-banging every edge, and relate timer compare values to audible pitch.

## Mental model
```text
CPU clock -> prescaler -> timer compare -> OC pin -> driver -> passive piezo -> sound
```

## Part A — Assembly / Q1
Choose a timer compare/toggle mode and calculate values for several musical or test frequencies. Configure BUZZ0's documented timer output and verify modeled output timing.

## Part B — C / Q1
Create `tone_start(frequency)` and `tone_stop()` using direct register-level C. Inspect generated calculations/register writes and identify rounding limits.

## Under the hood
```text
frequency request -> timer math -> compare register -> hardware toggles -> BUZZ0
```

## Part C — Board / Q2
Probe the raw timer output where provided, then enable the buzzer driver. Measure or estimate frequency and listen to several tones.

## Task
Play a short sequence without blocking the main program; an LED counter or button task must continue while tones change.

## Expected result
The timer generates tone edges independently while application code schedules note changes.

## Questions
- Why must BUZZ0 be passive for this lesson?
- How do prescaler and compare value determine frequency?
- Why is the raw OC signal pedagogically useful?
- Why may requested and actual frequency differ?
- Why avoid delay-loop tone generation?

## Challenge
Build a small note table containing frequency and duration and play it with timer/state-machine scheduling.

## Qualification boundary
Q1 validates timer calculations/control. Q2 validates the physical driver, piezo and audible/measured frequency.
