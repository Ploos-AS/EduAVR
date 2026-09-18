# AVR-arkitektur og ATmega1284P

EduAVR starter med maskinen, ikke med et rammeverk.

## Kjøremodellen

ATmega1284P er en 8-bits AVR-mikrokontroller. Programmet ligger i Flash og utføres av CPU-en. Arbeidsdata ligger normalt i SRAM, mens vedvarende data kan lagres i EEPROM. Periferien styres gjennom registre som programvaren kan lese og skrive.

Den viktigste ideen i starten er enkel:

**C og assembler manipulerer til slutt den samme maskintilstanden.**

## CPU-registre

AVR har 32 generelle 8-bits registre, `r0` til `r31`.

Registerparene `r26:r27`, `r28:r29` og `r30:r31` kan brukes som pekerregistrene X, Y og Z.

Annen viktig CPU-tilstand er blant annet:

- programtelleren;
- stack pointer;
- statusregisteret SREG;
- flagg som zero, carry og negative.

## Minneområder

For referansemikrokontrolleren ATmega1284P skal vi skille mellom:

- Flash — programlagring;
- SRAM — variabler, buffere og stack;
- EEPROM — ikke-flyktige applikasjonsdata;
- I/O/registerområde — styring og status for MCU og periferi.

Ikke anta at alle adresser tilhører ett enkelt flatt adresserom. AVR-instruksjonene og kompilatorverktøyene gjenspeiler disse forskjellene.

## Første instruksjonssett

Vi starter med et bevisst lite vokabular:

- `ldi` — last en konstant;
- `mov` — kopier mellom registre;
- `add` / `sub` — aritmetikk;
- `and` / `or` / `eor` — bitoperasjoner;
- `inc` / `dec` — øk/reduser;
- `cp` — sammenlign;
- `breq` / `brne` — betingede hopp;
- `rjmp` — relativt hopp;
- `call` / `ret` — subrutiner.

GPIO-spesifikke instruksjoner og registre kommer i GPIO-leksjonen.

## ASM ↔ C

C:

```c
uint8_t a = 5;
uint8_t b = 3;
uint8_t result = a + b;
```

Et forenklet assemblerbilde kan ligne:

```asm
ldi r24, 5
ldi r25, 3
add r24, r25
```

Den faktiske assembleren avhenger av kontekst og optimalisering. EduAVR lærer derfor ikke en oppdiktet én-til-én-oversettelse. Vi bygger C-programmet og undersøker det GCC faktisk produserer med `avr-objdump`.

## Simulatorøvelse

Bygg eksemplene og start en ELF under simavr + avr-gdb. Bruk `stepi` og `info registers` for å følge CPU-tilstanden én AVR-instruksjon om gangen.

Målet er å koble kildekoden til faktisk maskintilstand før vi legger på høyere abstraksjoner.
