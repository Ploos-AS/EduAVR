# Optimalisering og generert kode

!!! abstract "Læringsmål"
    Sammenlign GCC-optimaliseringsnivåer på AVR, forklar hvorfor optimalisering endrer instruksjoner, registerallokering og stackbruk uten å endre påkrevd resultat, og bruk disassembly og størrelsesmålinger som evidens.

!!! info "Forutsetninger"
    Fullfør systemprogrammeringsleksjonene om pekere, datastrukturer, volatile/atomicitet og SRAM-/stackbudsjetter.

Optimalisering endrer compilerens valg av instruksjoner, registerallokering, kontrollflyt og noen ganger stackbruk. Kontrakten på kildekodenivå må fortsatt holdes.

## Det parede eksemplet

EduAVR har `examples/c/optimization/main.c` og `examples/asm/optimization/main.S`.

C-implementasjonen beregner en deterministisk vektet sum over åtte byte. Repoet bygger C-versjonen med **O0**, **Os** og **O2**, i tillegg til en håndskrevet Assembly-referanse.

Forventet resultat er **0x03f8**.

## Sammenlign byggene

```sh
make optimize
make disasm
make size
```

Sammenlign de fire ELF-filene og inspiser `weighted_sum` i de genererte listingene.

## Hva optimalisering kan endre

Ulike nivåer kan endre instruksjonsantall, registerallokering, løkkestruktur, konstanthåndtering, funksjonsprolog/epilog, stackdybde og kodestørrelse.

Et mindre program er ikke automatisk raskere, og en raskere implementasjon er ikke automatisk mindre. Embedded-optimalisering må måles mot det faktiske kravet.

## C mot Assembly

Assembly-implementasjonen er bevisst eksplisitt. Compileren kan nå samme observerbare resultat med en annen instruksjonssekvens. Inspeksjon av generert Assembly kobler derfor C-abstraksjonen tilbake til AVR-instruksjonssettet og ABI-en.

## Kvalifikasjonsgrense

Q1 verifiserer at O0, Os, O2 og Assembly-referansen gir samme deterministiske resultat. Den verifiserer også at `.text`-seksjonene i ELF-filene kan måles.

Q1 hevder **ikke** at ett optimaliseringsnivå universelt er raskere, mindre eller bedre. Konklusjoner om sykluser krever en definert arbeidslast og målemetode.

!!! success "Kvalifisert oppførsel"
    Alle fire variantene bevarer det påkrevde resultatet, selv om den genererte koden kan være forskjellig.

## Oppgaver

1. Sammenlign `weighted_sum` ved O0 og Os. Hvilke compilerbeslutninger er synlig forskjellige?
2. Sammenlign Os og O2. Gir O2 nødvendigvis mindre kode?
3. Finn funksjonens prolog/epilog ved hvert nivå.
4. Forklar hvorfor `noinline` er nyttig i denne leksjonen.
5. Forklar hvorfor et deterministisk funksjonelt resultat er nødvendig, men ikke tilstrekkelig, evidens for en ytelsespåstand.
6. Finn hvor Assembly-referansen følger AVR ABI.

!!! tip "Neste"
    Fortsett med bredere analyse av kodestørrelse og SRAM-bruk, og bruk optimaliseringsresultater som evidens i stedet for antakelser.
