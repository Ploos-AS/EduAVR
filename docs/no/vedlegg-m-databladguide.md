# Vedlegg M — Overlevelsesguide for datablad

## Formål
Gjør et stort MCU-datablad til et praktisk ingeniørverktøy.

Start med spørsmålet: trenger du pin-funksjon, registeroppsett, timing, elektrisk grense, interrupt-vector, programmeringsregel eller erratum?

For en peripheral: finn overview/block diagram, pins/alternate functions, operating description, register summary, alle relevante bitfelt, timingdiagrammer, electrical characteristics, interrupts og errata.

For registre: noter navn, adresse/rom når relevant, resetverdi, bitbetydning og read/write-side effects. Reserved bits er ikke fri lagring.

Oversett timingdiagrammer til en ordnet event-liste og koble hvert event til firmware/registerhandling.

Skill recommended operating conditions, garanterte grenser og absolute maximum ratings. Absolute maximum er ikke et designmål.

Sjekk avhengigheter til clock, power reduction, pin multiplexing, interrupts og fuses.

## Øvelse
Velg én EduAVR-øvelse og lag et én-sides databladspor med alle seksjoner/tabeller/registere som trengs for å implementere den uten å kopiere et eksisterende kodeeksempel.
