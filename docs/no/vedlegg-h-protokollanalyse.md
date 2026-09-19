# Vedlegg H — Protokollanalyse

## Formål
Korreler firmware-registeraktivitet med signalene på ledningene.

For hvert capture: forutsi transaksjonen, velg probe-punkter og felles jord, capture med passende sample rate, dekod nok manuelt til å forstå framing, og bruk analyzer-dekoding som kontroll.

**UART:** idle, startbit, databits og stopbits; mål bit-tid og baud.

**SPI:** SCK, MOSI, MISO og SS; koble CPOL/CPHA og bitrekkefølge til edges.

**TWI/I2C:** START, adresse/RW, ACK/NACK, data og STOP; forstå open-drain og pull-ups.

Simulatortrace kan være Q1. Capture fra fysisk EduBoard kan være Q2-evidence for den elektriske banen.
