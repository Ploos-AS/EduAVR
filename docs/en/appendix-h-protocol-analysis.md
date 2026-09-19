# Appendix H — Protocol analysis

## Purpose
Correlate firmware register activity with signals visible on wires.

## Method
For each capture:
1. predict the transaction from firmware;
2. identify probe points and common ground;
3. capture at a suitable sample rate;
4. decode manually enough to understand framing;
5. use analyzer decoding as confirmation;
6. correlate bytes/edges with firmware state.

## UART
Measure idle level, start bit, data bits, optional parity and stop bits. Derive bit time and compare measured baud with the configured value.

## SPI
Observe SCK, MOSI, MISO and SS. Relate CPOL/CPHA and bit order to the captured edges.

## TWI/I2C
Observe START, address/RW bit, ACK/NACK, data bytes and STOP. Understand open-drain behavior and why pull-ups create the high level.

## Debugging pattern
When firmware and peripheral disagree, determine whether the error is configuration, timing, electrical, protocol-state or application-level interpretation.

## Qualification
A simulator trace can support Q1 logic verification. A capture from physical EduBoard hardware is Q2 evidence for the actual electrical path.
