# PWM — maskinvaregenererte bølgeformer

Pulsbreddemodulasjon (PWM) lar timer-periferien generere en repeterende digital bølgeform mens CPU-en gjør annet arbeid.

## Duty cycle

For en enkel PWM-bølge:

```text
duty cycle = high-tid / periode
```

25 % duty cycle betyr at signalet er høyt en fjerdedel av perioden; 75 % betyr tre fjerdedeler.

## Hvorfor bruke timeren?

En programvareløkke kan toggle en pinne, men bruker CPU-tid og påvirkes av annen kode. Hardware-PWM genereres av timer/output-compare-maskinvaren etter at den er konfigurert.

CPU-en konfigurerer normalt:

- waveform generation mode;
- timerklokke/prescaler;
- compare output mode;
- compare-verdi;
- retningen til output-pinnen.

## ASM ↔ C

Konfigurer samme PWM-modus først med eksplisitte AVR-registeroperasjoner i assembler og deretter i C. Disassembler C-versjonen og finn registerskrivingen som svarer til hvert steg i databladet.

## Endre duty cycle

Når timeren er konfigurert kan firmware endre compare-verdien for å endre duty cycle. Dette blir grunnlag for senere øvelser som LED-lysstyrke og enkel bølgeformgenerering.

## Kvalifikasjon

Q1 kan verifisere registerkonfigurasjon, instruksjonsflyt og modellert timer/output-compare-oppførsel.

Q2 kreves for påstander om den elektriske bølgeformen, frekvensnøyaktighet, rise/fall, faktisk LED-lysstyrke eller målinger med instrumenter.
