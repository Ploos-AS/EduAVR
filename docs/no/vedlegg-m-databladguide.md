# Vedlegg M — Overlevelsesguide for datablad

## Formål
Gjør et stort MCU-datablad til et praktisk ingeniørverktøy.

## Start med spørsmålet
Ikke les hundrevis av sider lineært. Formuler hva du trenger å vite: pin-funksjon, registeroppsett, timing, elektrisk grense, interrupt-vector, programmeringsregel eller erratum.

## Navigasjonsmønster
For en peripheral:
1. finn overview/block diagram;
2. identifiser pins og alternate functions;
3. les operating description;
4. finn register summary;
5. les hvert bitfelt du planlegger å endre;
6. undersøk timingdiagrammer;
7. undersøk electrical characteristics som er relevante for kretsen;
8. sjekk interrupt/vector-informasjon;
9. sjekk errata.

## Registerdisiplin
Registrer registernavn, adresse/rom når relevant, resetverdi, bitbetydning og read/write-side effects. Reserved bits er ikke fri lagring.

## Timingdiagrammer
Oversett piler/edges til en ordnet event-liste. Koble deretter hvert event til firmware-/registerhandlingen som skaper eller observerer det.

## Elektriske tabeller
Skill recommended operating conditions, garanterte grenser og absolute maximum ratings. Absolute maximum er ikke et designmål.

## Kryssjekk
En peripheral kan avhenge av et annet subsystem: clock, power reduction, pin multiplexing, interrupt enable, global interrupt-state eller fuse-konfigurasjon.

## Errata
Registrer eksakt silicon/device-scope og workaround. Ikke generaliser et erratum utover den berørte revisjonen.

## Øvelse
Velg én EduAVR-øvelse og lag et én-sides databladspor som inneholder alle tabeller/seksjoner/registre som trengs for å implementere den uten å kopiere et eksisterende kodeeksempel.
