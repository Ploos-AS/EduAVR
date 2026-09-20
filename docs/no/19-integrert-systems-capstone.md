# Integrert systems-capstone

!!! abstract "Læringsmål"
    Integrer timeravbrudd, ADC, EEPROM, USART-konfigurasjon og en liten datapath i én deterministisk AVR-firmware. Les systemet som samvirkende periferi, ikke bare som isolerte eksempler.

!!! info "Forutsetninger"
    Fullfør leksjon 13–18 og appendiks J om testing og kvalifikasjon.

Capstone-eksempelet er bevisst lite. Målet er ikke å bygge et produkt, men å vise at mekanismene fra kurset kan sameksistere i én firmware-image og samtidig være observerbare og testbare.

## Systemet

De parede C- og Assembly-implementasjonene inneholder:

- Timer0 i CTC-modus med interruptdrevet tick-teller;
- ADC0-konvertering med AVCC som referanse;
- en EEPROM-kalibreringsbyte på adresse `0x20`;
- USART0 initialisert til 9600 baud, 8N1;
- en sluttverdi beregnet som `ADC-resultat + kalibrering`;
- eksplisitte probe-variabler for Q1-kvalifikasjon.

Bygg med:

```sh
make capstone
```

## Hvorfor dette er annerledes enn tidligere leksjoner

Tidligere eksempler isolerer én mekanisme om gangen. Her virker initialiseringsrekkefølge, interruptstatus, periferieregistre, persistent data og applikasjonsstate sammen.

## Q1-evidens

Kjør:

```sh
sh tools/check_capstone_q1.sh
```

Kvalifikasjonen kontrollerer både C og Assembly for simulatorekjøring, capstone-probe, EEPROM-readback `0x5a`, USART-initialisering, Timer0-interruptfremgang, ADC-resultat og sluttresultat lik ADC-resultatet pluss kalibrering.

Dette er integrasjonsevidens, ikke en påstand om elektrisk korrekthet.

## Debugging-oppgave

Stopp på `capstone_ready` i GDB og inspiser `capstone_adc`, `capstone_calibration`, `capstone_value`, `capstone_ticks`, `capstone_eeprom` og `capstone_uart_ready`.

Inspiser deretter generert Assembly for C-versjonen og finn hvor hver periferi initialiseres.

## Designspørsmål

1. Hvorfor må timer-interruptet bevare maskinstatus?
2. Hva skjer hvis EEPROM-kalibreringen leses før skrivingen er ferdig?
3. Hvilke deler av systemet avhenger av den simulerte ADC-modellen?
4. Hvorfor er USART-konfigurasjonen observerbar selv om capstone ikke sender applikasjonsdata?
5. Hvilken state tilhører periferien, og hvilken state tilhører applikasjonen?
6. Hvilke ekstra Q2-tester måtte vært gjort på et fysisk EduBoard-AVR?

!!! success "M6-integrasjon"
    Capstone viser at kursmekanismene kan kombineres i ett deterministisk C/Assembly-system samtidig som eksplisitt Q1-evidens beholdes.