# Vedlegg J — Testing og kvalifikasjon

## Formål
Bruk repeterbar evidens og skill simulatorpåstander fra hardwarepåstander.

- **Q0:** build, statiske sjekker og artifact-validering.
- **Q1:** simulator/modell-verifikasjon.
- **Q2:** fysisk board/elektrisk kvalifikasjon.

Q1 PASS blir aldri automatisk Q2 PASS.

En test dokumenterer target, setup, eksakt build, stimulus, forventet og observert resultat samt evidens. CI skal reprodusere egnede Q0/Q1-sjekker. Q2 krever identifisert fysisk setup eller HIL.

Hver BOARD/SIM → BOARD-øvelse bør kobles til MCU-ressurs, boardtilkobling, isolasjon/routing ved delte pins og et praktisk observasjonspunkt.

FAIL er nyttig evidens; ikke svekk kriteriene for å få PASS.
