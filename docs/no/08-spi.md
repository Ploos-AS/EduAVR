# SPI — Serial Peripheral Interface

SPI er den første synkrone seriebussen i EduAVR. ATmega1284P har MOSI, MISO, SCK og SS og kan brukes som kontroller eller periferienhet.

## Læringsmål

Etter leksjonen skal du kunne forklare full-dupleks skifting, klokke, chip select, CPOL/CPHA-moduser og sammenhengen mellom SPCR, SPSR og SPDR. Du skal også kunne implementere samme blokkerende byteoverføring i AVR Assembly og C og studere maskinkoden.

## Første konfigurasjon

De parallelle eksemplene konfigurerer SPI som kontroller, mode 0, MSB først og klokke F_CPU/16. SS settes som utgang slik at AVR-en forblir i controller-modus. MOSI og SCK er utganger, mens MISO er inngang.

En overføring starter ved å skrive en byte til SPDR. Maskinvaren skifter samtidig én bit inn og én bit ut for hver SCK-kant. SPIF i SPSR markerer ferdig overføring; SPDR inneholder deretter mottatt byte.

## Kvalifikasjon

Q0 bygger og disassemblerer begge implementasjonene. Q1 verifiserer den modellerte SPI-registerkonfigurasjonen i simavr. Q2 verifiserer senere virkelige pinner, spenningsnivåer, klokkesignal og kommunikasjon med en ekstern SPI-enhet på STK500.

Simulatoren brukes ikke som dokumentasjon på elektrisk oppførsel.
