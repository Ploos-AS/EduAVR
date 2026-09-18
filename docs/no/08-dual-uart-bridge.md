# Dual-UART-bro: fra polling til interrupts

ATmega1284P har to uavhengige USART-er. Det gjør den godt egnet som en liten protokollbro: én seriell forbindelse kan vende mot en moderne PC, mens den andre vender mot en retrodatamaskin, terminal, modem, radio eller innebygd enhet.

## Læringsmål

Etter leksjonen skal du kunne forklare hvorfor en bidireksjonell bro trenger uavhengige mottaks- og sendestier, sammenligne polling med interruptdrevet I/O og forklare hvorfor ringbuffere er viktige når begge sider kan sende når som helst.

## Trinn 1: polling-bro

De parallelle eksemplene i `examples/c/dual-uart-bridge` og `examples/asm/dual-uart-bridge` konfigurerer USART0 og USART1 for 9600 baud, 8 databiter, ingen paritet og ett stoppbit. Hovedløkken sjekker begge mottakerne og videresender hver byte til senderen på motsatt side.

Denne varianten er med vilje enkel. Maskinvareregistrene og kontrollflyten er tydelige, men venting på én sender kan forsinke behandling av den andre retningen.

## Trinn 2: interruptdrevet bro

Eksemplene i `examples/c/dual-uart-irq-bridge` og `examples/asm/dual-uart-irq-bridge` deler datapathen i fire interruptdrevne hendelser:

- USART0 mottak
- USART0 data-register-empty sending
- USART1 mottak
- USART1 data-register-empty sending

RX-ISR-ene legger bytes i RX-ringbuffere. Hovedløkken flytter dem til TX-ringbufferen på motsatt side. UDRE-ISR-ene tømmer TX-bufferne når maskinvaren er klar.

Dermed kan mottak og sending på begge grensesnittene utvikle seg uavhengig. Dette er grunnlaget for mer avansert terminal- og gateway-programvare.

## Q1-kvalifikasjon i simulator

EduAVRs simavr Q1-harness injiserer data i begge virtuelle UART-er og krever byte-identisk utdata fra motsatt UART. Både polling- og interrupt/ringbuffer-variantene er kvalifisert i C og AVR Assembly.

Q1 beviser modellert firmwareoppførsel. Den beviser **ikke** spenningsnivåer, kabling, klokketøyaktighet, signalintegritet, RS-232-nivåkonvertering eller oppførsel på en fysisk STK500. Dette hører til Q2-maskinvarekvalifikasjon.

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

1. Følg én byte fra USART0 RX til USART1 TX i både C og Assembly.
2. Finn alle registrene som brukes til å konfigurere de to USART-ene.
3. Forklar hva som skjer når en RX-ringbuffer blir full.
4. Sett ulik baudrate på de to sidene og forklar hvorfor broen fortsatt kan oversette mellom de asynkrone forbindelsene.
5. Legg til tellere for mottatte, sendte og droppede bytes.
6. Avansert: legg til en enkel linjebasert kommandomodus uten å ødelegge transparent brotrafikk.

Neste progresjon er flytkontroll, feil/statushåndtering, konfigurerbare serieparametere og til slutt retro-terminal/gateway-capstone.
