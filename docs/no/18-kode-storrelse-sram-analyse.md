# Analyse av kodestørrelse og SRAM

!!! abstract "Læringsmål"
    Gjør ELF-informasjon om til et eksplisitt minnebudsjett, skill Flash fra SRAM, identifiser statiske datasymboler og dokumenter hvorfor ett enkelt avr-size-tall ikke er en komplett ressursanalyse.

!!! info "Forutsetninger"
    Fullfør leksjon 16 og 17 først.

Optimalisering blir ingeniørevidens når effektene måles mot ressursgrensene. På AVR er det viktigste skillet mellom Flash og SRAM.

## Hva ELF-filen forteller oss

| Seksjon | Typisk ressurs | Betydning |
| --- | --- | --- |
| .text | Flash | instruksjoner og kjørbar kode |
| .rodata | Flash | skrivebeskyttede konstanter |
| .data | Flash + SRAM | initialiserte skrivbare data; startup kopierer dem til SRAM |
| .bss | SRAM | nullinitialiserte skrivbare data |
| stack | SRAM | kall, ISR-er og lokale variabler |
| heap | SRAM | dynamisk allokering, hvis brukt |

Den nøyaktige linker-layouten avhenger av mål og linker script, så ELF-filen er fasiten for det konkrete bygget.

## Statisk mot dynamisk SRAM

En nyttig første tilnærming er:

static_sram = .data + .bss

Stacken er et separat runtime-budsjett. Firmware kan ha liten .bss og likevel gå tom for SRAM gjennom dyp call chain eller interrupt-aktivitet.

EduAVR rapporterer derfor statisk SRAM og observert stackbevegelse separat.

## Flash-budsjett

En nyttig første modell er:

flash_image = .text + .rodata + .data

.data-byte finnes i Flash som initialiseringsimage samtidig som den skrivbare kopien bruker SRAM. Dette er en budsjetteringsmodell, ikke en erstatning for linker map eller datablad.

## Analyseverktøyet

Kjør:

    make analyze

Dette lager build/memory-report.txt. Rapporten inneholder seksjonsstørrelser fra avr-size, Flash-orienterte summer, statisk SRAM-sum, utvalgte .bss-symboler, den statiske bufferen i resource-budget-eksempelet og en påminnelse om at stack/ISR-dybde fortsatt må måles dynamisk.

## Hvorfor symboler er nyttige

Seksjonssummer svarer på «hvor mye?», men ikke alltid «hva bruker det?»

Bruk:

    avr-nm -S --size-sort build/resource-budget-c.elf

for å finne store objekter og funksjoner. Dette er nyttig når en statisk buffer vokser uventet eller en liten endring gir en ressursregresjon.

## Sammenligning av optimaliseringsbygg

Optimaliseringsleksjonen produserer O0-, Os- og O2-varianter. Sammenlign rapporter og disassembly i stedet for å anta at en optimaliseringsflagge har universell effekt.

Nyttig evidens er .text-, .data- og .bss-størrelse, navngitte symbols størrelser, genererte instruksjonssekvenser og observert stackbevegelse.

Ikke gjør disse målingene om til en universell rangering. Den relevante begrensningen er firmwarets faktiske arbeidslast, minnegrense og tidskrav.

## Kvalifikasjonsgrense

Q1 kontrollerer at analysen kan genereres fra ELF-filen og at de deterministiske eksemplene fortsatt er semantisk korrekte.

Q1 hevder ikke en universell worst-case stackgrense, en universell maksimal trygg SRAM-bruk, en universell syklustid for et optimaliseringsnivå eller identisk minneoppførsel mellom simulator og fysisk board.

## Oppgaver

1. Generer rapporter for O0-, Os- og O2-byggene.
2. Finn det største skrivbare statiske objektet i resource-budget-eksempelet.
3. Forklar hvorfor .data inngår både i Flash- og SRAM-budsjettet.
4. Gjør en statisk buffer større og observer hvilke rapportfelt som endres.
5. Forklar hvorfor rapporten ikke kan bevise worst-case stackdybde.
6. Beskriv hvordan et ISR kan endre det effektive stackbudsjettet.

!!! success "Systemperspektiv"
    Kodestørrelse, statisk SRAM, dynamisk stack og timing er relaterte begrensninger, men de er ikke samme måling.
