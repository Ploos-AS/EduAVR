# ADC — analog til digital

!!! abstract "Læringsmål"
    Konfigurer ADC-en i ATmega1284P, forstå referansespenning, kanalvalg og prescaler, les en 10-bits konvertering i Assembly og C, og skill modellert Q1-oppførsel fra fysisk Q2-nøyaktighet.

!!! info "Forutsetninger"
    Du bør forstå AVR-registre, bitmasker, polling og binære tall.

En mikrokontroller er digital, men mange virkelige signaler er analoge. ADC-en konverterer en inngangsspenning til et tall som firmware kan behandle.

For en ideell 10-bits konvertering:

```text
ADC ≈ Vin / Vref × 1023
```

Resultatet ligger mellom 0 og 1023.

## Konfigurasjonen i EduAVR

De parede eksemplene velger:

- ADC0 som inngang;
- AVCC som referanse;
- høyrejustert 10-bits resultat;
- ADC aktivert;
- prescaler /64.

Med 8 MHz CPU-klokke gir /64 en ADC-klokke på 125 kHz.

## C og Assembly

C-versjonen konfigurerer `ADMUX` og `ADCSRA`, starter én konvertering, venter på at `ADSC` blir null og leser `ADC`.

Assembly-versjonen gjør samme sekvens eksplisitt. Den leser **ADCL før ADCH**, noe som er viktig for AVR-ens registerpar for ADC-resultatet.

Begge lagrer resultatet i `adc_result` og når det stabile kvalifikasjonspunktet `adc_ready`.

## Under panseret

Sammenlign de to ELF-filene og disassembly. Finn:

- valg av AVCC-referanse;
- bitene for /64-prescaler;
- instruksjonen som starter konverteringen;
- polling-løkken;
- lesing av ADCL/ADCH;
- SRAM-skrivingen til `adc_result`.

## Prøv selv

```sh
make adc
make disasm
sh tools/check_q1.sh
```

## Q1 med modellert analog inngang

EduAVR går lenger enn å kontrollere registre. Q1-harnessen injiserer et modellert signal på **2500 mV** på ADC0 gjennom simavr sitt ADC-grensesnitt og observerer verdien som den faktiske C- og Assembly-firmwaren bruker.

Debian/simavr-modellen for ATmega1284P i det kvalifiserte miljøet modellerer den relevante referansen til omtrent 3,3 V. Forventet konvertering blir derfor omtrent:

```text
2500 / 3300 × 1023 ≈ 775
```

CI krever at resultatet ligger innenfor et smalt toleransevindu rundt denne modellerte verdien for begge implementasjonene.

!!! success "Kvalifisert resultat"
    Både C og Assembly fullfører en modellert ADC0-konvertering fra den injiserte 2500 mV-inngangen og gir forventet resultat på omtrent 775 i Q1.

## Q1 er ikke elektrisk kalibrering

Testen beviser firmware- og simulatordataflyten. Den beviser **ikke** referansespenningen på et fysisk EduBoard, ADC-ens absolutte nøyaktighet, støy, kildeimpedans, settling, jording eller PCB-oppførsel.

Dette må måles som Q2 på virkelig maskinvare.

## Sjekk forståelsen

1. Hvorfor avhenger ADC-resultatet både av inngangsspenning og referansespenning?
2. Hvorfor bruker ADC-en en prescaler?
3. Hvorfor leser Assembly-versjonen ADCL før ADCH?
4. Hva er tallområdet til en 10-bits ADC?
5. Hvorfor kan Q1 validere firmware-dataflyten uten å validere fysisk ADC-nøyaktighet?

!!! tip "Neste"
    Når EEPROM og ADC er kvalifisert, kan de neste kjerneemnene bevege seg fra enkeltperiferier mot C/Assembly-datastrukturer og gjenbrukbar firmware.
