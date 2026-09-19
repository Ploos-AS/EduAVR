# EduAVR exercise/lab template

Every new teaching exercise should use this structure. Existing material should be migrated as it is touched.

## Metadata

- **Mode:** SIM | BOARD | SIM → BOARD
- **Level:** 1 Beginner | 2 Intermediate | 3 Advanced
- **Primary language phase:** ASM | ASM → C | C
- **Target:** ATmega1284P-PU
- **Hardware:** None | EduBoard-AVR | STK500 | external peripheral
- **Qualification:** Q1 simulator | Q2 hardware | Q1 + Q2
- **Concepts:** registers, flags, GPIO, timer, etc.

## Learning objectives

State what the student should understand and be able to explain after the exercise. Prefer observable mechanisms over API knowledge.

## Mental model / illustration

Include a small diagram, data-flow sketch, register/pin map, timing sketch or equivalent whenever it makes the mechanism easier to see.

Example:

```text
button -> MCU pin -> PINx bit -> AVR instruction -> branch
                                      |
                                      v
LED    <- MCU pin <- PORTx bit <- AVR instruction
```

## Short theory

Explain only the concepts needed for the exercise. Point to the relevant datasheet sections.

## Part A — Assembly

Start from the hardware/register model. Implement and inspect the mechanism directly in AVR assembly.

## Observe

Use simavr/avr-gdb or the physical board as appropriate. Ask the student to record register, flag, memory, timing, pin or signal observations.

## Part B — C

Only after the assembly mechanism is understood, implement the equivalent behaviour in C.

## Under the hood

Disassemble the C build and connect:

```text
C construct -> generated AVR instructions -> registers/memory -> peripheral -> physical result
```

The student should explain meaningful differences caused by compiler choices or optimization rather than expecting identical instruction sequences.

## Task

Give a concrete problem to solve rather than only asking the student to copy the worked example.

## Expected result

Describe observable success without giving away the complete solution.

## Questions

Include questions that test the connection between layers, for example:

- Which register changed, and why?
- Which AVR instruction caused that change?
- What does the equivalent C statement hide?
- What would be visible on the physical pin?
- What can the simulator prove, and what still needs hardware?

## Challenge

Provide an optional extension that changes one constraint or combines concepts.

## Qualification boundary

State explicitly which claims are supported by simulation and which require physical hardware.
