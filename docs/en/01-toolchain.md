# M1 — Open AVR toolchain

EduAVR uses a command-line-first toolchain built around AVR-GCC, GNU AVR Binutils, AVR-LibC, AVRDUDE and GNU Make.

On Debian-family systems the required packages are typically:

```sh
sudo apt install gcc-avr binutils-avr avr-libc avrdude make
```

Run:

```sh
make check
```

This verifies the tools and builds both reference Blink implementations for ATmega1284P.

Use `make disasm` to generate annotated disassemblies. Comparing `build/blink-c.lst` and `build/blink-asm.lst` is part of the EduAVR learning method.

Programming is deliberately kept separate from building because STK500 connection details can differ. M1 establishes the reproducible build baseline; hardware qualification follows with an attached STK500.
