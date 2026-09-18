# USART — bytes mellom maskiner

ATmega1284P har to USART-er. Det gjør den spesielt nyttig for å lære seriell kommunikasjon og senere bygge broer mellom en utviklingsterminal og en annen datamaskin.

## Start med formatet på ledningen

En vanlig asynkron 8N1-forbindelse sender hvert tegn som:

- én startbit;
- åtte databiter;
- ingen paritetsbit;
- én stoppbit.

Begge ender må være enige om blant annet baudrate og rammeformat.

## Baudrate-generator

USART-en utleder bittimingen fra MCU-klokken og en baudrate-divisor. Beregn riktig UBRR-verdi fra formelen i databladet, og beregn deretter faktisk baudfeil.

Ikke kopier en UBRR-konstant uten å dokumentere `F_CPU` og valgt USART-modus.

## Sending

En minimal polling-sender:

1. vent til transmit data register er klart;
2. skriv én byte til USART data register.

Implementer dette i AVR-assembler og C, og sammenlign instruksjonene.

## Mottak

En minimal polling-mottaker:

1. vent til receive-complete er satt;
2. undersøk relevante feilflagg;
3. les mottatt byte.

Lesing og skriving av periferiregistre kan ha sideeffekter. Databladet definerer nødvendig rekkefølge.

## Fra polling til interrupts

Polling gjør mekanismen lett å forstå. Senere gjør RX/TX-interrupts og ringbuffere at programmet kan gjøre nyttig arbeid samtidig som seriell trafikk kommer inn.

## To USART-er

EduAVR bruker først én USART til terminaløvelser. Senere capstones kan bruke begge:

```text
PC/Linux-terminal <-- USART0 --> ATmega1284P <-- USART1 --> retro-maskin/enhet
```

Dette gir en naturlig vei mot terminal-, BBS- og retro serial gateway-prosjekter.

## Kvalifikasjon

Q1 kan verifisere registerkonfigurasjon, baudberegninger, buffer/state-machine-logikk og simulert USART-oppførsel der modellen støtter det.

Q2 kreves for elektriske serieforbindelser, nivåkompatibilitet, kabling og målinger på ekte maskinvare.
