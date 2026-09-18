# Stack, subrutiner og C-funksjoner

Et funksjonskall er ikke magi. CPU-en må huske hvor den skal returnere, bevare nødvendig tilstand og ha en avtale om hvor argumenter og returverdier befinner seg.

## CALL og RET

AVR-subrutiner kan kalles med call-instruksjoner og avsluttes med `ret`. Returadressen lagres på stacken.

Stacken ligger i SRAM og vokser når returadresser, lagrede registre og andre verdier legges på den.

## PUSH og POP

```asm
push r18
; bruk r18
pop r18
ret
```

En subrutine må følge calling convention. Å lagre alle registre er unødvendig dyrt; å lagre for få ødelegger tilstanden til kalleren.

## ABI / calling convention

AVR-GCC følger en ABI som blant annet definerer:

- argumentregistre;
- returverdiregistre;
- call-used-registre;
- call-saved-registre;
- bruk av stack;
- regler for frame pointer.

Ikke utled hele regelen fra én compiler-listing. Bruk toolchain-dokumentasjonen og undersøk faktisk generert kode.

## C-funksjoner

Start med en enkel funksjon:

```c
uint8_t add8(uint8_t a, uint8_t b)
{
    return a + b;
}
```

Kompiler den med `-O0` og `-Os`. Undersøk:

- hvor `a` og `b` kommer inn;
- hvor resultatet returneres;
- om det opprettes en stack frame;
- hvilke instruksjoner som forsvinner ved optimalisering.

## Hvorfor dette er viktig

Når calling convention er forstått kan C og assembler brukes trygt sammen. Senere EduAVR-labs kan kalle en assembler-rutine fra C og en C-funksjon fra assembler.

## Kvalifikasjon

Leksjonen er Q1: stack, kall, registertilstand og generert kode kan studeres i simavr og avr-gdb uten fysisk maskinvare.
