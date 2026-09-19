# Vedlegg K — Bygg ditt eget AVR-board

## Formål
Reduser et utviklingsboard til et forståelig minimum og legg deretter til funksjoner bevisst.

Start med ATmega1284P-PU: power/GND, AVCC/AREF, RESET, clock og ISP. Bygg et konservativt minimumssystem på breadboard med decoupling og programmeringstilgang.

Bring-up: inspiser shorts/polaritet, verifiser rails, reset og clock-antakelser, identifiser/programmer MCU og kjør minimal GPIO-test.

Legg deretter til én funksjon om gangen: LED/button, UART, ADC, busser og drivere.

Til slutt oversettes arkitekturen til schematic/PCB med decoupling, returveier, ISP, testpunkter og lesbare connectors.

EduBoard-AVR er referanseimplementasjonen, men vedlegget lærer resonneringen bak et minimumssystem fremfor å kopiere PCB-en.
