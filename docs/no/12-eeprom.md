# EEPROM — persistent data

!!! abstract "Læringsmål"
    Forstå hvorfor EEPROM skiller seg fra SRAM og Flash, bruk EEPROM-grensesnittet i ATmega1284P fra Assembly og C, og verifiser en deterministisk write/readback i simulator.

!!! info "Forutsetninger"
    Du bør forstå AVR-minneområder, registre, polling og grunnleggende funksjonskall.

EEPROM er ikke-flyktig minne: i motsetning til SRAM er innholdet ment å overleve at strømmen forsvinner. Det passer for små mengder persistent tilstand som konfigurasjon, kalibreringsverdier og tellere. EEPROM erstatter ikke vanlig RAM: skriving er tregere og minnet har begrenset write endurance.

## Tre AVR-minneområder

Hold rollene adskilt:

- **Flash** lagrer programkode og konstanter.
- **SRAM** lagrer vanlige runtime-variabler og stack.
- **EEPROM** lagrer data som skal kunne bestå uavhengig av vanlig programkjøring.

EEPROM har sin egen adresse-, data- og kontrollmekanisme. En numerisk EEPROM-adresse er derfor ikke en SRAM-peker arkitekturmessig, selv om avr-libc tilbyr et praktisk pointer-formet API.

## Det parede eksemplet

EduAVR bruker samme deterministiske transaksjon i C og Assembly:

1. velg EEPROM-adresse `0x12`;
2. skriv verdien `0x5a`;
3. vent til skrivingen er ferdig;
4. les adresse `0x12`;
5. lagre den leste verdien i SRAM;
6. stopp ved det stabile kvalifikasjonspunktet `eeprom_ready`.

Den enkle transaksjonen gjør det lett å sammenligne implementasjonene og simulatorbeviset.

## C-implementasjonen

C-eksemplet bruker EEPROM-API-et i avr-libc:

```c
uint8_t *address = (uint8_t *)0x12;
eeprom_write_byte(address, 0x5a);
eeprom_busy_wait();
value = eeprom_read_byte(address);
```

Ikke stopp ved bibliotekskallet. Disassembler ELF-filen og finn registeroperasjonene som bibliotekimplementasjonen genererer eller kaller.

## Assembly-implementasjonen

Assembly-versjonen viser maskinvaresekvensen direkte. Følg `EEARL/EEARH` for adresse, `EEDR` for data og `EECR` for kontroll/status.

Ved skriving kan du se den beskyttede write-enable-sekvensen: firmware setter master write-enable før selve EEPROM-skrivingen startes. Den venter også dersom en tidligere eller pågående skriving ikke er ferdig.

Ved lesing velger firmware adressen, starter EEPROM-lesingen og kopierer `EEDR` til SRAM.

## Under panseret

Sammenlign C- og Assembly-ELF-ene med `avr-objdump`. Finn ut:

- hvilke instruksjoner som flytter adresse og data;
- hvor firmware venter på EEPROM;
- hva avr-libc skjuler;
- hvorfor observerbare SRAM-variabler er nyttige i en debuggerdrevet test.

## Prøv selv

Bygg og disassembler de parede eksemplene:

```sh
make eeprom
make disasm
```

Kjør deretter hele Q1-suiten:

```sh
sh tools/check_q1.sh
```

!!! success "Forventet resultat"
    Begge implementasjonene skriver `0x5a` til EEPROM-adresse `0x12` og leser `0x5a` tilbake i simavr-modellen.

## Kvalifikasjon

**Q0** bygger og disassemblerer begge implementasjonene.

**Q1** kjører begge firmwarevariantene i simavr, stopper ved `eeprom_ready` og krever at observert adresse, skrevet verdi og lest verdi er `0x12`, `0x5a` og `0x5a`.

Q1 beviser den modellerte firmwaretransaksjonen. **Q2** kreves fortsatt for fysiske påstander som persistens gjennom faktisk strømbrudd, endurance, oppførsel ved ulike forsyningsspenninger og programmeringsforhold.

## Sjekk forståelsen

1. Hvorfor er EEPROM nyttig når SRAM allerede finnes?
2. Hvorfor bør variabler som endres ofte normalt ligge i SRAM?
3. Hvilke roller har EEAR, EEDR og EECR?
4. Hvorfor må firmware vente på at en EEPROM-skriving blir ferdig?
5. Hva beviser Q1-readback, og hva beviser den ikke?

!!! tip "Neste"
    Neste M5-emne er ADC. EEPROM gir oss først deterministisk persistent-data-oppførsel; ADC introduserer grensen mellom digital firmware og et analogt fysisk signal.
