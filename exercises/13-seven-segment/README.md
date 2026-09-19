# Exercise 13 — Multiplexed 7-segment display

## Metadata
- **Mode:** SIM → BOARD
- **Level:** 2 Intermediate
- **Primary language phase:** ASM → C
- **Hardware:** EduBoard-AVR 4-digit 7-segment display
- **Qualification:** Q1 + Q2
- **Concepts:** lookup tables, GPIO, multiplexing, timers, persistence of vision

## Learning objectives
Map numeric values to segments, explain multiplexing, use a timer to refresh multiple digits and understand why apparent simultaneous illumination is produced by time sharing.

## Mental model
```text
number -> segment lookup -> segment GPIO ----+
digit index -> digit select GPIO ------------+-> one physical digit at a time
timer tick -> next digit -> repeat fast -> perceived multi-digit display
```

## Short theory
A multiplexed display shares segment lines between digits. Firmware selects one digit and its segment pattern at a time, cycling fast enough to appear continuous.

## Part A — Assembly / Q1
Create a segment lookup table for 0–9. Implement one-digit output, then a timer-driven scan index for four digits.

## Part B — C / Q1
Implement the same display buffer and refresh logic in C. Inspect array/table access and ISR output.

## Under the hood
```text
display buffer -> lookup/table access -> PORT writes -> segment/digit drivers
timer interrupt -> scan index -> next physical digit
```

## Part C — Board / Q2
Display a four-digit value. Observe what happens when refresh rate is intentionally made too slow, then select a suitable rate.

## Task
Display a four-digit counter updated by the main program while timer-driven refresh continues independently.

## Expected result
All four digits appear stable at a suitable refresh rate even though only one digit is actively selected at a time.

## Questions
- Why multiplex instead of dedicating pins to every LED segment?
- What determines refresh/flicker?
- Why should display refresh be separated from application logic?
- Where does the digit-to-segment mapping live?
- What physical effects can Q1 not establish?

## Challenge
Add a non-blocking brightness control by changing the active portion of each scan period.

## Qualification boundary
Q1 covers buffer, lookup and scan logic. Q2 is required for visible flicker, brightness and real display behavior.
