# Vedlegg D — C ↔ assembler og kompilatoroppførsel

## Formål
Gjør C forståelig som generert maskinoppførsel i stedet for et separat lag med «magi».

## Sammenligningsmetode
For en liten funksjon:
1. skriv oppførselen i AVR-assembler;
2. skriv en tydelig C-ekvivalent;
3. kompiler med valgte optimaliseringsnivåer;
4. disassembler;
5. sammenlign instruksjoner, registerallokering, minneaksesser, kall og størrelse;
6. forklar forskjellene i stedet for å anta at kortere alltid er bedre.

## ABI
Følg argumentregistre, returregistre, call-used kontra call-saved-registre, zero-register-konvensjonen og stack-bruk. Håndskrevet assembler som kalles fra C må følge ABI.

## Emner å undersøke
- konstanter og aritmetikk;
- løkker og branches;
- pekere og arrays;
- 16/32-bit-operasjoner på en 8-bit CPU;
- structs;
- funksjonskall;
- ISR-entry/exit;
- inline kontra out-of-line kode.

## volatile
`volatile` forteller compileren at aksessene er observerbare og ikke kan optimaliseres bort som ordinære minneoperasjoner. Det er viktig for MMIO og enkelte typer delt state, men det gjør ikke flerbyte-aksesser atomiske og er ikke en generell concurrency-løsning.

## Optimalisering
Sammenlign minst et uoptimalisert/debug-vennlig build med et optimalisert build. Kilderekkefølge, synlighet av variabler og antall instruksjoner kan endre seg betydelig selv om programsemantikken forblir den samme.

## Regel
Spør alltid: **hvilke AVR-instruksjoner, registre, minneområder og peripherals implementerer denne C-konstruksjonen?**
