# TWI / I2C

ATmega1284P kaller den I2C-kompatible totrådsperiferien sin TWI. Bussen bruker SDA for data og SCL for klokke, med open-drain/open-collector-signalisering og eksterne pull-up-motstander.

## Læringsmål

Forstå START og STOP, adresser, lese/skrive-retning, ACK/NACK, statuskoder og rollene til TWBR, TWSR, TWAR, TWDR og TWCR. Implementer de samme controller-primitivene i AVR Assembly og C.

## Første konfigurasjon

De parallelle eksemplene konfigurerer TWI for omtrent 100 kHz SCL med 8 MHz CPU-klokke og prescaler 1. Fra databladets sammenheng:

SCL = F_CPU / (16 + 2 * TWBR * prescaler)

TWBR=32 gir 100 kHz.

Første firmwaremilepæl initialiserer periferien og eksponerer et stabilt kvalifikasjonspunkt. Senere øvelser legger til START, adresse, byteoverføring, ACK-håndtering og STOP.

## Kvalifikasjon

Q0 bygger og disassemblerer begge versjoner. Q1 verifiserer modellert registerkonfigurasjon. Sterkere Q1 data-path-tester legges bare til der simavr modellerer aktuell TWI-oppførsel pålitelig. Q2 verifiserer den virkelige SDA/SCL-bussen, pull-ups, timing og eksterne enheter på STK500.
