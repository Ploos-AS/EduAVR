# Vedlegg H — Protokollanalyse

## Formål
Korreler firmware-registeraktivitet med signalene som faktisk er synlige på ledningene.

## Metode
For hvert capture:
1. forutsi transaksjonen fra firmware;
2. identifiser probe-punkter og felles jord;
3. capture med passende sample rate;
4. dekod nok manuelt til å forstå framing;
5. bruk analyzer-dekoding som bekreftelse;
6. korreler bytes/edges med firmware-state.

## UART
Mål idle-nivå, startbit, databits, eventuell parity og stopbits. Utled bit-tid og sammenlign målt baud med konfigurert verdi.

## SPI
Observer SCK, MOSI, MISO og SS. Koble CPOL/CPHA og bitrekkefølge til de fangede edgene.

## TWI/I2C
Observer START, adresse/RW-bit, ACK/NACK, data-bytes og STOP. Forstå open-drain-oppførsel og hvorfor pull-ups skaper high-nivået.

## Debugging-mønster
Når firmware og peripheral er uenige, avgjør om feilen ligger i konfigurasjon, timing, elektrisk nivå, protocol-state eller tolkning på applikasjonsnivå.

## Kvalifikasjon
En simulatortrace kan støtte Q1-logikkverifikasjon. Et capture fra fysisk EduBoard-hardware er Q2-evidence for den faktiske elektriske banen.
