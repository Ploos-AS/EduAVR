# EduAVR — kursoversikt

EduAVR lærer AVR fra maskinvaren og opp, med **Assembly og C side om side**.

!!! info "Single source of truth"
    Denne Markdown-filen og de øvrige leksjonene er selve kurset. GitHub Pages genererer HTML direkte fra Markdown-kildene.

## Grunnløp

1. [Kursprinsipper](00-course-principles.md)
2. [Åpen AVR-verktøykjede](01-toolchain.md)
3. [AVR-arkitektur](02-avr-architecture.md)
4. [GPIO](03-gpio.md)
5. [Stack og funksjoner](04-stack-functions.md)
6. [Timere og avbrudd](05-timers-interrupts.md)
7. [PWM](06-pwm.md)
8. [USART](07-usart.md)
9. [Dual-UART-bro](09-dual-uart-bridge.md)
10. [SPI](10-spi.md)
11. [TWI / I²C](11-twi-i2c.md)
12. [EEPROM](12-eeprom.md)
13. [ADC](13-adc.md)
14. [Pekere, buffere og structs](14-data-structures.md)
15. [volatile, interrupts og atomicitet](15-volatile-atomicity.md)
16. [SRAM- og stackbudsjett](16-resource-budget.md)

## M6-utvidelse — optimalisering og kodeanalyse

Leksjon 17 legger til sammenligning av optimaliseringsnivåer og analyse av generert Assembly, med parede C/Assembly-eksempler og Q1-evidens.

## Planlagt utvidelse

Milepæl-kobling: **M7 = nettverk/Home Assistant**, **M8 = capstone-prosjekter**. Dette er fortsatt roadmap-stoff til leksjoner, eksempler og kvalifikasjonsevidens er ferdig.

Følgende emner er ikke ferdige publiserte kjerneleksjoner ennå:

- compiler-optimalisering/disassembly
- små gjenbrukbare drivere
- systemintegrasjon
- capstone-prosjekt

## Arbeidsmåte

Hver leksjon kombinerer teori med praktisk inspeksjon av maskinen. Bygg C og Assembly, undersøk disassembly, bruk simulatoren i størst praktisk mulig grad der den gir gyldig evidens, og gå til fysisk maskinvare bare når oppgaven avhenger av elektrisk eller annen ikke-modellert oppførsel.

## Referanseappendikser

Publiserte appendikser:

- **A — AVR og Arduino**
- **B — Debugging AVR**
- **C — Disassembly og reverse engineering**
- **D — C ↔ Assembly og compiler**
- **E — Minne og internals**
- **F — Programmering og bootloadere**
- **G — Elektronikk for AVR-programmerere**
- **H — Protokollanalyse**
- **I — [Ytelse og optimalisering](vedlegg-i-ytelse.md)**
- **J — [Testing og kvalifikasjon](vedlegg-j-testing-kvalifikasjon.md)**
- **K — [Bygg ditt eget AVR-board](vedlegg-k-bygg-avr-board.md)**
- **L — [AVR for retro computing](vedlegg-l-retro.md)**
- **M — [Overlevelsesguide for datablad](vedlegg-m-databladguide.md)**
- **Utvidet guide — [Slik leser du AVR-datablader](appendix-i-reading-datasheets.md)**

Disse kildene finnes nå i begge språkspor. Semantisk paritet vurderes separat fra at filene bare finnes.


## M6-utvidelse — analyse av kodestørrelse og SRAM

Leksjon 18 gjør ELF-seksjons- og symboldata om til en reproduserbar Flash/SRAM-rapport, mens dynamisk stackbruk holdes som en separat runtime-måling.