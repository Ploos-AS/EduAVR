# EduAVR Visual and Illustration Policy

## Purpose
EduAVR uses images to improve understanding, but technical accuracy takes priority over decoration. A learner must be able to trust that an image presented as evidence of hardware, software or measured behaviour represents the real thing.

## 1. Real technical artifacts are the default
When a figure represents an actual EduAVR/EduBoard implementation, use a real artifact whenever practical:

- photographs of the actual EduBoard-AVR revision or prototype;
- KiCad schematic excerpts generated from the actual EduBoard source;
- PCB layout/3D renders generated from the actual KiCad design;
- real terminal output from the documented toolchain;
- real compiler/assembler/linker/disassembly output;
- real simavr and avr-gdb sessions;
- real logic-analyzer or oscilloscope captures for Q2 material;
- real programmer/debugger output and build/CI logs where pedagogically useful.

Do not substitute a plausible-looking generated board, schematic, terminal, debugger, waveform or measurement for an artifact that is being presented as real.

## 2. Generated illustrations
Generated or hand-created illustrations are allowed when they explain an abstract concept rather than claim to document an implementation. Appropriate examples include:

- CPU/data-flow mental models;
- C -> compiler -> AVR assembly -> hardware diagrams;
- simplified memory maps;
- conceptual protocol/state-machine diagrams;
- clearly illustrative cover/header artwork.

Such figures must not invent EduBoard pin mappings, component placement, measurements, tool output or other implementation facts. If there is any realistic chance of confusion, label the figure **Conceptual illustration / Konseptillustrasjon**.

## 3. Schematics and diagrams
For actual EduBoard circuitry, prefer an excerpt/export from the canonical EduBoard KiCad source. A simplified pedagogical redraw is allowed only when it remains electrically faithful to the relevant circuit and is labelled as simplified.

Board pin names and mappings must come from the current qualified design/revision, not from an old course draft or generated image.

## 4. Screenshots
Screenshots should be reproducible from the documented environment where practical. Record enough context to identify:

- tool and relevant version;
- example/exercise/build being shown;
- whether the image is Q0, Q1 or Q2 evidence when relevant.

Crop screenshots for readability, but do not edit terminal/debugger output in a way that changes its technical meaning.

## 5. Measurements and qualification
Figures used as qualification evidence require stronger provenance.

- Q1 evidence must identify the simulator/model and test.
- Q2 evidence must come from physical hardware and identify the relevant board revision/setup.
- Synthetic/generated waveforms are diagrams, never measurement evidence.
- A generated image can never establish Q0/Q1/Q2 PASS.

## 6. English and Norwegian
English and Norwegian are equal first-class course tracks.

Prefer sharing the same language-neutral technical artifact between `docs/en` and `docs/no` when possible. Captions, callouts and explanatory text must be available in both languages. If text is embedded in an image, either provide language-specific variants or keep the embedded text minimal and language-neutral.

A figure is not a reason for one language track to contain less technical information than the other.

## 7. Provenance
Course figures should have traceable provenance. For repository-owned artifacts, prefer storing source/generated assets in the repository or documenting the source path/revision.

For external images, record source, author/owner and license/permission as required. Do not copy an image merely because it is publicly visible online.

Recommended figure metadata when relevant:

```text
Source: EduBoard KiCad / real hardware / simavr / avr-gdb / instrument
Revision/build: ...
Tool/version: ...
Qualification: Q0 | Q1 | Q2 | N/A
License/source: ...
```

## 8. Asset organization
Use `docs/assets/` for shared visual assets. Keep original/source material where practical and use descriptive filenames. Avoid embedding an important technical figure only as an opaque screenshot when a reproducible source exists.

## 9. Review rule
Before merging a technical figure, ask:

1. Is it real evidence, a faithful technical diagram, or a conceptual illustration?
2. Could a learner mistake it for something it is not?
3. Is its hardware/software revision clear enough?
4. Can its important technical claim be reproduced or traced?
5. Does it work equally for the English and Norwegian course tracks?

If these cannot be answered confidently, the figure is not course-ready.
