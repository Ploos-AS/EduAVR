# Vedlegg A — AVR og Arduino

Dette vedlegget ligger bevisst utenfor den registernære kjernen. Arduino er verken påkrevd eller referanseimplementasjonen.

## Formål
Etter at MCU-en er lært direkte, kobles kjente Arduino-abstraksjoner tilbake til ATmega1284P-maskinvaren, avr-gcc-verktøykjeden og de genererte AVR-instruksjonene.

## Mapping-tabell

| Arduino-konsept | AVR-perspektiv |
| --- | --- |
| `pinMode()` | DDRx-retningsbits |
| `digitalRead()` | PINx-inngangsregister |
| `digitalWrite()` | PORTx-output/pull-up-oppførsel |
| `analogRead()` | ADC-multiplekser, kontroll- og resultatregistre |
| `analogWrite()` der støttet | timer/output-compare PWM |
| `Serial` | USART-registre, baudgenerator, polling/interrupts |
| `SPI` | native SPI-registre og pinner |
| `Wire` | TWI/I2C-peripheral |
| `delay()` | frameworkets timingfunksjoner |
| `millis()` | timerinterrupt pluss software-tidstilstand |
| `setup()/loop()` | framework-startup pluss gjentatt applikasjonsflyt |

## Build-stack
Behandle en Arduino-sketch som kildekode som går inn i et større build/runtime-framework. Inspiser verbose build-output og identifiser framework-kode, compiler, assembler, linker, ELF/HEX-produksjon og upload/programmeringsverktøy.

## Sammenligningsøvelse
Implementer samme LED/button-funksjon på tre måter: direkte AVR-assembler, direkte registernær C og Arduino API. Disassembler buildene og sammenlign initialisering, kodestørrelse og peripheral-konfigurasjon.

## Serial og timere
Sammenlign en minimal direkte USART-implementasjon med `Serial`. Skill mellom hva som er hardware og hva som er library-policy. Arduino-runtime-tjenester kan eie eller være avhengige av timerressurser, så fastslå ressurs-eierskap før direkte timerprogrammering blandes med framework-funksjoner.

## Bootloadere
En Arduino-lignende bootloader er én programmeringsmetode, ikke et krav for AVR. Koble dette til Vedlegg F sin gjennomgang av ISP, boot-seksjon og fuses.

## Mål
Eleven skal kunne bruke Arduino når det er praktisk, men fortsatt kunne svare: **hvilken AVR-peripheral, hvilke registre og hvilke genererte instruksjoner implementerer denne abstraksjonen?**
