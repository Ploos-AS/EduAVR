# Dual-UART-bro: fra polling til interrupts

!!! abstract "Læringsmål"
    Forklar hvorfor en bidireksjonell bro trenger uavhengige mottaks- og sendestier, sammenlign polling med interruptdrevet I/O og forklar hvorfor ringbuffere er viktige når begge sider kan sende når som helst.

!!! info "Forutsetninger"
    Fullfør [USART](07-usart.md) og forstå polling, interrupts og grunnleggende ringbuffere.

ATmega1284P har to uavhengige USART-er og egner seg derfor som protokollbro mellom en moderne PC og en retrodatamaskin, terminal, modem, radio eller innebygd enhet.

## Trinn 1: polling-bro

Eksemplene i `examples/c/dual-uart-bridge` og `examples/asm/dual-uart-bridge` konfigurerer USART0 og USART1 for 9600 baud, 8N1. Hovedløkken sjekker begge mottakerne og videresender hver byte til motsatt sender.

Dette gjør maskinvareregistrene og kontrollflyten tydelige, men venting på én sender kan forsinke den andre retningen.

## Trinn 2: interruptdrevet bro

Eksemplene i `examples/c/dual-uart-irq-bridge` og `examples/asm/dual-uart-irq-bridge` deler datapathen i fire hendelser: USART0 RX, USART0 UDRE TX, USART1 RX og USART1 UDRE TX.

RX-ISR-ene legger bytes i RX-ringbuffere. Hovedløkken flytter dem til motsatt TX-ringbuffer. UDRE-ISR-ene tømmer bufferne når maskinvaren er klar.

## Under panseret

Følg én byte gjennom begge implementasjonene. Sammenlign polling-løkkene med interrupt-vektorene, head/tail-oppdateringene i ringbufferne og logikken som slår UDRE-interrupt av og på.

## Prøv selv

Kjør Q1-harnessen og spor trafikk i begge retninger. Undersøk deretter hva som skjer når produsent og konsument har ulik hastighet.

!!! success "Forventet resultat"
    Data injisert i én modellert UART kommer byte-identisk ut av den andre, og du kan forklare buffering og kontrollflyt som gjør dette mulig.

## Kvalifikasjon

EduAVRs simavr Q1-harness injiserer data i begge virtuelle UART-er og krever byte-identisk utdata fra motsatt UART. Polling- og interrupt/ringbuffer-variantene er kvalifisert i C og AVR Assembly.

Q1 beviser **ikke** spenningsnivåer, kabling, klokketøyaktighet, signalintegritet, RS-232-nivåkonvertering eller fysisk STK500-oppførsel. Dette hører til Q2.

## Praktisk laboppsett

```text
PC / USB-seriell
      |
   USART0
 ATmega1284P
   USART1
      |
retrodatamaskin / terminal / enhet
```

Bruk bare TTL-seriell direkte når spenningsnivåene er kompatible. Ekte RS-232-utstyr trenger en passende nivåomformer, for eksempel en MAX232-type.

## Oppgaver

1. Følg én byte fra USART0 RX til USART1 TX i C og Assembly.
2. Finn alle registrene som konfigurerer de to USART-ene.
3. Forklar hva som skjer når en RX-ringbuffer blir full.
4. Sett ulik baudrate på de to sidene og forklar hvorfor broen fortsatt fungerer.
5. Legg til tellere for mottatte, sendte og droppede bytes.
6. Avansert: legg til en linjebasert kommandomodus uten å ødelegge transparent brotrafikk.

!!! tip "Neste"
    Fortsett til [SPI](10-spi.md). Senere capstone-arbeid kan legge til flytkontroll, feilhåndtering og konfigurerbare serieparametere.
