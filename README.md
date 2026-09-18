# EduAVR

**Learn AVR from the silicon up — Assembly and C with an open toolchain.**

EduAVR is a bilingual, open-source course for learning AVR microcontrollers from the hardware upward.

## Reference platform

- MCU: ATmega1284P-PU
- Development board: Atmel STK500
- Languages: AVR assembly and C
- Toolchain: AVR-GCC, GNU AVR Binutils, AVR-LibC, AVRDUDE and GNU Make
- Student environment: Debian-based OCI container, usable with Podman or Docker

## Learning method

Each major topic follows the same path:

1. hardware and datasheet
2. registers
3. AVR assembly
4. C
5. compiler-generated assembly
6. compare the implementations
7. run the lab on hardware

Assembly and C are both first-class throughout the course. Arduino is not a required framework or toolchain; an appendix later explains how common Arduino abstractions map to the AVR hardware students already understand.

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
