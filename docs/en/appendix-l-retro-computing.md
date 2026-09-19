# Appendix L — AVR for retro computing

## Purpose
Apply AVR fundamentals to useful interfaces around older computers without hiding the electrical/protocol boundaries.

## Candidate projects
- TTL serial adapter/bridge;
- dual-UART bridge;
- terminal or BBS-side controller;
- baud/protocol diagnostic tool;
- simple GPIO/joystick-style interface where electrically appropriate;
- serial-to-modern-host gateway component.

## Serial bridge progression
Start with polling UART echo, then buffering/interrupts, then dual-UART forwarding. The existing EduAVR dual-UART examples provide a foundation.

## Electrical boundary
Never equate TTL UART with RS-232. Use the correct transceiver and connector convention. Verify voltage levels and grounding before connecting vintage equipment.

## Protocol boundary
Separate byte transport from higher-level protocol. A correct UART configuration does not imply that terminal control, file transfer or application framing is correct.

## Design principle
Make adapters reversible and observable: labelled connectors, test points, documented pinouts and no unexplained level conversion.

## Project idea
Build a small serial diagnostic/bridge tool that reports framing/configuration, forwards data and exposes counters for errors/traffic.
