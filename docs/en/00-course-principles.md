# Course principles

EduAVR teaches the microcontroller before teaching a framework.

The initial reference platform is the ATmega1284P-PU on an Atmel STK500.

## Learning loop
For each major concept:
1. Understand the hardware.
2. Find it in the datasheet.
3. Identify registers and bits.
4. Implement it in AVR assembly.
5. Implement the same behavior in C.
6. Inspect compiler-generated assembly.
7. Run it on real hardware.
8. Explain the differences.

Assembly makes the relationship between C, the AVR architecture and hardware visible; it is not intended to replace C for all development.

## Tools
The normative course path uses an open toolchain and must not require a paid IDE: AVR-GCC, GNU Binutils, AVR-LibC, AVRDUDE and GNU Make. The command line is the portable baseline.

## Arduino
Arduino is deliberately not the starting abstraction. Arduino interoperability and comparisons belong in an appendix after register-level AVR programming.
