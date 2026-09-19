# Exercises

EduAVR exercises reinforce register-level AVR work and the connection from hardware to software.

All new exercises use [TEMPLATE.md](TEMPLATE.md). Existing exercises are being migrated to the same structure.

## Classification

Every exercise must declare one mode:

- **SIM** — CPU state, registers, flags, SRAM, stack, instruction flow, timing models and interrupt behavior are the main observations.
- **BOARD** — the lesson depends primarily on physical I/O or electrical behavior.
- **SIM → BOARD** — understand and verify the mechanism in simulation first, then observe the physical result.

Assembly is taught before the equivalent C abstraction. When C appears, an **Under the hood** section should connect compiler-generated AVR instructions back to registers, memory, peripherals and pins.
