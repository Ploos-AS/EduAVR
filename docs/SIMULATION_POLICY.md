# Simulation-first qualification policy

EduAVR uses simulation wherever the property being tested is a deterministic property of the AVR program or modeled MCU.

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

### Q2 — Hardware checkpoint

Runs on a real ATmega1284P/STK500 when the lesson depends on the physical world:

- programming/ISP connection;
- LEDs and switches;
- electrical GPIO behaviour;
- clock/timing accuracy;
- real serial electrical interface;
- ADC and analog behaviour;
- external SPI/I2C devices;
- switch bounce;
- reset/power behaviour;
- other board-specific or electrical behaviour.

## Rule

Do not require physical hardware merely to repeat a property already proven at Q0/Q1.

Do not claim a hardware property from simulation.

Each lab states the highest qualification layer it requires.

This keeps EduAVR accessible to students without hardware while preserving explicit real-hardware checkpoints for the things a simulator cannot prove.
