# Vedlegg E — Minneinternt

## Formål
Forstå hvor kode og data lever og hvorfor AVR sin Harvard-arkitektur betyr noe.

- **Flash:** program og persistente programkonstanter.
- **SRAM:** runtime-data, .data, .bss, stack og eventuell heap.
- **EEPROM:** separat ikke-flyktig data.
- **I/O/registerrom:** CPU- og peripheralregistre.

Før `main()` etablerer runtime nødvendig state, kopierer initialiserte data til SRAM og nullstiller .bss.

Bruk ELF/map/disassembly til å finne .text, .data og .bss. Observer stack-bevegelse ved kall og interrupts. Studer PROGMEM og hvorfor store konstante tabeller ikke nødvendigvis bør bruke SRAM.

## Øvelse
Regnskapsfør Flash/SRAM for én firmware og forklar hvor globale/statiske objekter kommer fra og ligger ved runtime.
