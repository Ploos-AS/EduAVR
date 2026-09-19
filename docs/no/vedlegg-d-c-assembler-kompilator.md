# Vedlegg D — C ↔ assembler og kompilatoroppførsel

## Formål
Forstå C som generert maskinoppførsel, ikke som et magisk separat lag.

For en liten funksjon: implementer i AVR-assembler, skriv en tydelig C-ekvivalent, kompiler med ulike optimaliseringsnivåer, disassembler og sammenlign instruksjoner, registre, minneaksesser, kall og størrelse.

## ABI
Følg argumentregistre, returregistre, call-used/call-saved-registre, zero-register-konvensjon og stack. Håndskrevet assembler kalt fra C må følge ABI.

Studer loops, pekere, arrays, 16/32-bit operasjoner, structs, funksjonskall og ISR-entry/exit.

## volatile
`volatile` hindrer at observerbare aksesser behandles som vanlig minne som fritt kan optimaliseres bort. Det gjør ikke flerbyte-aksesser atomiske og er ikke en generell concurrency-løsning.

Spør alltid: **hvilke AVR-instruksjoner, registre, minneområder og peripherals implementerer denne C-konstruksjonen?**
