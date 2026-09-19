# Vedlegg B — Debugging av AVR

## Formål
Bruk debuggeren til å observere maskinen i stedet for å gjette hva firmware gjør.

## Arbeidsflyt
Bygg med debuginformasjon, start simulator/debug-server, koble til avr-gdb, last symboler, reset, sett breakpoint og steg på kilde- eller instruksjonsnivå.

Øv på å inspisere CPU-registre og SREG, I/O-registre, SRAM, stack pointer, stackminne, disassembly og interrupt-rutiner.

## Simulator kontra hardware
simavr passer til deterministisk Q1-verifikasjon. Debugging på fysisk hardware er Q2 og avhenger av board/debug-interface. AVaRICE/JTAG kan brukes der det passer.

## Interrupts og stack
Finn vector, enable/flag og global interrupt-state. Break ved ISR-entry og inspiser prolog/epilog. Registrer SP før CALL, inne i funksjon/ISR og etter RET/RETI.

## Vanlige feller
Optimalisert kode følger ikke alltid kildelinjer én-til-én. Breakpoints påvirker timing. Simulator kvalifiserer ikke elektrisk oppførsel. Pass på at ELF/symboler tilhører riktig build.

## Øvelse
Gjenta én EduAVR-øvelse fra debuggeren: forutsi en registerendring, steg instruksjonen, verifiser resultatet og forklar hvilken fysisk konsekvens den ville hatt på boardet.
