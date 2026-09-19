# Exercises

EduAVR exercises reinforce register-level AVR work and the connection from hardware to software.

All new exercises use [TEMPLATE.md](TEMPLATE.md). Existing exercises are being migrated to the same structure.

## Classification

Every exercise must declare one mode:

- **SIM** — CPU state, registers, flags, SRAM, stack, instruction flow, timing models and interrupt behavior are the main observations.
- **BOARD** — the lesson depends primarily on physical I/O or electrical behavior.
- **SIM → BOARD** — understand and verify the mechanism in simulation first, then observe the physical result.

Assembly is taught before the equivalent C abstraction. When C appears, an **Under the hood** section should connect compiler-generated AVR instructions back to registers, memory, peripherals and pins.

## Current exercise set

- 02 — registers and arithmetic
- 03 — GPIO
- 04 — AVR-GCC calling convention
- 05 — timers and interrupts
- 06 — PWM
- 07 — USART
- 08 — SPI
- 09 — TWI/I2C
- 10 — ADC
- 11 — EEPROM
- 12 — switch bounce, INTx and PCINT
- 13 — multiplexed seven-segment display
- 14 — RGB LED and multi-channel PWM
- 15 — passive buzzer and timer-generated tone
- 16 — DIP switches and binary input
- 17 — HD44780 LCD protocol and driver

Exercises 10–17 deliberately validate the EduBoard-AVR teaching-peripheral contract as well as teach firmware concepts.

## Board-development boundary

EduBoard is still moving through hardware implementation. Do not expand the board-specific exercise catalogue merely to increase lesson count. Until a stable EduBoard-AVR revision is qualified, new BOARD/SIM → BOARD material should primarily exist when it:

1. validates an existing board requirement;
2. exposes a hardware/design gap before PCB freeze; or
3. is needed to qualify a board feature.

Broader course expansion resumes after the reference board is stable.
