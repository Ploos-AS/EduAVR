# Q1 Simulator Qualification

Q1 is EduAVR's default software runtime qualification.

## Automated acceptance

`tools/check_q1.sh`:

1. builds both reference Blink implementations;
2. confirms simavr advertises the ATmega1284(P) core;
3. boots the C ELF in simavr;
4. boots the hand-written AVR assembly ELF in simavr;
5. treats continued execution of each endless firmware loop as success;
6. verifies avr-gdb can load and inspect both AVR ELF files.

Run:

```sh
sh tools/check_q1.sh
```

The final line must be:

```text
Q1 PASS
```

## CI

GitHub Actions runs M1/Q0 and Q1 using the same Debian AVR environment. This makes simulator qualification reproducible without a physical STK500.

## Boundary

Q1 proves only behavior exercised by the simulator/model. Hardware/electrical claims remain Q2.
