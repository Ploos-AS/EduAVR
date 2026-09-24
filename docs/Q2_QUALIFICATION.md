# EduAVR Q2 hardware qualification

Q2 is the physical-hardware qualification level for EduAVR. It complements Q1
simulation; it does not replace it. A lesson or peripheral may be Q1-qualified
while its electrical and board-specific behaviour remains unqualified at Q2.

## Qualification target

- MCU: ATmega1284P-PU.
- Primary target: a stable EduBoard-AVR hardware revision.
- Secondary/reference platform: Atmel STK500.
- Exact EduBoard revision, schematic revision, BOM revision and firmware commit
  must be recorded before a Q2 result can be called reproducible.

## Entry gate

Q2 qualification for a board revision may start only when:

1. the board revision is identified and its hardware files are frozen for the run;
2. power, clock, reset and ISP/programming paths have passed bring-up;
3. the corresponding firmware passes the existing Q1 regression suite;
4. required instruments and wiring are recorded;
5. no board-specific pin mapping is inferred from provisional CAD.

## Evidence levels

- **Q2-PASS:** observed on the named physical board revision with reproducible evidence.
- **Q2-PARTIAL:** some required observations passed, but the qualification matrix is incomplete.
- **Q2-FAIL:** a required observation failed.
- **Q2-BLOCKED:** qualification cannot proceed because hardware, instrumentation or a stable board revision is unavailable.

A Q2 result applies only to the recorded board revision and test conditions.

## Minimum qualification matrix

| Area | Required physical evidence |
| --- | --- |
| Power/reset/clock | supply rails, reset behaviour and expected clock operation |
| ISP/programming | erase/program/verify cycle and repeatable recovery |
| GPIO | configured input/output behaviour on mapped board pins |
| Timer/interrupt | observable timer-driven event and interrupt execution |
| PWM | measured output frequency/duty cycle within documented tolerance |
| USART0/1 | bidirectional serial transfer at documented settings |
| SPI | transfer with a known physical peripheral or loopback fixture |
| TWI/I2C | transaction with a known physical peripheral and required pull-ups |
| EEPROM | write/read persistence across reset/power-cycle as applicable |
| ADC | known input measurement with reference/tolerance documented |
| Integrated capstone | Timer/ADC/EEPROM/USART path demonstrated together |
| Resource regression | existing M6/Q1 resource gates remain green |

## Evidence record

For every run record:

- date and operator;
- board name/revision and serial/identifier if available;
- MCU marking;
- firmware commit SHA;
- toolchain/AVRDUDE versions;
- programmer/debugger;
- supply voltage and clock source/frequency;
- instruments/fixtures;
- exact test procedure;
- observed result and tolerance;
- links or paths to logs, captures and photographs.

Raw evidence should be retained where practical. Photographs and captures must
show real qualification evidence rather than illustrative/provisional hardware.

## Q1/Q2 rule

Q1 remains authoritative for deterministic simulator claims. Q2 is authoritative
for electrical, timing-at-pins, analog and physical-board claims. Q2 failures do
not get hidden by a passing Q1 result, and Q1 regressions block Q2 release
qualification.

## M9 exit gate

M9 can close only when a stable EduBoard-AVR revision has completed the minimum
matrix above, the evidence is recorded here (or in revision-specific records),
all relevant Q1 regressions remain green, and learner-facing EN/NO material uses
the qualified board mapping.

## Current status

**Q2-BLOCKED / convergence in progress.** No EduBoard-AVR revision is declared
Q2-qualified by this document yet. This is intentional: the qualification
contract is being established before physical evidence is claimed.
