# Kursprinsipper

EduAVR lærer bort mikrokontrolleren før et rammeverk.

Første referanseplattform er ATmega1284P-PU på Atmel STK500.

## Læringssløyfe
For hvert viktig konsept:
1. Forstå maskinvaren.
2. Finn funksjonen i databladet.
3. Finn relevante registre og bit.
4. Implementer i AVR-assembler.
5. Implementer samme oppførsel i C.
6. Undersøk assemblerkoden kompilatoren genererer.
7. Kjør på ekte maskinvare.
8. Forklar forskjellene.

Assembler gjør sammenhengen mellom C, AVR-arkitekturen og maskinvaren synlig; målet er ikke å erstatte C.

## Verktøy
Den normative kursveien bruker en åpen verktøykjede og skal ikke kreve betalt IDE: AVR-GCC, GNU Binutils, AVR-LibC, AVRDUDE og GNU Make. Kommandolinjen er den portable grunnplattformen.

## Arduino
Arduino er med hensikt ikke startabstraksjonen. Arduino-kompatibilitet og sammenligninger legges i et vedlegg etter register-nær AVR-programmering.
