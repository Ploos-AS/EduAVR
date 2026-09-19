# Vedlegg E — Minneinternt

## Formål
Forstå hvor programkode og data lever, og hvorfor AVR sin Harvard-arkitektur påvirker programmeringen.

## Minnedomener
- **Flash:** programinstruksjoner og persistente programkonstanter.
- **SRAM:** runtime-variabler, `.data`, `.bss`, stack og eventuell heap.
- **EEPROM:** ikke-flyktige data som håndteres separat fra vanlig SRAM.
- **I/O/registerrom:** kontroll- og statusregistre for CPU og peripherals.

## Startup
Før `main()` etablerer runtime normalt nødvendig CPU/runtime-state, kopierer initialiserte data fra Flash-bildet til SRAM og nullstiller `.bss`.

## Seksjoner
Bruk ELF/map/disassembly-verktøyene til å finne `.text`, `.data` og `.bss`. Sammenlign størrelsene med de faktiske grensene i MCU-en.

## Stack
Stacken vokser og krymper med funksjonskall, lagrede registre, lokal lagring og interrupts. Mål stack-bevegelsen i Exercise 04 og ISR-øvelsene.

## PROGMEM
Store konstante tabeller trenger ikke bruke knapp SRAM. Studer AVR-skillet mellom ordinær dataaksess og programminneaksess før dette skjules bak helper-makroer.

## EEPROM
EEPROM er persistent, men har andre aksess-semantikker og begrenset write endurance. Exercise 11 gir den praktiske veien.

## Øvelse
For ett firmware-build: regnskapsfør Flash- og SRAM-bruk, identifiser hvor stacken starter, og forklar hvor hvert globalt/statisk objekt initialiseres fra og lagres ved runtime.
