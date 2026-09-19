# Kursprinsipper

!!! abstract "Læringsmål"
    Forstå hvordan EduAVR-kurset er bygget opp, hvorfor simulator er standard runtime-miljø når det er teknisk gyldig, og når ekte maskinvare faktisk er nødvendig.

EduAVR starter nær maskinvaren. Vi bruker primært **AVR Assembly og C**, og sammenligner kildekode med faktisk generert maskinkode. Referanse-MCU er ATmega1284P-PU, med Atmel STK500 som fysisk referanseplattform.

## Arbeidsmåte

1. Les teorien og databladreferansene.
2. Identifiser registre, bits og maskinvaremekanismen.
3. Bygg både C- og Assembly-eksemplene.
4. Undersøk disassembly og maskintilstand.
5. Kjør og inspiser oppførselen i simulator så langt den aktuelle funksjonen modelleres.
6. Gå til fysisk maskinvare når læringsmålet avhenger av elektrisk, analog, kortspesifikk eller annen oppførsel simulatoren ikke kan bevise.
7. Forklar hva hvert kvalifikasjonsnivå dokumenterer — og hva det ikke dokumenterer.

## Simulator først

Simulator er et førsteklasses lærings- og kvalifikasjonsmiljø i EduAVR, ikke bare en reserve dersom studenten mangler maskinvare.

Leksjonene skal støtte simulatorbasert arbeid i størst mulig grad når simulatoren modellerer egenskapen godt nok. CPU-kjøring, registre, minne, stack, kontrollflyt, mange periferitilstander og debuggerøvelser skal normalt kunne arbeides med uten fysisk kort.

Fysisk maskinvare skal ikke kreves bare for å gjenta en deterministisk egenskap som allerede er dokumentert på Q0/Q1.

!!! warning "Kvalifikasjonsgrense"
    Simulatorresultater skal aldri presenteres som bevis på spenningsnivå, analog oppførsel, signalintegritet, oscillatornøyaktighet, fysisk kabling, ekte eksterne enheter eller andre egenskaper utenfor simulatormodellen.

!!! info "Single source of truth"
    Kursinnholdet vedlikeholdes i Markdown. GitHub Pages-versjonen genereres fra de samme filene; HTML vedlikeholdes ikke separat.

## Kvalifikasjonsnivåer

- **Q0 — bygg/statisk:** kompilering, linking, disassembly og strukturelle kontroller.
- **Q1 — simulator:** runtime-oppførsel som simulatoren modellerer tilstrekkelig.
- **Q2 — maskinvare:** elektrisk, analog, timing-, kort- og eksternenhetsoppførsel som krever fysisk evidens.

Q1 er standard runtime-kvalifikasjon for kursprogramvaren. En leksjon kan i tillegg ha et valgfritt eller nødvendig Q2-checkpoint når læringsmålet faktisk avhenger av fysisk maskinvare.

Se prosjektets [simulation-first qualification policy](../SIMULATION_POLICY.md) for de detaljerte reglene.

!!! tip "Neste"
    Fortsett til [Åpen AVR-verktøykjede](01-toolchain.md).
