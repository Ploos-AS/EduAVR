# Vedlegg A — AVR og Arduino

Dette vedlegget ligger bevisst utenfor den register-nære kjernen. Arduino er verken påkrevd eller referanseimplementasjonen.

## Formål
Etter at MCU-en er lært direkte, kobles Arduino-abstraksjoner tilbake til ATmega1284P-hardware, avr-gcc-verktøykjeden og genererte AVR-instruksjoner.

| Arduino-konsept | AVR-perspektiv |
| --- | --- |
| `pinMode()` | DDRx direction bits |
| `digitalRead()` | PINx |
| `digitalWrite()` | PORTx og pull-up/output |
| `analogRead()` | ADC-registere |
| `analogWrite()` der støttet | timer/output-compare PWM |
| `Serial` | USART |
| `SPI` | SPI-hardware |
| `Wire` | TWI/I2C |
| `millis()` | timerinterrupt + software-state |
| `setup()/loop()` | framework-startup + applikasjonsflyt |

## Sammenligningsøvelse
Implementer samme LED/button-funksjon i direkte AVR-assembler, register-nær C og Arduino API. Disassembler og sammenlign initialization, størrelse og peripheral-konfigurasjon.

Arduino-runtime kan eie/dependere på timerressurser; kartlegg ressursene før direkte timerprogrammering blandes med framework-funksjoner.

En Arduino-lignende bootloader er én programmeringsmetode, ikke et AVR-krav. Se Vedlegg F.

## Mål
Eleven skal kunne bruke Arduino når det er praktisk, men fortsatt kunne svare: **hvilken AVR-peripheral, hvilke registre og hvilke genererte instruksjoner implementerer abstraksjonen?**
