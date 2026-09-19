# Vedlegg F — Programmering, fuses og bootloadere

## Formål
Forstå hvordan firmware kommer inn i MCU-en og hvordan lavnivåkonfigurasjon påvirker programmerbarhet.

AVR ISP bruker programmeringsinterfacet og RESET. Identifiser eksakt MCU, programmer og tilkobling før skriving; programmer Flash og verifiser.

## Fuses
Fuses er konfigurasjon med mulige recovery-konsekvenser. Før endring: les riktig databladseksjon, registrer eksisterende verdier, beregn ønsket verdi uavhengig, verifiser clock-antakelser og kjenn recovery-veien.

Lock bits har konkrete device-egenskaper og er ikke en generell sikkerhetsgaranti.

En Arduino-lignende bootloader er valgfri. ISP er grunnlaget.

## Regel
Ikke bruk copy/paste fuse-verdier uten eksakt target, clock-design og dokumentert recovery-prosedyre.
