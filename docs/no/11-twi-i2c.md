# TWI / I2C

!!! abstract "Læringsmål"
    Forstå START/STOP, adressering, lese/skrive-retning, ACK/NACK og statuskoder, og implementer grunnleggende controller-primitiver i AVR Assembly og C.

!!! info "Forutsetninger"
    Du bør forstå GPIO, periferiregistre og grunnleggende seriell kommunikasjon.

ATmega1284P kaller den I2C-kompatible totrådsperiferien sin TWI. Bussen bruker SDA for data og SCL for klokke, med open-drain/open-collector-signalisering og eksterne pull-up-motstander.

## Første konfigurasjon

De parallelle eksemplene konfigurerer TWI for omtrent 100 kHz SCL med 8 MHz CPU-klokke og prescaler 1:

```text
SCL = F_CPU / (16 + 2 * TWBR * prescaler)
```

Med `TWBR=32` blir resultatet 100 kHz.

Første firmwaremilepæl initialiserer periferien og gir et stabilt kvalifikasjonspunkt. Senere øvelser legger til START, adresse, byteoverføring, ACK-håndtering og STOP.

## Registermodellen

Følg rollene til TWBR, TWSR, TWAR, TWDR og TWCR. Statuskodene gjør det mulig å knytte programflyten til hvilken fase av busstransaksjonen maskinvaren befinner seg i.

## Under panseret

Sammenlign C- og Assembly-versjonene. Finn registerskrivingen som setter bitrate og kontrollbitene som starter en TWI-operasjon. Knytt polling av status til den tilsvarende kontrollflyten i maskinkoden.

## Prøv selv

Bygg begge versjoner, beregn forventet SCL-frekvens og spor initialiseringssekvensen. Utvid deretter analysen med START og statuskontroll når eksemplet støtter det.

!!! success "Forventet resultat"
    Du kan forklare hvordan bitrate beregnes og hvilke TWI-registre som bærer kontroll, status og data.

## Kvalifikasjon

Q0 bygger og disassemblerer begge versjoner. Q1 verifiserer modellert registerkonfigurasjon. Sterkere Q1 data-path-tester brukes bare der simavr modellerer aktuell TWI-oppførsel pålitelig. Q2 verifiserer den virkelige SDA/SCL-bussen, pull-ups, timing og eksterne enheter.

## Sjekk forståelsen

1. Hvorfor trenger SDA og SCL pull-up-motstander?
2. Hva er forskjellen mellom ACK og NACK?
3. Hvorfor er statuskoder viktige?
4. Hvilke deler av en fysisk I2C-buss krever Q2?

!!! tip "Neste"
    Dette avslutter den nåværende kjernen av kommunikasjonsleksjonene. Fortsett med appendiksene og praktiske øvelser.
