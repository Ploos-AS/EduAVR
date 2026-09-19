# SRAM- og stackbudsjett

!!! abstract "Læringsmål"
    Mål statisk SRAM-bruk og dynamisk stackbevegelse på en 8-bits AVR, skill mellom dem, sammenlign C med håndskrevet Assembly, og vurder marginen som trengs for å hindre at minneområdene kolliderer.

!!! info "Forutsetninger"
    Fullfør først leksjonene om stack/funksjoner og pekere/buffere. Leksjonen om volatile/atomicitet er også nyttig bakgrunn.

AVR SRAM deles mellom globale/statiske data og stacken. Et program kan kompilere uten feil og likevel være usikkert dersom disse områdene kan vokse inn i hverandre under kjøring.

## Det parede eksemplet

EduAVR har:

- `examples/c/resource-budget/main.c`
- `examples/asm/resource-budget/main.S`

Begge reserverer en statisk buffer på 16 byte og kaller en worker som bruker åtte byte lokal stacklagring. De lagrer stackpekeren før kallet, på det dypeste punktet og etter retur.

Workeren returnerer den deterministiske verdien `0x47`.

## Statisk SRAM mot dynamisk stack

Objekter i `.data` og `.bss` bruker en forutsigbar del av SRAM. Stacken er annerledes: funksjonskall, lagrede registre, interrupt-entry og lokale automatiske variabler bruker den dynamisk.

Et nyttig minnebudsjett har derfor minst to deler:

1. statisk SRAM som er synlig i ELF/map/size-output;
2. verste realistiske stackdybde gjennom call- og interrupt-stier.

Hvis heap introduseres, får vi enda en bevegelig grense som må budsjetteres eksplisitt.

## C-implementasjonen

C-workeren deklarerer bevisst et lokalt array på åtte byte. Inspiser generert kode i stedet for å anta at compileren implementerer kilden akkurat slik du forestiller deg. Optimalisering, registerallokering og ABI-regler bestemmer den faktiske stackframen.

Kjør:

```sh
make budget
make size
make disasm
sh tools/check_q1.sh
```

Sammenlign C-listingen med kildekoden og finn manipulasjonen av stackpekeren rundt `budget_worker`.

## Assembly-implementasjonen

Assembly-versjonen gjør framen eksplisitt. Den lagrer ABI call-saved frame-pointer-registre, reserverer åtte byte, registrerer den dypere SP-verdien, gjenoppretter framen og returnerer med callerens opprinnelige SP.

Dette gjør det mulig å skille mellom tre kostnader:

- call/return-mekanikk;
- lagrede registre;
- lokal lagring.

## Deterministisk Q1-kvalifikasjon

Ved `budget_ready` kontrollerer Q1-proben begge implementasjonene. Den krever:

- `budget_result = 0x47`;
- stackpekeren beveget seg nedover inne i workeren;
- stackpekeren etter retur er lik verdien før kallet;
- den statiske 16-byte-bufferen inngår i programmets minnefotavtrykk.

!!! success "Kvalifisert oppførsel"
    De parede eksemplene gir deterministisk simulatorevidens for balansert stackbruk og observerbar stackdybde. Q1 hevder ikke en universell worst-case stackgrense for vilkårlig firmware.

## Lag et reelt budsjett

For produksjonsfirmware er ikke ett observert funksjonskall hele svaret. Ta med:

- dypeste call chain;
- nestede kall og biblioteksrutiner;
- interrupt-entry og registerlagring i ISR;
- eventuell interrupt-nesting-policy;
- statiske buffere og protokollkøer;
- sikkerhetsmargin for senere endringer.

Bruk `avr-size`, linker-informasjon og målrettede runtime-prober sammen. Ett enkelt tall forteller ikke hele historien.

## Oppgaver

1. Øk det lokale arrayet og forutsi hvordan dypeste SP bør endres.
2. Legg til enda et funksjonskall i workeren og inspiser den nye framen.
3. Sammenlign `avr-size` før og etter at `budget_static` dobles.
4. Forklar hvorfor balansert SP etter retur ikke beviser tilstrekkelig worst-case SRAM-margin.
5. Finn hva et interrupt på det dypeste punktet ville lagt til stackbudsjettet.

!!! tip "Neste"
    Fortsett med å sammenligne optimaliseringsnivåer og studer hvordan compilervalg endrer kodestørrelse, registerbruk og stackframes uten å endre påkrevd semantikk.
