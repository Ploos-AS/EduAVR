# M1 — Åpen AVR-verktøykjede

!!! abstract "Læringsmål"
    Etter leksjonen skal du kunne installere EduAVR-verktøyene, bygge referansefirmware, kjøre prosjektkontrollene og undersøke generert AVR-maskinkode.

!!! info "Forutsetninger"
    Et Debian-basert miljø eller EduAVR-utviklingscontaineren, samt grunnleggende kommandolinjebruk.

EduAVR bruker en kommandolinjeførst verktøykjede basert på AVR-GCC, GNU AVR Binutils, AVR-LibC, AVRDUDE og GNU Make.

## Installer verktøyene

```sh
sudo apt install gcc-avr binutils-avr avr-libc avrdude make
```

## Prøv selv

```sh
make check
make disasm
```

Sammenlign `build/blink-c.lst` og `build/blink-asm.lst`. Koblingen mellom C, Assembly og de faktiske instruksjonene er en sentral del av EduAVR-metoden.

!!! success "Forventet resultat"
    Kontrollene fullføres, begge Blink-implementasjonene bygges, og listing-filene kan undersøkes.

## Hvorfor programmering er separat

Programmering holdes adskilt fra bygging fordi STK500-tilkoblingen kan variere. M1 etablerer et reproduserbart bygg; maskinvarekvalifikasjon kommer senere.

## Sjekk forståelsen

1. Hvilket verktøy kompilerer C for AVR?
2. Hvorfor undersøker vi ekte disassembly?
3. Hvorfor er programmering ikke en del av grunnbygget?

!!! tip "Neste"
    Fortsett til [AVR-arkitektur og ATmega1284P](02-avr-architecture.md).
