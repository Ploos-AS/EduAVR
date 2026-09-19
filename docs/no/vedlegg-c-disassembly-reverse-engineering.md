# Vedlegg C — Disassembly og reverse engineering

## Formål
Lær å lese firmware-artifakter du selv har bygget og koble kildekode, ELF, maskinkode og MCU-oppførsel.

```text
kilde -> compiler/assembler -> objekter -> linker -> ELF -> objcopy -> HEX
                                         |
                                         +-> symboler/seksjoner/disassembly
```

Foretrekk ELF når den finnes: den beholder seksjoner, symboler og ofte debuginformasjon. Undersøk vector table, .text, .data, .bss, symboler og funksjoner.

## Kontrollert metode
Bygg et EduAVR-eksempel, disassembler ELF, finn reset/vector-kode og en kjent funksjon, spor register/I/O-aksesser, gjør en liten kildeendring og sammenlign resultatet.

Gjenta deretter med bare HEX og dokumenter hvilken informasjon som er tapt.

## Avgrensning
Bruk EduAVR-firmware eller annen firmware du har tillatelse til å analysere. Målet er forståelse og debugging.
