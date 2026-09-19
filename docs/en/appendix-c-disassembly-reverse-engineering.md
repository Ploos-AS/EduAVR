# Appendix C — Disassembly and reverse engineering

## Purpose
Learn to read firmware artifacts you built yourself and connect source, ELF structure, machine code and MCU behavior.

## Artifact chain
```text
source -> compiler/assembler -> object files -> linker -> ELF -> objcopy -> HEX
                                              |
                                              +-> symbols/sections/disassembly
```

## ELF first
Prefer the ELF when available: it contains sections, symbols and often debug information. HEX primarily describes bytes to program and normally loses much of that context.

Inspect:
- vector table;
- .text and read-only data;
- .data initial values;
- .bss allocation;
- symbols and addresses;
- function boundaries where symbols exist.

## Controlled analysis method
1. build an EduAVR example;
2. save source and ELF;
3. disassemble it;
4. identify reset/vector code;
5. locate one known function;
6. trace register/I/O accesses;
7. rebuild with a small source change;
8. compare the generated code.

## Compiler fingerprints
Look for recurring patterns rather than memorizing byte sequences: function prologue/epilogue, register saves, calls, loops, switch/branch structures and I/O access.

## Raw HEX exercise
Repeat with only the generated HEX. Reconstruct what can be established and explicitly record what information has been lost.

## Boundary
This appendix uses EduAVR firmware or other firmware you are authorized to analyze. Its purpose is understanding and debugging embedded code.
