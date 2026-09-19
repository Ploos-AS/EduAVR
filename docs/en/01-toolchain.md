# M1 — Open AVR toolchain

!!! abstract "Learning goals"
    After this lesson you should be able to install the EduAVR toolchain, build the reference firmware, run the project checks, and inspect generated AVR machine code.

!!! info "Prerequisites"
    A Debian-family environment, or the EduAVR development container, and basic command-line familiarity.

EduAVR uses a command-line-first toolchain built around AVR-GCC, GNU AVR Binutils, AVR-LibC, AVRDUDE and GNU Make.

## Install the tools

On Debian-family systems the required packages are typically:

```sh
sudo apt install gcc-avr binutils-avr avr-libc avrdude make
```

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
