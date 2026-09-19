# Vedlegg B — Debugging av AVR

## Formål
Bruk debuggeren til å observere maskinen i stedet for å gjette hva firmware gjør.

## Grunnleggende arbeidsflyt
Bygg med debuginformasjon, start simulatoren eller debug-serveren, koble til avr-gdb, last symboler, reset, sett et breakpoint og steg på kilde- eller instruksjonsnivå.

Nyttige GDB-aktiviteter:
- inspiser general-purpose-registre og SREG;
- inspiser I/O-registre og SRAM;
- undersøk stack pointer og stackminne;
- bruk source-, assembly- og mixed-disassembly-visning;
- sett breakpoints på funksjoner og interrupt handlers;
- bruk watchpoints der target/debug-backend støtter det;
- sammenlign C-kilde med genererte AVR-instruksjoner.

## Simulator kontra hardware
simavr passer til deterministiske Q1-eksperimenter med CPU og peripherals. Debugging på fysisk hardware er Q2 og avhenger av board og debug-interface. AVaRICE/JTAG-baserte arbeidsflyter hører hjemme her som et hardware-debug-alternativ, ikke som krav i alle labber.

## Debugging av interrupts
Når en ISR skal debugges:
1. identifiser vectoren;
2. inspiser interrupt enable- og flaggtilstand;
3. inspiser SREG/global interrupt-state;
4. sett breakpoint ved ISR-entry;
5. inspiser compiler-generert prolog/epilog i C-build;
6. verifiser delt state etter retur.

## Stack-inspeksjon
Registrer SP før CALL, inne i callee/ISR og etter RET/RETI. Korreler minneendringer med returadresser og lagrede registre.

## Vanlige feller
- optimalisert kode følger ikke nødvendigvis kildelinjer én-til-én;
- peripheral-modeller er ikke elektrisk kvalifikasjon;
- et breakpoint endrer timing;
- en ISR-feil kan se ut som en main-loop-feil;
- utdaterte symboler fra en gammel ELF kan gjøre en ellers korrekt debug-session misvisende.

## Øvelse
Gjenta én eksisterende EduAVR-øvelse helt fra debuggeren: forutsi en registerendring, steg instruksjonen som utfører den, verifiser resultatet og forklar hvilken fysisk konsekvens den ville hatt på boardet.
