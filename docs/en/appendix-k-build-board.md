# Appendix K — Build your own AVR board

## Purpose
Reduce a development board to the understandable minimum and then add infrastructure deliberately.

## Stage 1 — Minimum system
Start from the ATmega1284P-PU datasheet and identify power pins, ground, AVCC/AREF requirements, RESET, clock choices and ISP.

## Stage 2 — Breadboard
Build a conservative minimal system with decoupling, reset/programming access and a known clock strategy. Verify power before inserting/programming the MCU.

## Stage 3 — Bring-up
1. inspect for shorts/polarity errors;
2. verify rails;
3. verify reset;
4. verify clock assumptions;
5. identify/program the MCU through ISP;
6. run a minimal GPIO test.

## Stage 4 — Add peripherals
Add one function at a time: LED/button, UART, ADC source, buses and driver stages. Re-test after each addition.

## Stage 5 — PCB
Translate the working architecture into schematic/PCB while preserving decoupling, return paths, programming access, test points and readable connectors.

## EduBoard connection
EduBoard-AVR is the course reference implementation of these principles, but this appendix teaches how to reason about a minimal AVR board rather than merely copying its PCB.

## Qualification
Keep breadboard/PCB observations distinct. Record schematic revision, board revision, programmer, supply and firmware used for bring-up.
