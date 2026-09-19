# Appendiks I — Slik leser du AVR-datablader

!!! abstract "Læringsmål"
    Lær å bruke mikrokontrollerens datablad som primær maskinvarereferanse: finn periferikapitler, registerbeskrivelser, bitfelt, timinginformasjon, elektriske grenser og detaljene som gjør en programmeringsoppgave om til korrekte registeroperasjoner.

## Databladet er en del av programmeringsmodellen

Registerbasert AVR-utvikling kan ikke gjøres pålitelig bare fra hukommelsen. Databladet forklarer hva maskinvaren kan gjøre, hvilke registre som styrer den, hvilke bits som har sideeffekter og hvilke timing- og elektriske begrensninger som gjelder.

Bruk eksempler og kursmateriell som veiledning; bruk databladet som autoritativ beskrivelse av valgt MCU.

## Start med oppgaven

Oversett oppgaven til spørsmål:

1. Hvilken periferi utfører funksjonen?
2. Hvilke pinner bruker den?
3. Hvilke registre konfigurerer den?
4. Hvilke bits velger ønsket modus?
5. Hvilke statusflagg viser fremdrift eller feil?
6. Finnes det krav til rekkefølge eller sideeffekter?
7. Hvilken klokke og hvilke timingformler gjelder?
8. Kan påstanden kvalifiseres i simulator, eller krever den fysisk måling?

## En praktisk leserekkefølge

For en ukjent periferi:

1. **Features / overview** — forstå formålet og terminologien.
2. **Block diagram** — se dataflyt og funksjonelle enheter.
3. **Pin multiplexing** — finn hvilke MCU-pinner som bærer signalene.
4. **Functional description** — forstå moduser og tilstandsoverganger.
5. **Register description** — koble funksjonen til registre og bits.
6. **Timing / formulas** — beregn baudrate, timerperioder, bussfrekvens osv.
7. **Interrupts and flags** — finn hendelser, vektorer og regler for flagg.
8. **Electrical characteristics** — brukes når du analyserer den fysiske enheten.
9. **Errata** — kontroller om dokumenterte silisiumfeil påvirker funksjonen.

## Slik leser du en registertabell

Noter for hvert register:

- adresse;
- reset-verdi;
- lese-/skriveegenskaper;
- bitnavn;
- reserverte bits;
- sideeffekter;
- forholdet til andre registre.

Anta aldri at skriving av 1 nullstiller et flagg, at reserverte bits kan skrives fritt eller at registerlesing er uten sideeffekter. Les beskrivelsen.

## Eksempel: USART

Finn USART-kapitlet og svar på:

- Hvilke UBRR-registre setter baudrate?
- Hvordan beregnes UBRR fra `F_CPU`?
- Hvilke bits aktiverer RX og TX?
- Hvilke bits velger frame-format?
- Hvilket statusflagg sier at transmit data register er klart?
- Hvilke flagg rapporterer mottaksfeil?
- I hvilken rekkefølge må status- og dataregistre leses?

Først deretter bør konfigurasjonen uttrykkes i C eller Assembly.

## Datablad ↔ Assembly ↔ C

| Databladet sier | Assembly | C |
| --- | --- | --- |
| Sett et kontrollbit | load/mask/store eller bitinstruksjon | register + bitmaske |
| Vent på et flagg | read/test/branch | polling-løkke |
| Skriv periferidata | store til I/O-/dataadresse | assignment til registermakro |

Compileren erstatter ikke databladet. C-registermakroene gir bare symbolske navn til den samme maskinvaren.

## Simulatorgrensen

Databladet beskriver den virkelige komponenten. Simulatoren implementerer en modell av deler av denne oppførselen.

Bruk databladet til å definere forventet MCU-oppførsel, og kvalifiser på Q1 bare det simulatoren modellerer pålitelig. Elektriske egenskaper, analog nøyaktighet og annen fysisk oppførsel forblir Q2.

## Oppgaver

1. Finn ATmega1284P-registeret som styrer retningen til Port B og forklar hvert bit.
2. Finn prescaler-tabellen for Timer0 og beregn timer-tick ved 8 MHz CPU-klokke.
3. Finn USART-formelen og beregn innstillingen for 9600 baud.
4. Finn SPI-tabellen og identifiser bits som velger `F_CPU/16`.
5. Finn et register med et flagg der nullstillingsregelen må leses nøye.
6. Finn errata-seksjonen og forklar hvorfor den hører hjemme i implementasjonsarbeidet.

!!! tip "God vane"
    Når en leksjon nevner et register, åpne det tilsvarende databladkapitlet. Å kunne navigere i databladet er i seg selv en sentral embedded-ferdighet.
