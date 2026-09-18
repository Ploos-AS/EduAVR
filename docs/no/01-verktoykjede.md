# M1 — Åpen AVR-verktøykjede

EduAVR bruker en kommandolinjebasert verktøykjede rundt AVR-GCC, GNU AVR Binutils, AVR-LibC, AVRDUDE og GNU Make.

På Debian-baserte systemer er pakkene normalt:

```sh
sudo apt install gcc-avr binutils-avr avr-libc avrdude make
```

Kjør:

```sh
make check
```

Dette kontrollerer verktøyene og bygger begge Blink-referanseimplementasjonene for ATmega1284P.

`make disasm` lager annotert disassembly. Sammenligning av `build/blink-c.lst` og `build/blink-asm.lst` er en del av EduAVR-metoden.

Programmering holdes med hensikt adskilt fra bygging fordi tilkoblingen til STK500 kan variere. M1 etablerer et reproducerbart byggegrunnlag; fysisk kvalifikasjon følger med tilkoblet STK500.
