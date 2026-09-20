# M1 — Åpen AVR-verktøykjede

!!! abstract "Læringsmål"
    Etter leksjonen skal du kunne installere EduAVR-verktøyene, bygge referansefirmware, kjøre prosjektkontrollene og undersøke generert AVR-maskinkode.

!!! info "Forutsetninger"
    Et Debian-basert miljø eller EduAVR-utviklingscontaineren, samt grunnleggende kommandolinjebruk.

EduAVR bruker en kommandolinjeførst verktøykjede basert på AVR-GCC, GNU AVR Binutils, AVR-LibC, AVRDUDE og GNU Make.

## Anbefalt: EduAVR-utviklingscontaineren

Den publiserte EduAVR OCI-imagen er det anbefalte reproduserbare kursmiljøet. Den inneholder AVR-kompilator/verktøykjede, avr-gdb, AVRDUDE, AVaRICE, simavr og native biblioteker som Q1-simulator-testene bruker.

Klon kursrepoet og start imaget med repoet montert som `/workspace`.

### Docker

```sh
docker pull ghcr.io/ploos-as/eduavr:latest
docker run --rm -it \
  -v "$PWD:/workspace" \
  -w /workspace \
  ghcr.io/ploos-as/eduavr:latest
```

### Podman

```sh
podman pull ghcr.io/ploos-as/eduavr:latest
podman run --rm -it \
  -v "$PWD:/workspace:Z" \
  -w /workspace \
  ghcr.io/ploos-as/eduavr:latest
```

Inne i containeren bruker `make check` og `sh tools/check_q1.sh` samme verktøymiljø som kvalifiseres i CI.

!!! note "Tilgang til fysisk maskinvare"
    Containeren er først og fremst laget for bygging, inspeksjon og simulatorbasert Q1-arbeid. Viderekobling av fysisk programmerer eller serieport til Docker/Podman er vertsspesifikt og hører til Q2-oppsettet.

## Simulatoroppsett

EduAVR bruker **simavr** som Q1-simulator. Du trenger ikke laste ned en egen EduAVR-simulator. Den enkleste løsningen er utviklingscontaineren over, der simavr, avr-gdb og nødvendige simulatorbiblioteker allerede er installert.

Kontroller simulatoren inne i containeren med:

```sh
simavr --help
avr-gdb --version
```

Kjør hele den deterministiske simulator-kvalifikasjonen for kurset med:

```sh
sh tools/check_q1.sh
```

Kurset bruker simavr til å kjøre ATmega1284P-firmware og avr-gdb sammen med små simulator-harnesser for å observere registre, SRAM, avbrudd og modellerte periferienheter. De enkelte leksjonene forklarer den relevante proben; det kreves ikke en separat grafisk simulatorapplikasjon.

## Native installasjon på Debian

Native Debian-installasjon støttes fortsatt fullt ut:

```sh
sudo apt update
sudo apt install gcc gcc-avr binutils-avr avr-libc avrdude avarice gdb-avr make simavr libsimavr-dev libelf-dev
```

Containeren anbefales når du ønsker det mest reproduserbare kursmiljøet; native pakker kan være praktisk når vertsmaskinen skal ha direkte tilgang til fysisk maskinvare.

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
