# Appendiks C — Disassembly og reverse engineering

!!! abstract "Mål"
    Lær å lese AVR-disassembly og koble maskinkode tilbake til programstruktur.

Bruk `avr-objdump` på EduAVR-eksemplene. Finn funksjonsgrenser, branches, registerbruk og periferitilgang. Sammenlign C og Assembly uten å anta at compileren lager en bestemt instruksjonssekvens.

## Oppgave

Velg én C-funksjon, bygg med minst to optimaliseringsnivåer og forklar de viktigste forskjellene i disassembly.
