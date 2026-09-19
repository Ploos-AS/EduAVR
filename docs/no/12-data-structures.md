# Pekere, buffere og structs

!!! abstract "Læringsmål"
    Forstå hvordan pekere, arrays/buffere og structs blir konkrete SRAM-adresser og byte-aksesser på AVR, sammenlign C med eksplisitt Assembly, og bruk deterministisk Q1-evidens til å verifisere layout og dataflyt.

!!! info "Forutsetninger"
    Du bør forstå AVR SRAM, registre, load/store-instruksjoner, stack og grunnleggende C-variabler.

Systems programming begynner med å gjøre datalayout eksplisitt. På en 8-bits AVR er en C-peker ikke et abstrakt konsept: den inneholder en adresse, og dereferering fører til loads eller stores på denne adressen.

## Det kvalifiserte eksemplet

EduAVR har parede implementasjoner i:

- `examples/c/data-structures/main.c`
- `examples/asm/data-structures/main.S`

Begge lager samme observerbare state:

```text
sample_buffer:  0x10 0x20 0x30 0x40
sample_ptr:     adressen til sample_buffer
current_sample:
    id:         0x2a
    value:      0x30
sample_sum:     0xa0
```

C-versjonen uttrykker dette med et array, en peker og en to-byte `struct`. Assembly-versjonen uttrykker samme layout direkte i SRAM.

## Pekere og AVR-adresseregistre

C-setningen:

```c
volatile uint8_t *p = sample_buffer;
```

lager en peker til første byte i bufferen. I Assembly-implementasjonen lastes X-registerparet (`r27:r26`) med adressen til `sample_buffer`.

AVR har også Y- og Z-pekerregisterpar. Instruksjoner som `ld`, `st` og deres increment/decrement-adresseringsformer gjør disse registrene nyttige for arrays og buffere.

## Arrays er sammenhengende lagring

Fire-byte-bufferen opptar fire påfølgende SRAM-adresser. `p[2]` betyr derfor: start på adressen i `p`, gå to bytes frem og aksesser denne byten.

Assembly-eksemplet viser sammenhengen med `st X+` når bufferen fylles og eksplisitte `lds`-instruksjoner når den summeres.

!!! warning "Grenser er software sitt ansvar"
    Verken en C-peker eller et AVR-pekerregister kjenner størrelsen på arrayet. Aksess utenfor objektet er en programmeringsfeil; CPU-en beskytter ikke automatisk nærliggende SRAM.

## Struct-layout

Eksempeltypen er:

```c
typedef struct {
    uint8_t id;
    uint8_t value;
} sample_t;
```

For denne bevisst enkle strukturen opptar feltene to påfølgende bytes. Assembly-versjonen reserverer to bytes og skriver feltene på `current_sample` og `current_sample+1`.

Ikke anta at alle C-structs har en åpenbar pakket layout. Felttyper, alignment-regler og compiler-ABI har betydning. Når layout er eksternt synlig, skal den verifiseres i stedet for å gjettes.

## volatile i dette eksemplet

Kvalifikasjonsvariablene er `volatile` slik at aksessene forblir observerbare ved det stabile `data_ready`-punktet. Dette er nyttig for den debugger-drevne Q1-testen.

`volatile` gir **ikke** bounds checking, atomicity, locking eller generell thread/interrupt-sikkerhet.

## Under panseret

Bygg og inspiser begge implementasjonene:

```sh
make data
make disasm
sh tools/check_q1.sh
```

Finn:

- SRAM-allokeringen for fire-byte-bufferen;
- adressen som lastes i pekeren;
- X-registeroperasjonene i Assembly;
- de to påfølgende struct-feltene;
- loads og additions som produserer `0xa0`;
- compiler-genererte instruksjoner som implementerer C-indeksering.

Sammenlign C-disassembly med håndskrevet Assembly. Målet er ikke at de skal være tekstlig identiske, men at du kan forklare hvordan begge produserer samme maskinsynlige state.

## Deterministisk Q1-kvalifikasjon

Ved `data_ready` kontrollerer Q1-harnessen begge ELF-filene og krever:

- buffer-bytes = `10 20 30 40`;
- `current_sample.id = 0x2a`;
- `current_sample.value = 0x30`;
- `sample_sum = 0xa0`;
- `sample_ptr` er lik adressen til `sample_buffer`.

!!! success "Kvalifisert oppførsel"
    De parede C- og Assembly-eksemplene må produsere samme peker-, buffer-, struct- og sum-state i simavr/GDB.

Dette er en CPU/SRAM-påstand, så Q1 er riktig nivå. Den sier ingenting om fysisk board-wiring.

## Oppgaver

1. Endre de fire bufferverdiene og forutsi den nye 8-bits summen før Q1 kjøres.
2. Legg til et tredje `uint8_t`-felt i structen i begge implementasjoner og inspiser adressen.
3. Skriv C-summeringen med pointer increment i stedet for indeksering og sammenlign generert Assembly.
4. Forklar hva som kan skje med nærliggende SRAM hvis Assembly lagrer en femte byte utenfor fire-byte-bufferen.
5. Forklar hvorfor `volatile` gjør kvalifikasjonsstate observerbar, men ikke automatisk gjør et objekt delt mellom ISR/main sikkert.

!!! tip "Neste"
    Neste steg i systems programming er å gjøre disse rå bufferne til gjenbrukbare interfaces og deretter studere `volatile`, deling mellom ISR/main, stack/SRAM-budsjetter og optimalisering.
