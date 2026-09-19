# Vedlegg J — Testing og kvalifikasjon

## Formål
Bruk repeterbar evidens og hold simulatorpåstander adskilt fra hardwarepåstander.

## EduAVR-nivåer
- **Q0:** build, statiske sjekker og artifact-validering.
- **Q1:** simulator-/modellverifikasjon av relevant CPU/peripheral-oppførsel.
- **Q2:** fysisk board-/elektrisk kvalifikasjon.

En Q1 PASS blir aldri stilltiende til en Q2 PASS.

## Regression-struktur
En nyttig test oppgir target, setup, eksakt build, stimulus, forventet resultat, observert resultat og evidens. Kjør testen på nytt etter relevante endringer.

## CI
CI skal reprodusere toolchain/build-sjekker og deterministiske Q0/Q1-tester som passer på runners. Hardware-avhengige Q2-tester krever identifisert fysisk setup eller HIL-infrastruktur.

## HIL
Hardware-in-the-loop kan automatisere programmering, stimulus og måling, men automatisering fjerner ikke behovet for å dokumentere instrumenter, wiring, board-revisjon og pass-kriterier.

## Kursøvelser
Hver BOARD/SIM → BOARD-øvelse bør kobles til dokumentert MCU-ressurs, boardtilkobling, isolasjon/routing-mekanisme når pins deles, og et praktisk observasjonspunkt.

## Failure
En feilet kvalifikasjon er nyttig evidens. Registrer feilen og årsaken; ikke svekk pass-kriteriene bare for å få PASS.
