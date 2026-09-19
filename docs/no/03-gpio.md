# GPIO — fra registre til pinner

!!! abstract "Læringsmål"
    Etter denne leksjonen skal du kunne konfigurere en GPIO-pinne som inngang eller utgang, forklare pull-up og active-low, og undersøke instruksjonene som genereres for registeroperasjoner.

GPIO er stedet der AVR-programvaren for første gang møter den fysiske verden.

For hver GPIO-port er tre registre grunnmodellen:

- `DDRx` — datretning;
- `PORTx` — utgangsverdi eller styring av intern pull-up;
- `PINx` — inngangsverdi og, på AVR-er som støtter det, toggle av utgang.

## Utgang

PB0 som utgang i C:

```c
DDRB |= _BV(DDB0);
PORTB |= _BV(PORTB0);
```

Samme maskinvare direkte i AVR-assembler:

```asm
sbi _SFR_IO_ADDR(DDRB), DDB0
sbi _SFR_IO_ADDR(PORTB), PORTB0
```

Bruk `cbi` for å nullstille utgangen. På ATmega1284P kan PB0 også toggles gjennom PIN-registeret.

## Inngang og pull-up

En pinne blir inngang når DDR-biten er null. Settes den tilsvarende PORT-biten, aktiveres intern pull-up.

En knapp kobles derfor ofte active-low: sluppet gir 1, trykket gir 0.

!!! warning "Utled det fra kretsen"
    Dette skal ikke pugges som en universell regel. Tegn kretsen og utled selv hvilket logikknivå som oppstår.

## Read-modify-write

Et uttrykk som:

```c
DDRB |= _BV(DDB0);
```

er en read-modify-write-operasjon. Undersøk assembleren kompilatoren lager. Avhengig av register, operasjon og optimalisering kan GCC bruke spesialiserte bitinstruksjoner eller en mer generell sekvens.

## Prøv selv

Bygg både C- og assembler-eksemplene for GPIO, undersøk disassembly, og finn instruksjonene som konfigurerer og endrer GPIO-registrene.

!!! success "Forventet resultat"
    I simulator kan du verifisere registerlogikk og instruksjonsflyt. Dette er ikke dokumentasjon på at en fysisk LED, bryter eller pull-up er elektrisk verifisert.

## Kvalifikasjonsgrense

**Q1** kan verifisere registerlogikk og instruksjonsflyt.

**Q2** kreves før vi hevder at en ekte LED lyser, en knapp leses elektrisk, pull-up fungerer på kortet eller ekte kontaktsprett er observert.

## Sjekk forståelsen

1. Hvilke roller har DDRx, PORTx og PINx?
2. Hvorfor er en knapp med pull-up ofte active-low?
3. Hvilke påstander kan Q1 dokumentere, og hvilke krever Q2?
