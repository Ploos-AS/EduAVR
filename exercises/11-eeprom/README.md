# Exercise 11 — EEPROM: data that survives reset

## Metadata
- **Mode:** SIM → BOARD
- **Level:** 2 Intermediate
- **Primary language phase:** ASM → C
- **Hardware:** EduBoard-AVR or STK500
- **Qualification:** Q1 + Q2
- **Concepts:** EEPROM, persistence, write sequence, wear, reset/power cycle

## Learning objectives
Distinguish Flash, SRAM and EEPROM; perform a controlled EEPROM read/write; explain persistence and understand why EEPROM writes should not be treated like ordinary RAM stores.

## Mental model
```text
Flash: program code
SRAM:  working state ---- lost on reset/power loss
EEPROM: persistent bytes -> explicit read/write controller -> survives reset
```

## Short theory
EEPROM is non-volatile but has different timing and endurance characteristics from SRAM. AVR hardware uses dedicated control registers and a protected write sequence.

## Part A — Assembly / Q1
Write one byte to a selected EEPROM address using the documented sequence, wait for completion and read it back. Observe the control flow and registers.

## Part B — C / Q1
Implement equivalent behavior using the appropriate AVR mechanisms and inspect generated code/library calls. Connect the high-level operation back to the hardware sequence.

## Under the hood
```text
C persistent setting -> EEPROM helper/register sequence -> EEPROM cell
reset -> startup -> EEPROM read -> restored program state
```

## Part C — Board / Q2
Store a small setting, reset/power-cycle the board and demonstrate that the value is recovered while an SRAM-only variable is not.

## Task
Store the last selected LED pattern or mode and restore it at startup.

## Expected result
The EEPROM-backed setting persists across reset/power-cycle; transient SRAM state does not.

## Questions
- Why not store every changing variable in EEPROM?
- What is the difference between EEPROM and SRAM?
- Why is the write sequence protected?
- What failure could occur if power disappears during a write?
- What can Q2 demonstrate that Q1 cannot?

## Challenge
Store a small structure with a version byte and checksum so invalid/uninitialized data can be detected.

## Qualification boundary
Q1 covers software/register behavior where modeled. Q2 demonstrates persistence on real hardware and reset/power behavior.
