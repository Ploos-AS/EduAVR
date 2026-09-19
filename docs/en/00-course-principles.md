# Course principles

!!! abstract "Learning goals"
    Understand how EduAVR is structured, why simulation is the default runtime environment where it is technically valid, and when physical hardware is actually required.

EduAVR teaches the microcontroller before teaching a framework. The initial reference MCU is the ATmega1284P-PU, with the Atmel STK500 as a physical reference platform.

## Learning loop

For each major concept:

1. Understand the hardware.
2. Find it in the datasheet.
3. Identify registers and bits.
4. Implement it in AVR Assembly.
5. Implement the same behavior in C.
6. Inspect compiler-generated Assembly.
7. Run and inspect it in the simulator wherever the required behavior is modeled.
8. Move to physical hardware when the learning objective depends on electrical, analog, board-specific or otherwise non-simulated behavior.
9. Explain what each qualification layer proves — and what it does not prove.

Assembly makes the relationship between C, the AVR architecture and hardware visible; it is not intended to replace C for all development.

## Simulation-first

Simulation is a first-class EduAVR learning and qualification environment, not merely a fallback for students without hardware.

Lessons should support simulator-based work as far as the simulator can faithfully model the property being studied. CPU execution, registers, memory, stack, control flow, many peripheral state machines and debugger exercises should normally be usable without a physical board.

Physical hardware must not be required merely to repeat a deterministic property already demonstrated at Q0/Q1.

!!! warning "Qualification boundary"
    Simulation must never be presented as proof of voltage levels, analog behavior, signal integrity, oscillator accuracy, physical wiring, real external devices or other properties outside the simulator model.

## Qualification levels

- **Q0 — build/static:** compilation, linking, disassembly and structural checks.
- **Q1 — simulator:** runtime behavior that the simulator models sufficiently.
- **Q2 — hardware:** electrical, analog, timing, board and external-device behavior that requires physical evidence.

Q1 is the default runtime qualification for course software. A lesson may additionally contain an optional or required Q2 checkpoint when its learning objective genuinely depends on physical hardware.

See the project [simulation-first qualification policy](../SIMULATION_POLICY.md) for the detailed rules.

## Tools

The normative course path uses an open toolchain and must not require a paid IDE: AVR-GCC, GNU Binutils, AVR-LibC, AVRDUDE, GNU Make, simavr and avr-gdb. The command line is the portable baseline.

## Arduino

Arduino is deliberately not the starting abstraction. Arduino interoperability and comparisons belong in an appendix after register-level AVR programming.

!!! tip "Next"
    Continue to [Open AVR toolchain](01-toolchain.md).
