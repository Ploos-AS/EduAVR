# EduAVR

**Learn AVR from the silicon up — Assembly first, then C, with an open toolchain.**

EduAVR is a bilingual, open-source course for learning AVR microcontrollers from the hardware upward.

## Reference platform

- MCU: ATmega1284P-PU
- Development boards: Atmel STK500 and EduBoard-AVR
- Languages: AVR assembly first, then C
- Toolchain: AVR-GCC, GNU AVR Binutils, AVR-LibC, AVRDUDE and GNU Make
- Student environment: Debian-based OCI container, usable with Podman or Docker

## Learning philosophy

The primary goal is to teach the **connection between hardware and software**, not merely how to write firmware.

Each major topic follows the same path:

1. physical hardware / architectural concept and datasheet
2. registers, bits, memory and data flow
3. AVR assembly implementation
4. observe and reason about the implementation in a simulator
5. run the concept on real hardware where appropriate
6. introduce the equivalent C abstraction
7. inspect compiler-generated AVR assembly
8. connect the C statements back to registers, instructions and physical behaviour
9. compare implementations, timing, code size and resource use

Assembly therefore precedes C. C should become a higher-level expression of mechanisms the student already understands rather than hiding those mechanisms.

### Simulator and board exercises

Exercises and examples must be intentionally classified as:

- **SIM** — best suited to a simulator; emphasize CPU state, registers, flags, SRAM, stack, instructions, timing and interrupt behaviour.
- **BOARD** — best suited to physical hardware; emphasize GPIO, LEDs, switches, displays, UART, ADC, PWM, buses and electrical behaviour.
- **SIM → BOARD** — first understand and verify the mechanism in simulation, then run the same idea on EduBoard-AVR/STK500 and observe the physical result.

Labs should be illustrative and pedagogical rather than just programming assignments. A normal lab should contain: learning objective, diagram/illustration where useful, short theory, worked example, task, expected result, observations/questions and an optional challenge.

A recurring **Under the hood** section should show how C constructs map to compiler-generated AVR instructions and ultimately to registers, memory and pins.

Arduino is not a required framework or toolchain; an appendix later explains how common Arduino abstractions map to the AVR hardware students already understand.

## Quick start

Native Debian-family installation:

```sh
sudo apt install gcc-avr binutils-avr avr-libc avrdude make
make check
```

Or use the OCI student environment:

```sh
podman build -t eduavr-dev -f container/Containerfile .
podman run --rm -it -v "$PWD:/work" eduavr-dev
```

Docker can use the same Containerfile.

## Course languages

- English: `docs/en/`
- Norsk: `docs/no/`

Both tracks are first-class course material.

## Status

M0 foundation: complete.

M1 reproducible toolchain: implemented; GitHub Actions qualification is pending confirmation.

See [ROADMAP.md](ROADMAP.md).

## Licensing

- Software and code examples: MIT
- Documentation and course material: CC BY-SA 4.0
- Future hardware/PCB designs: CERN-OHL-P-2.0
