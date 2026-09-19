# Vedlegg F — Programmering, fuses og bootloadere

## Formål
Forstå hvordan firmware kommer inn i MCU-en, og hvilke konfigurasjonsvalg som kan påvirke om target fortsatt er enkelt å programmere.

## ISP
AVR ISP bruker MCU-ens programmeringsinterface sammen med RESET. EduBoard-AVR holder denne banen tilgjengelig også når undervisningsperipherals er montert.

## AVRDUDE-arbeidsflyt
Identifiser eksakt MCU, programmer og tilkobling før skriving. Les/verifiser identitet og eksisterende konfigurasjon der det er praktisk, programmer Flash og verifiser deretter.

## Fuses
Fuses konfigurerer device-oppførsel som clock-relaterte valg og andre lavnivåfunksjoner. Behandle fuse-endringer som konfigurasjonsendringer med recovery-konsekvenser, ikke som ordinære firmware-bytes.

Før endring av fuses:
1. les ATmega1284P-databladseksjonen for de eksakte bitene;
2. registrer eksisterende verdier;
3. beregn de ønskede verdiene uavhengig;
4. verifiser clock-antakelser;
5. kjenn recovery-veien;
6. endre bare det labben krever.

## Lock bits
Lock bits styrer policy for programmerings-/lesetilgang. De erstatter ikke forståelse av device-ens faktiske sikkerhetsgarantier.

## Boot-seksjon
Studer reset/boot-plassering og den arkitektoniske ideen bak en bootloader før du bruker en Arduino-lignende bootloader. Bootloader er valgfritt; ISP er fortsatt den grunnleggende programmeringsveien.

## Recovery-tankegang
En konfigurasjon som får ISP til å virke død kan ha endret antakelser om clock, reset eller programmering. Diagnostiser strøm, reset, clock og programmer-wiring før du antar at MCU-en er ødelagt.

## Sikkerhetsregel
Ikke gi eller bruk copy/paste fuse-verdier uten å knytte dem til eksakt target, clock-design og dokumentert recovery-prosedyre.
