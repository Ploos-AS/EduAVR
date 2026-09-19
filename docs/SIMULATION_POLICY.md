# Simulation-first qualification policy

EduAVR uses simulation wherever the property being tested is a deterministic property of the AVR program or modeled MCU.

Simulation is a first-class course environment. Lessons, examples and automated qualification should support it as far as the available simulator can faithfully model the behavior being taught.

## Qualification layers

### Q0 — Build and static inspection

Runs without an MCU:

- compile and link ASM and C;
- create HEX/ELF;
- disassemble;
- inspect size and sections;
- warnings and structural checks.

### Q1 — Simulator qualification

Runs in simavr where the required ATmega1284P feature is modeled:

- CPU instruction behaviour;
- control flow;
- stack/subroutines;
- SRAM operations;
- GPIO register logic;
- interrupt and timer logic when supported by the model;
- UART/SPI/I2C logic when the simulated peripheral path is sufficient;
- firmware state machines;
- debugger exercises.

Q1 is the default runtime qualification for course software.

Where practical, new lessons and examples should include a reproducible Q1 path and automated simulator checks. Hardware availability should not unnecessarily block learning, development or CI.

### Q2 — Hardware checkpoint

Runs on a real ATmega1284P/STK500 or another explicitly documented physical target when the lesson depends on the physical world:

- programming/ISP connection;
- LEDs and switches as physical devices;
- electrical GPIO behaviour;
- clock/timing accuracy;
- real serial electrical interface;
- ADC and analog behaviour;
- external SPI/I2C devices;
- switch bounce;
- reset/power behaviour;
- other board-specific or electrical behaviour.

A Q2 checkpoint may be required when the learning objective itself concerns these properties. Otherwise it should complement Q1 rather than replace it.

## Rules

1. Prefer Q1 for runtime qualification whenever the required behavior is modeled sufficiently.
2. Design lessons and examples so simulator use is possible to the greatest practical extent.
3. Do not require physical hardware merely to repeat a property already proven at Q0/Q1.
4. Do not claim a hardware property from simulation.
5. State the qualification boundary in each lab where it matters.
6. Keep simulator tests reproducible enough to run locally and in CI where practical.
7. If the simulator cannot model a required property reliably, document that limitation explicitly and move only that claim to Q2.

This keeps EduAVR accessible without hardware while preserving explicit real-hardware checkpoints for the properties a simulator cannot prove.
