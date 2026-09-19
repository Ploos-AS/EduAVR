# Stack og funksjoner

!!! abstract "Læringsmål"
    Forstå hvordan AVR bruker stacken ved funksjonskall, hva `call`/`ret` gjør, og hvordan C-funksjoner blir til en calling convention og maskininstruksjoner.

!!! info "Forutsetninger"
    Du bør kjenne AVR-registermodellen og kunne undersøke disassembly.

## Stacken

Stacken ligger i SRAM og vokser når data eller returadresser legges på den. Stack pointer peker på gjeldende posisjon.

Et funksjonskall må bevare nok til at programmet kan fortsette riktig etter `ret`.

## C og Assembly

Lag en liten C-funksjon med parametere og returverdi. Bygg den med ulike optimaliseringsnivåer og sammenlign med en eksplisitt Assembly-rutine.

## Prøv selv

Bruk avr-gdb til å stoppe før et funksjonskall. Noter stack pointer, single-step gjennom `call`, funksjonen og `ret`, og observer hvordan tilstanden endres.

!!! success "Forventet resultat"
    Du kan forklare hvor returflyten kommer fra og identifisere hvilke registre compiler-output bruker for argumenter og resultat i eksemplet.

## Kvalifikasjon

Denne leksjonen er Q1-kvalifisert. Den automatiserte C/Assembly-proben verifiserer argument-/resultatflyt, observerer at stack pointer flytter seg nedover inne i funksjonskallet, og krever at stack pointer er gjenopprettet etter retur i simavr + avr-gdb.

## Sjekk forståelsen

1. Hvor ligger AVR-stacken?
2. Hvorfor må en calling convention finnes?
3. Hvorfor kan prolog/epilog endres med optimalisering?

!!! tip "Neste"
    Fortsett til [Timere og avbrudd](05-timers-interrupts.md).
