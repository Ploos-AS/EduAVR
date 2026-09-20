# volatile, interrupts og atomicitet

!!! abstract "Læringsmål"
    Forstå hvorfor state delt mellom ISR og main må behandles eksplisitt, hva `volatile` gjør og ikke gjør, hvorfor flerbyte-objekter ikke automatisk er atomiske på en 8-bits AVR, og hvordan et sammenhengende snapshot tas.

!!! info "Forutsetninger"
    Fullfør først leksjonen om pekere, buffere og structs. Du bør også forstå interrupts, SREG og SRAM load/store.

Et interrupt kan endre programstate mellom to instruksjoner i `main()`. Det er nyttig, men betyr at delte data har regler som vanlig sekvensiell kode ikke har.

## Det parede eksemplet

EduAVR har:

- `examples/c/shared-state/main.c`
- `examples/asm/shared-state/main.S`

Timer0 oppdaterer periodisk:

```text
shared_ticks   8-bit
shared_word   16-bit
```

ISR-en øker `shared_ticks` og legger `0x0101` til `shared_word`. Main venter til minst tre interrupts har skjedd og lagrer deretter ett sammenhengende snapshot.

## Hva volatile betyr

I C er de delte objektene deklarert `volatile`. Dette forteller compileren at verdiene kan endres av årsaker som ikke er synlige i vanlig kontrollflyt, og at aksessene er observerbare.

Det betyr **ikke** at:

- aksessen er atomisk;
- flere aksesser utgjør én transaksjon;
- interrupts er deaktivert;
- races er umulige;
- en flerbyte-verdi ikke kan endres midt i en lesing.

Inspiser generert disassembly og identifiser loads/stores som beholdes fordi objektene er volatile.

## Hvorfor 16 bits betyr noe på en 8-bits CPU

`shared_word` er 16 bits bred, men AVR håndterer den som separate byte-operasjoner. Et interrupt kan oppstå mellom lesingen av low byte og high byte.

Et blandet resultat kan derfor oppstå hvis main leser et flerbyte-objekt som endres uten beskyttelse.

Dette er noe annet enn visibility. `volatile` handler om compiler-observerbarhet; atomicitet er en egenskap ved maskinen og kjøringen.

## Atomisk snapshot i C

Eksemplet bevarer SREG, deaktiverer interrupts, kopierer de delte verdiene og gjenoppretter tidligere SREG:

```c
uint8_t sreg = SREG;
cli();
uint16_t word = shared_word;
uint8_t ticks = shared_ticks;
SREG = sreg;
```

Den beskyttede regionen er bevisst kort. Arbeid som ikke krever atomicitet skjer etter at interrupts er gjenopprettet.

## Samme operasjon i Assembly

Assembly-versjonen gjør sekvensen eksplisitt:

```asm
in  r18, SREG
cli
lds r20, shared_word
lds r21, shared_word+1
lds r22, shared_ticks
out SREG, r18
```

Dette er maskinnivåforklaringen på hvorfor C-mønsteret virker.

## Deterministisk Q1

Kjør:

```sh
make shared
make disasm
sh tools/check_q1.sh
```

Ved `shared_state_ready` verifiserer Q1 begge implementasjonene. Timeren må ha generert minst tre events, og low/high-byte i det beskyttede `shared_word`-snapshotet må samsvare med samme lagrede tick-verdi.

!!! success "Kvalifisert resultat"
    Build #371 og container-kvalifikasjon #29 passerte for den parede shared-state-implementasjonen og den deterministiske Q1-proben.

Q1 demonstrerer interrupt-drevet CPU/SRAM-oppførsel i simulatoren. Den gir ingen påstand om fysiske interrupt-kilder eller elektrisk timing.

## Designregler

Hold delt state liten og eierskap tydelig. Foretrekk korte critical sections. Ikke deaktiver interrupts rundt tregt arbeid bare for enkelhets skyld. For større datastrukturer bør du vurdere å kopiere et minimalt snapshot eller lage en producer/consumer-protokoll fremfor å beskytte en lang operasjon.

## Oppgaver

1. Forklar hvorfor `volatile` alene ikke kan gjøre en 16-bits lesing atomisk.
2. Finn de to byte-loads som brukes for `shared_word` i begge implementasjonene.
3. Flytt unødvendig arbeid inn i den beskyttede regionen og forklar latency-kostnaden.
4. Legg til enda en delt 16-bits verdi og utvid snapshotet korrekt.
5. Beskriv et ring-buffer-design der ISR og main eier hver sin indeks.

!!! tip "Neste"
    Neste steg er å kvantifisere SRAM- og stack-bruk og studere hvordan optimalisering endrer generert AVR-kode uten å endre påkrevd programsemantikk.
