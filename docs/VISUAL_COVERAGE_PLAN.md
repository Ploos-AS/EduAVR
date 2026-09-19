# EduAVR Visual Coverage Plan

This document turns [VISUAL_POLICY.md](VISUAL_POLICY.md) into a production checklist. It defines useful figures before we capture them, so visuals are created from real artifacts at the right project stage rather than added decoratively afterwards.

**Language rule:** English and Norwegian normally share the same language-neutral artifact. Captions and explanatory text are localized in the respective document.

## Status vocabulary

- **NOW** — can be produced from the current repository/toolchain without EduBoard hardware.
- **CAD** — capture after the corresponding EduBoard schematic/PCB design is stable enough to cite a revision.
- **Q1** — produce from the reproducible simulator/debugger environment.
- **Q2** — requires physical EduBoard-AVR hardware or physical measurement.
- **CONCEPT** — source-controlled conceptual diagram; must not look like measured/real evidence.

## Core chapters

| Course topic | Preferred visual | Source/type | Stage |
| --- | --- | --- | --- |
| Course principles | ASM -> C -> generated ASM -> hardware learning loop | CONCEPT diagram | NOW |
| Toolchain | source -> gcc/as -> ELF -> objcopy -> HEX pipeline plus real build excerpt | diagram + real terminal | NOW |
| AVR architecture | CPU/register/SRAM/Flash/I/O memory relationship | faithful conceptual diagram based on datasheet | NOW |
| GPIO | actual EduBoard LED/button schematic excerpt; real DDR/PORT/PIN debugger view | KiCad + debugger | CAD/Q1 |
| Stack/functions | real avr-gdb stack/register session around CALL/RET | screenshot | Q1 |
| Timers/interrupts | timer mental model plus real debugger/vector trace | diagram + screenshot | NOW/Q1 |
| PWM | real simulated timer trace; later scope/logic capture from PWM test point | Q1 trace + Q2 capture | Q1/Q2 |
| USART | real terminal session and TTL UART capture | terminal + analyzer | Q1/Q2 |
| Dual UART bridge | data-flow diagram; later real two-port terminal/logic capture | diagram + capture | NOW/Q2 |
| SPI | real SCK/MOSI/MISO/SS transaction capture | analyzer | Q2 |
| TWI/I2C | real START/address/ACK/data/STOP capture | analyzer | Q2 |
| ADC | POT0/AREF schematic excerpt, debugger ADC result, later measured input vs ADC code | KiCad + Q1/Q2 | CAD/Q1/Q2 |
| EEPROM | memory map/sequence diagram and real debugger/programmer verification | diagram + screenshot | NOW/Q1 |
| INTx/PCINT + debounce | EduBoard interrupt-capable button route and real switch-bounce capture | KiCad + scope/analyzer | CAD/Q2 |
| 7-segment | actual display driver schematic plus real multiplex capture/photo | KiCad + analyzer/photo | CAD/Q2 |
| RGB PWM | actual driver schematic, raw PWM capture and real RGB0 photo | KiCad + capture/photo | CAD/Q2 |
| Buzzer | actual driver schematic and measured timer-output waveform | KiCad + capture | CAD/Q2 |
| DIP/binary | real board close-up showing DIP state and resulting LEDs/display | photo | Q2 |
| HD44780 LCD | actual LCD0 schematic/pin path and real display photo | KiCad + photo | CAD/Q2 |

## Appendices A-M

| Appendix | Key visuals | Stage |
| --- | --- | --- |
| A Arduino | same program: Arduino source -> verbose build/disassembly vs direct C/ASM | NOW |
| B Debugging | real avr-gdb register/disassembly/source/stack sessions | Q1 |
| C Disassembly | real ELF sections/symbols/vector table and objdump excerpt | NOW |
| D C <-> Assembly | side-by-side real C and generated AVR disassembly at two optimization levels | NOW |
| E Memory | ELF section/map output plus conceptual Flash/SRAM/EEPROM layout | NOW |
| F Programming | real AVRDUDE identify/program/verify session; later ISP connector photo | NOW/Q2 |
| G Electronics | canonical EduBoard pull-up, LED, transistor-driver and decoupling schematic excerpts | CAD |
| H Protocol analysis | real UART/SPI/I2C analyzer captures | Q2 |
| I Performance | real size/disassembly/timing comparison table/trace | NOW/Q1 |
| J Testing | Q0/Q1/Q2 evidence flow; real CI excerpt; later HIL setup photo | NOW/Q2 |
| K Build board | minimal-system schematic, breadboard/prototype and final PCB photos | CAD/Q2 |
| L Retro computing | real serial bridge setup and terminal traffic when built | Q2 |
| M Datasheet guide | annotated excerpt references/reading path, respecting source licensing | NOW |

## EduBoard overview set

Once the board design is sufficiently stable, produce a reusable shared set:

1. top-view KiCad PCB render with no invented components;
2. actual schematic overview or hierarchy;
3. MCU/power/clock/reset excerpt;
4. ISP/JTAG/programming excerpt;
5. LED/button/DIP/pot excerpt;
6. TTL UART versus MAX232/DE-9 RS-232 excerpt;
7. SPI/TWI headers and pull-up configuration;
8. RGB/buzzer driver excerpt;
9. seven-segment driver/multiplex excerpt;
10. LCD0 excerpt;
11. labelled pin/peripheral map derived from the frozen board revision;
12. physical top-view board photograph after prototype manufacture.

The labelled overview must be regenerated when the board revision changes materially.

## Screenshot production set

Create reproducible captures from repository examples/scripts rather than staged fake UI:

- toolchain version output;
- clean build producing ELF/HEX;
- `avr-size` output;
- `avr-objdump` source/disassembly;
- simavr startup/run;
- avr-gdb register inspection;
- avr-gdb stack/CALL exercise;
- interrupt-vector/ISR debug session;
- C vs generated assembly comparison;
- AVRDUDE identify/program/verify where real hardware is available.

Where practical, keep the command used to produce a screenshot in accompanying metadata.

## Q2 capture set

Do not fabricate these before hardware exists:

- mechanical switch bounce;
- PWM raw MCU output and driver/load behavior;
- UART TTL waveform;
- RS-232 transceiver-side waveform where safely measurable;
- SPI transaction;
- TWI/I2C transaction;
- RGB PWM channels;
- buzzer timer output/frequency;
- seven-segment multiplex scan;
- ADC input/reference measurement;
- LCD operation;
- board power/reset/clock bring-up evidence.

## Figure metadata

For evidence-oriented figures, keep a neighboring Markdown/text record or caption containing as applicable:

```text
Figure:
Course/exercise:
Source:
Board revision:
Firmware commit/build:
Tool/instrument:
Tool/version:
Qualification: Q0 | Q1 | Q2 | N/A
Capture date:
Notes:
```

## Production order

### Phase V1 — repository/toolchain visuals
**QUALIFIED / automated.** CI produces `eduavr-v1-visual-sources` with real toolchain, ELF/disassembly, compiler-comparison and size material. The artifact also carries a manifest linking figure sources to teaching use.

### Phase V2 — EduBoard CAD visuals
After schematic sections are stable, export real KiCad excerpts and board renders. Never redraw pin mappings from memory.

### Phase V3 — Q1 simulator/debugger visuals
**QUALIFIED / automated for timer, PWM, USART0/1, SPI and TWI.** CI preserves the verbatim simavr/avr-gdb logs from the same Q1 qualification run under `q1/`, with a bilingual-use figure manifest. These logs are canonical figure sources; they may be typeset/cropped for readability, but must not be presented as photographed terminal UI. Stack/CALL is also Q1-qualified and its paired C/Assembly GDB logs are preserved in the artifact. EEPROM/ADC sessions remain future coverage.

### Phase V4 — Q2 physical visuals
After prototype availability, photograph the board and capture actual electrical behavior. Link captures to board revision and firmware build.

### Phase V5 — editorial pass
Insert figures into both EN/NO tracks, localize captions, verify readability in Markdown/PDF output and remove redundant decoration.

## Definition of done

A chapter/appendix does **not** need an image merely to look complete. A visual is done when it teaches or proves something better than text alone, follows the visual policy, has adequate provenance, and appears with equivalent explanatory context in both language tracks.
