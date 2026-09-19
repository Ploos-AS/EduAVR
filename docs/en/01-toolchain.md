# M1 — Open AVR toolchain

!!! abstract "Learning goals"
    After this lesson you should be able to install the EduAVR toolchain, build the reference firmware, run the project checks, and inspect generated AVR machine code.

!!! info "Prerequisites"
    A Debian-family environment, or the EduAVR development container, and basic command-line familiarity.

EduAVR uses a command-line-first toolchain built around AVR-GCC, GNU AVR Binutils, AVR-LibC, AVRDUDE and GNU Make.

## Recommended: EduAVR development container

The published EduAVR OCI image is the recommended reproducible environment for the course. It contains the AVR compiler/toolchain, avr-gdb, AVRDUDE, AVaRICE, simavr and the native libraries used by the Q1 simulator harnesses.

Clone the course repository and run the image with the repository mounted as `/workspace`.

### Docker

```sh
docker pull ghcr.io/ploos-as/eduavr:latest
docker run --rm -it \
  -v "$PWD:/workspace" \
  -w /workspace \
  ghcr.io/ploos-as/eduavr:latest
```

### Podman

```sh
podman pull ghcr.io/ploos-as/eduavr:latest
podman run --rm -it \
  -v "$PWD:/workspace:Z" \
  -w /workspace \
  ghcr.io/ploos-as/eduavr:latest
```

Inside the container, `make check` and `sh tools/check_q1.sh` use the same tool environment that is qualified by CI.

!!! note "Hardware access"
    The container is intended first for building, inspection and simulator-based Q1 work. Passing a physical programmer or serial device into Docker/Podman is host-specific and belongs to Q2 hardware setup.

## Native Debian installation

A native Debian-family installation remains fully supported:

```sh
sudo apt update
sudo apt install gcc gcc-avr binutils-avr avr-libc avrdude avarice gdb-avr make simavr libsimavr-dev libelf-dev
```

The container is preferred when you want the most reproducible course environment; native packages are useful when direct host access to hardware is convenient.

## Try it

Run:

```sh
make check
```

This verifies the tools and builds both reference Blink implementations for ATmega1284P.

Then generate annotated disassemblies:

```sh
make disasm
```

Compare `build/blink-c.lst` and `build/blink-asm.lst`. Connecting C, assembly and the actual generated instructions is a core part of the EduAVR learning method.

!!! success "Expected result"
    The checks complete successfully, both Blink implementations build, and the generated listing files can be inspected.

## Why programming is separate

Programming is deliberately kept separate from building because STK500 connection details can differ. M1 establishes the reproducible build baseline; hardware qualification follows with an attached STK500.

## Check your understanding

1. Which tool turns C source into AVR object code?
2. Why does EduAVR inspect disassembly instead of assuming a one-to-one C-to-assembly translation?
3. Why is hardware programming not part of the basic reproducible build?

!!! tip "Next"
    Continue to [AVR architecture and the ATmega1284P](02-avr-architecture.md).
