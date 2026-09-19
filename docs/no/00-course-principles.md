# Kursprinsipper

!!! abstract "Læringsmål"
    Forstå hvordan EduAVR-kurset er bygget opp, hva som kvalifiseres i simulator, og når ekte maskinvare er nødvendig.

EduAVR starter nær maskinvaren. Vi bruker primært **AVR Assembly og C**, og sammenligner kildekode med faktisk generert maskinkode.

## Arbeidsmåte

1. Les teorien og databladreferansene.
2. Bygg både C- og Assembly-eksemplene.
3. Undersøk disassembly og maskintilstand.
4. Kjør simulatorbasert kvalifikasjon der det er relevant.
5. Bruk fysisk maskinvare når påstanden faktisk handler om elektrisk oppførsel.

!!! info "Single source of truth"
    Kursinnholdet vedlikeholdes i Markdown. GitHub Pages-versjonen genereres fra de samme filene; HTML vedlikeholdes ikke separat.

## Kvalifikasjonsnivåer

**Q0** dekker bygging og statiske kontroller. **Q1** dekker oppførsel som kan dokumenteres i simulator. **Q2** brukes når fysisk maskinvare er nødvendig.

Simulatorresultater skal aldri presenteres som bevis på spenningsnivå, signalintegritet eller annen fysisk oppførsel.

!!! tip "Neste"
    Fortsett til [Åpen AVR-verktøykjede](01-toolchain.md).
