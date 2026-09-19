# AVR-arkitektur og ATmega1284P

!!! abstract "Læringsmål"
    Etter leksjonen skal du kunne beskrive AVR-eksekveringsmodellen, de viktigste CPU-registrene og minneområdene, og koble enkel C-kode til AVR-instruksjoner.

!!! info "Forutsetninger"
    Fullfør [M1 — Åpen AVR-verktøykjede](01-toolchain.md).

EduAVR starter med maskinen, ikke et rammeverk.

## Eksekveringsmodellen

ATmega1284P er en 8-bits AVR-mikrokontroller. Programmet ligger i Flash og kjøres av CPU-en. Arbeidsdata ligger normalt i SRAM, mens persistente data kan ligge i EEPROM. Periferienheter styres gjennom registre.

**C og Assembly manipulerer til slutt den samme maskintilstanden.**

## CPU-registre

AVR har 32 generelle 8-bits registre, `r0` til `r31`. Registerparene `r26:r27`, `r28:r29` og `r30:r31` kan brukes som X-, Y- og Z-pekere.

Viktig CPU-tilstand omfatter også program counter, stack pointer, statusregisteret SREG og flagg som zero, carry og negative.

## Minneområder

Skill mellom:

- Flash — programlagring;
- SRAM — variabler, buffere og stack;
- EEPROM — ikke-flyktige applikasjonsdata;
- I/O/registerrom — styring og status for MCU og periferi.

## Første instruksjoner

Start med `ldi`, `mov`, `add`, `sub`, `and`, `or`, `eor`, `inc`, `dec`, `cp`, `breq`, `brne`, `rjmp`, `call` og `ret`.

## C ↔ Assembly

```c
uint8_t a = 5;
uint8_t b = 3;
uint8_t result = a + b;
```

En forenklet Assembly-visning kan ligne:

```asm
ldi r24, 5
ldi r25, 3
add r24, r25
```

Eksakt compiler-output avhenger av kontekst og optimalisering. Bygg derfor det virkelige programmet og undersøk resultatet med `avr-objdump`.

## Prøv selv

Start en ELF under simavr + avr-gdb. Bruk `stepi` og `info registers` og se maskintilstanden endre seg instruksjon for instruksjon.

!!! success "Forventet resultat"
    Du kan single-steppe og identifisere registre eller statusflagg som endres.

## Sjekk forståelsen

1. Hva skiller Flash, SRAM og EEPROM?
2. Hvilke registerpar fungerer som X-, Y- og Z-pekere?
3. Hvorfor kan optimert compiler-output avvike fra det forenklede eksemplet?

!!! tip "Neste"
    Fortsett til [GPIO — fra registre til pinner](03-gpio.md).
