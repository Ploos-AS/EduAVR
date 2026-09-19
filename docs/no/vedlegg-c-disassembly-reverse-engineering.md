# Vedlegg C — Disassembly og reverse engineering

## Formål
Lær å lese firmware-artifakter du selv har bygget og koble kildekode, ELF-struktur, maskinkode og MCU-oppførsel.

## Artifact-kjeden
```text
kilde -> compiler/assembler -> objektfiler -> linker -> ELF -> objcopy -> HEX
                                              |
                                              +-> symboler/seksjoner/disassembly
```

## ELF først
Foretrekk ELF når den finnes: den inneholder seksjoner, symboler og ofte debuginformasjon. HEX beskriver primært bytes som skal programmeres og mister normalt mye av denne konteksten.

Undersøk:
- vector table;
- `.text` og read-only data;
- initialverdier for `.data`;
- allokering i `.bss`;
- symboler og adresser;
- funksjonsgrenser der symboler finnes.

## Kontrollert analysemetode
1. bygg et EduAVR-eksempel;
2. lagre kildekode og ELF;
3. disassembler det;
4. identifiser reset/vector-kode;
5. finn én kjent funksjon;
6. spor register- og I/O-aksesser;
7. bygg på nytt med en liten kildeendring;
8. sammenlign den genererte koden.

## Compiler-fingeravtrykk
Se etter gjentakende mønstre i stedet for å memorere byte-sekvenser: funksjonsprolog/epilog, lagring av registre, kall, løkker, switch/branch-strukturer og I/O-aksesser.

## Raw HEX-øvelse
Gjenta analysen med bare den genererte HEX-filen. Rekonstruer det som faktisk kan fastslås, og dokumenter eksplisitt hvilken informasjon som er gått tapt.

## Avgrensning
Dette vedlegget bruker EduAVR-firmware eller annen firmware du har tillatelse til å analysere. Formålet er forståelse og debugging av embedded kode.
