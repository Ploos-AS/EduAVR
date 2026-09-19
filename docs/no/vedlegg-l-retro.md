# Vedlegg L — AVR for retro computing

## Formål
Bruk AVR-kunnskap til nyttige interfaces rundt eldre datamaskiner uten å skjule elektriske eller protokollmessige grenser.

## Aktuelle prosjekter
- TTL serial adapter/bridge;
- dual-UART bridge;
- terminal- eller BBS-side-controller;
- baud-/protokoll-diagnoseverktøy;
- enkelt GPIO/joystick-lignende interface der det er elektrisk egnet;
- komponent i en serial-to-modern-host gateway.

## Progresjon for serial bridge
Start med polling UART echo, gå videre til buffering/interrupts og deretter dual-UART forwarding. De eksisterende EduAVR dual-UART-eksemplene gir et fundament.

## Elektrisk grense
TTL UART er aldri det samme som RS-232. Bruk korrekt transceiver og connector-konvensjon. Verifiser spenningsnivåer og jording før vintage-utstyr kobles til.

## Protokollgrense
Skill byte-transport fra høyere protokoll. Korrekt UART-konfigurasjon betyr ikke automatisk at terminalkontroll, filoverføring eller applikasjonsframing er korrekt.

## Designprinsipp
Lag adaptere reversible og observerbare: merkede connectors, testpunkter, dokumenterte pinouts og ingen uforklart level conversion.

## Prosjektidé
Bygg et lite serial diagnostic/bridge-verktøy som rapporterer framing/konfigurasjon, videresender data og eksponerer tellere for feil og trafikk.
