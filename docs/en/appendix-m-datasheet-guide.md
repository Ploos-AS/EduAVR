# Appendix M — Datasheet survival guide

## Purpose
Turn a large MCU datasheet into a practical engineering tool.

## Start with the question
Do not read hundreds of pages linearly. State what you need to know: pin function, register setup, timing, electrical limit, interrupt vector, programming rule or erratum.

## Navigation pattern
For a peripheral:
1. find its overview/block diagram;
2. identify pins and alternate functions;
3. read operating description;
4. find register summary;
5. read every field you plan to modify;
6. inspect timing diagrams;
7. inspect electrical characteristics relevant to the circuit;
8. check interrupt/vector information;
9. check errata.

## Register discipline
Record register name, address/space when relevant, reset value, bit meaning and write/read side effects. Reserved bits are not free storage.

## Timing diagrams
Translate arrows/edges into an ordered event list. Then connect each event to the firmware/register action that causes or observes it.

## Electrical tables
Distinguish recommended operating conditions, guaranteed limits and absolute maximum ratings. Absolute maximum is not a design target.

## Cross-check
A peripheral may depend on another subsystem: clock, power reduction, pin multiplexing, interrupt enable, global interrupt state or fuse configuration.

## Errata
Record the exact silicon/device scope and workaround. Do not generalize an erratum beyond the affected revision.

## Practice
Choose one EduAVR exercise and build a one-page datasheet trail containing every table/section/register needed to implement it without copying an existing code example.
