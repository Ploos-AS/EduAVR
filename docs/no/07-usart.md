# USART — bytes mellom maskiner

!!! abstract "Læringsmål"
    Forstå 8N1, baudrate-generering, polling-basert sending og mottak, og hvordan samme USART-mekanisme uttrykkes i AVR Assembly og C.

!!! info "Forutsetninger"
    Du bør kjenne register-I/O, bitmasker, polling og grunnleggende interrupt-konsepter.

ATmega1284P har to USART-er. Det gjør den spesielt nyttig for seriell kommunikasjon og senere broer mellom en utviklingsterminal og andre maskiner.

## 8N1

En vanlig asynkron 8N1-forbindelse sender ett startbit, åtte databiter, ingen paritet og ett stoppbit. Begge ender må være enige om baudrate og rammeformat.

## Baudrate-generator

Beregn UBRR fra databladets formel og beregn deretter faktisk baudfeil. Ikke kopier en UBRR-konstant uten å dokumentere `F_CPU` og valgt USART-modus.

## Sending og mottak

En minimal polling-sender venter til transmit data register er klart og skriver én byte. En minimal mottaker venter på receive-complete, undersøker relevante feilflagg og leser mottatt byte.

Periferiregistre kan ha sideeffekter; databladet definerer nødvendig leserekkefølge.

## ASM ↔ C

Implementer samme polling-operasjon i AVR Assembly og C. Sammenlign registertilgangene og den genererte maskinkoden.

## Under panseret

Finn C-uttrykkene som blir til polling-løkken, registertesten og dataregistertilgangen. Skill mellom språkabstraksjonen og USART-maskinvaren som faktisk utfører seriell overføring.

## Fra polling til interrupts

RX/TX-interrupts og ringbuffere gjør at programmet kan arbeide videre mens trafikk kommer inn.

## To USART-er

```text
PC/Linux-terminal <-- USART0 --> ATmega1284P <-- USART1 --> retro-maskin/enhet
```

Dette leder naturlig videre til terminal-, BBS- og retro serial gateway-prosjekter.

## Prøv selv

Bygg C- og Assembly-eksemplene. Beregn baudrate-konfigurasjonen fra `F_CPU`, spor én sendt og én mottatt byte og sammenlign instruksjonsflyten.

!!! success "Forventet resultat"
    Du kan forklare rammeformatet, utlede baudrate-konfigurasjonen og peke ut registertilgangene som sender og mottar en byte.

## Kvalifikasjon

Q1 kan verifisere registerkonfigurasjon, baudberegninger, buffer/state-machine-logikk og simulert USART-oppførsel der modellen støtter det. Q2 kreves for elektriske serieforbindelser, nivåkompatibilitet, kabling og fysiske målinger.

## Sjekk forståelsen

1. Hva betyr 8N1?
2. Hvorfor må `F_CPU` være kjent?
3. Hvilken fordel gir polling pedagogisk?
4. Hva må testes fysisk i Q2?

!!! tip "Neste"
    Fortsett til [Dual-UART-bro](08-dual-uart-bridge.md).
