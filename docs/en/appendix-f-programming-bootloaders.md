# Appendix F — Programming, fuses and bootloaders

## Purpose
Understand how firmware reaches the MCU and which configuration choices can affect whether the target remains easily programmable.

## ISP
AVR ISP uses the MCU's programming interface plus RESET. EduBoard-AVR keeps this path available even when teaching peripherals are fitted.

## AVRDUDE workflow
Identify the exact MCU, programmer and connection before writing. Read/verify identity and existing configuration where practical, program Flash, then verify.

## Fuses
Fuses configure device behavior such as clock-related options and other low-level features. Treat fuse changes as configuration changes with recovery consequences, not as ordinary firmware bytes.

Before changing fuses:
1. read the ATmega1284P datasheet section for the exact bits;
2. record existing values;
3. calculate intended values independently;
4. verify clock assumptions;
5. know the recovery path;
6. change only what the lab requires.

## Lock bits
Lock bits control programming/read-access policies. They are not a substitute for understanding the device's actual security guarantees.

## Boot section
Study reset/boot placement and the architectural idea of a bootloader before using an Arduino-style bootloader. A bootloader is optional; ISP remains the foundational programming path.

## Recovery mindset
A configuration that makes ISP appear dead may have changed clock/reset/programming assumptions. Diagnose power, reset, clock and programmer wiring before assuming the MCU is destroyed.

## Safety rule
Do not provide copy/paste fuse values without tying them to an exact target, clock design and documented recovery procedure.
