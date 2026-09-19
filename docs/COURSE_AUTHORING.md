# EduAVR course authoring guide

This document defines how EduAVR course material is authored, reviewed and published.

## Single source of truth

Markdown in this repository is the canonical source for the course.

- Author and review course content as `.md` files.
- Do not hand-edit generated HTML.
- Do not commit the generated MkDocs `site/` directory.
- GitHub Pages is a derived publication of the Markdown source.
- A change to the published course should originate as a Markdown change in the repository.

## Language structure

EduAVR is bilingual. English and Norwegian are both first-class course tracks.

- English: `docs/en/`
- Norwegian: `docs/no/`

New core lessons should normally be represented in both tracks. The two versions should teach the same technical concepts and learning objectives, but they do not need to be literal word-for-word translations.

When adding or renaming a lesson, update `mkdocs.yml` so navigation remains complete in both languages.

## Lesson structure

Use a consistent pedagogical structure where it fits the topic:

1. learning goals
2. prerequisites
3. hardware/architecture theory
4. relevant registers, bits, memory or data flow
5. AVR assembly implementation
6. simulator observation or qualification
7. physical-board exercise where appropriate
8. equivalent C implementation
9. **Under the hood** comparison with compiler-generated AVR assembly
10. expected result
11. questions/exercises
12. troubleshooting or debugging notes where useful
13. summary and next lesson

Assembly should normally introduce the mechanism before C abstracts it.

## Exercise classification

Classify practical work according to where it is most useful:

- **SIM** — CPU state, instructions, registers, flags, SRAM, stack, timing and interrupt behaviour.
- **BOARD** — physical I/O, LEDs, switches, displays, UART, ADC, PWM, buses and electrical behaviour.
- **SIM → BOARD** — understand and verify the mechanism in simulation first, then reproduce it on EduBoard-AVR or STK500.

Do not claim physical qualification when only simulator qualification has been performed.

## Visual material

Visuals should teach something that is harder to understand from prose alone.

Prefer authentic material:

- real EduBoard schematics and PCB renders from the hardware source
- real screenshots from the simulator, compiler, debugger and other course tools
- reproducibly generated diagrams based on repository sources
- real photographs when documenting physical hardware

Do not use an AI-generated or illustrative image as if it were an accurate screenshot, schematic, board layout or representation of hardware that exists.

Follow `VISUAL_POLICY.md` and `VISUAL_COVERAGE_PLAN.md`.

## Local preview

Install the documentation dependencies:

```sh
python -m pip install -r requirements-docs.txt
```

Start a local development server:

```sh
mkdocs serve
```

MkDocs will rebuild the site while Markdown files are edited.

## Strict validation

Before merging documentation changes, validate the complete site:

```sh
mkdocs build --strict
```

Warnings are treated as errors. In particular, keep navigation targets, internal links and referenced files valid.

The `docs-check` GitHub Actions workflow performs this validation for documentation pull requests.

## Publishing

The GitHub Pages workflow builds the course from Markdown on `main` and deploys the generated site.

The generated HTML is a publication artifact, not source material. If the rendered course is wrong, fix the Markdown, MkDocs configuration, assets or build tooling rather than editing generated HTML.

## Technical accuracy

Examples should be reproducible with the EduAVR toolchain and should identify their qualification level.

When code depends on a particular MCU, board, clock frequency or peripheral configuration, state that assumption explicitly. The primary reference MCU is ATmega1284P-PU unless a lesson deliberately uses another target.

## Review checklist

Before considering course material complete, verify:

- technical claims and register names against the relevant device documentation
- code builds with the documented toolchain
- simulator examples behave as documented
- physical-hardware claims are backed by physical qualification
- English and Norwegian navigation remain coherent
- links and assets pass `mkdocs build --strict`
- generated HTML has not been committed
- screenshots and diagrams follow the visual policy
