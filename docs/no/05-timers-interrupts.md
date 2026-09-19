# Timere og avbrudd

!!! abstract "Læringsmål"
    Forstå timer/counter, prescaler, compare match, interrupt-vektorer og hvorfor interruptdrevet firmware skiller seg fra polling.

## Fra CPU-klokke til tid

En timer teller klokkehendelser. En prescaler reduserer tellefrekvensen slik at nyttige tidsintervaller kan representeres.

Regn alltid ut sammenhengen mellom `F_CPU`, prescaler, tellerområde og ønsket periode.

## Interrupts

Et interrupt lar maskinvaren avbryte normal programflyt og kjøre en interrupt service routine (ISR). ISR-en bør normalt gjøre minst mulig arbeid.

## Prøv selv

Konfigurer en timer compare match og observer i simulatoren at ISR-en nås. Sammenlign deretter med en polling-variant.

!!! success "Forventet resultat"
    Du kan forklare timerkonfigurasjonen og vise modellert kontrollflyt gjennom interrupt-vektoren.

## Kvalifikasjon

Q1 kan dokumentere registerkonfigurasjon og modellert timer/interrupt-oppførsel. Q2 kreves for fysiske timingmålinger og elektriske signaler.

## Sjekk forståelsen

1. Hva gjør en prescaler?
2. Hvorfor bør en ISR være kort?
3. Hva kan simulatoren ikke bevise om et fysisk timersignal?

!!! tip "Neste"
    Fortsett til [PWM](06-pwm.md).
