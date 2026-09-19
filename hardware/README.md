# Hardware

## Reference platform

- MCU: **ATmega1284P-PU**
- Primary course board: **EduBoard-AVR**
- Supported reference/development board: **Atmel STK500**

EduBoard-AVR is developed in parallel with EduAVR. Simulator and STK500 work are used to validate firmware and course requirements early, while board-validating exercises feed requirements back into EduBoard before schematic/PCB freeze.

## Qualification boundary

- **Q0** — build/static/toolchain checks.
- **Q1** — modeled runtime behavior in simavr.
- **Q2** — physical hardware qualification.

Q2 is required for claims involving ISP/programming, voltage levels, pull-ups, signal integrity, oscillator/baud accuracy, ADC behavior, real external SPI/TWI devices, reset/power behavior and other electrical properties.

STK500 remains useful for targeted physical labs and reference testing. After a stable Q2-qualified EduBoard-AVR revision exists, the course hardware mapping can be frozen around that board.
