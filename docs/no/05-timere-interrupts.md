# Timere og interrupts

Timere lar firmware reagere på tid uten å sløse CPU-tid på delay-løkker. Interrupts lar en maskinvarehendelse overføre kontrollen til en interrupt service routine (ISR).

## Fra klokke til timer-tick

For en timer som drives av CPU-klokken:

```text
timerfrekvens = CPU-frekvens / prescaler
tick-periode  = 1 / timerfrekvens
```

Med 8 MHz CPU-klokke og prescaler 64 får timeren 125000 ticks per sekund. Ett tick varer da 8 mikrosekunder.

Utled alltid timing fra klokke og registeroppsett i stedet for å kopiere et magisk tall.

## Polling først

Før interrupts konfigurerer vi en timer og poller statusflagget. Da blir maskinvaretilstanden tydelig:

1. konfigurer timer-modus;
2. velg klokke/prescaler;
3. vent på compare-/overflow-flagg;
4. kvitter flagget slik databladet beskriver;
5. utfør handlingen.

## Interrupts

Et interrupt introduserer flere konsepter:

- interrupt-vektor;
- global interrupt enable;
- interrupt-enable for periferien;
- ISR entry/exit;
- lagring av maskintilstand;
- `reti`;
- delte data mellom vanlig kode og ISR.

I C gir AVR-LibC støtte for ISR-mekanikken. I assembler kan programmereren se og håndtere tilstanden direkte.

## volatile

En variabel som endres asynkront av en ISR kan trenge `volatile` slik at kompilatoren ikke antar at verdien er uendret mellom aksesser.

`volatile` gjør ikke flerbytesaksesser atomiske og er ikke en generell concurrency-mekanisme. Det kommer vi tilbake til senere.

## ASM ↔ C

For hver timer-lab:

- konfigurer registrene i assembler;
- konfigurer de samme registrene i C;
- undersøk compiler-output;
- undersøk vektor-/ISR-koden;
- sammenlign lagring og gjenoppretting av registre;
- observer timer og ISR i simulatoren.

## Kvalifikasjon

Timer-registerlogikk og modellert interrupt-oppførsel er Q1 når simavr modellerer periferien vi bruker.

Reell oscillatornøyaktighet, elektriske utganger og timingmålinger på kortet krever Q2.
