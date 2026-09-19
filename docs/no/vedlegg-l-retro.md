# Vedlegg L — AVR for retro computing

## Formål
Bruk AVR-kunnskap til nyttige interfaces rundt eldre datamaskiner uten å skjule elektriske/protokollmessige grenser.

Aktuelle prosjekter er TTL serial bridge, dual-UART bridge, terminal/BBS-controller, baud/protokoll-diagnostikk og andre elektrisk egnede interfaces.

Start med polling UART echo, gå til buffering/interrupts og deretter dual-UART forwarding.

TTL UART er ikke RS-232: bruk riktig transceiver, pinout, spenningsnivå og jord. Skill byte-transport fra høyere protokoller.

Lag adaptere observerbare og reversible med labels, testpunkter og dokumentert level conversion.

Et egnet prosjekt er et lite serial diagnostic/bridge-verktøy som videresender data og rapporterer konfigurasjon/feil/traffic.
