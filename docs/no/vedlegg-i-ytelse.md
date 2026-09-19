# Vedlegg I — Ytelse og optimalisering

## Formål
Mål før du optimaliserer, og koble ytelsespåstander til AVR-instruksjoner og ressurser.

## Måleverdier
- instruksjonssykluser og kjøretid;
- interrupt-latency og ISR-varighet;
- Flash-størrelse;
- statisk SRAM-bruk;
- stack-bruk;
- peripheral-throughput;
- energi/effekt bare når det er fysisk målt.

## Cycle-analyse
Bruk timing fra instruksjonssettet sammen med den faktiske kontrollflytbanen. Branches, kall, minneaksesser og flerbyte-operasjoner har betydning.

## C kontra assembler
Sammenlign ekvivalent oppførsel, ikke kunstige snippets. Registrer compiler-versjon/options og inspiser generert assembler. Håndskrevet assembler er verdifullt når det øker forståelsen eller oppfyller et målt krav, ikke fordi det antas å være raskere.

## Optimaliseringseksperiment
Bygg én øvelse med flere optimization levels. Registrer Flash/SRAM, disassembly og målt/modellert timing. Forklar semantiske endringer som skyldes undefined behavior separat fra legitim optimalisering.

## Interrupts
Mål den verste relevante banen, ikke bare gjennomsnittlig kjøretid. Lange ISR-er kan påvirke latency andre steder.

## Regel
Oppgi for hvert tall om det er beregnet, simulert eller fysisk målt.
