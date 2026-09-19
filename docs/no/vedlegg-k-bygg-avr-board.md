# Vedlegg K — Bygg ditt eget AVR-board

## Formål
Reduser et utviklingsboard til et forståelig minimum og legg deretter til infrastruktur bevisst.

## Steg 1 — Minimumssystem
Start med ATmega1284P-PU-databladet og identifiser power-pinner, ground, AVCC/AREF-krav, RESET, clock-valg og ISP.

## Steg 2 — Breadboard
Bygg et konservativt minimumssystem med decoupling, reset/programmeringstilgang og en kjent clock-strategi. Verifiser power før MCU-en settes inn eller programmeres.

## Steg 3 — Bring-up
1. inspiser for shorts/polaritetsfeil;
2. verifiser rails;
3. verifiser reset;
4. verifiser clock-antakelser;
5. identifiser/programmer MCU-en via ISP;
6. kjør en minimal GPIO-test.

## Steg 4 — Legg til peripherals
Legg til én funksjon om gangen: LED/button, UART, ADC-kilde, busser og drivertrinn. Test på nytt etter hver utvidelse.

## Steg 5 — PCB
Oversett den fungerende arkitekturen til schematic/PCB samtidig som decoupling, returveier, programmeringstilgang, testpunkter og lesbare connectors bevares.

## EduBoard-kobling
EduBoard-AVR er kursets referanseimplementasjon av disse prinsippene, men vedlegget lærer hvordan man resonnerer om et minimalt AVR-board i stedet for bare å kopiere PCB-en.

## Kvalifikasjon
Hold breadboard- og PCB-observasjoner adskilt. Registrer schematic-revisjon, board-revisjon, programmer, forsyning og firmware brukt ved bring-up.
