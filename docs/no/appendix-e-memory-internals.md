# Appendiks E — Minne og internals

!!! abstract "Mål"
    Gå dypere i Flash, SRAM, EEPROM, stack, globale data og pekere på AVR.

AVR har ikke ett enkelt flatt minneområde for alle formål. Instruksjoner, linker og C-runtime reflekterer de ulike minnerommene.

## Oppgave

Finn plasseringen til kode, initialiserte data, BSS og stack i et bygget EduAVR-eksempel og sammenlign med linker-output og disassembly.
