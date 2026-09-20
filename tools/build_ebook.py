#!/usr/bin/env python3
"""Build linear EduAVR Markdown manuscripts for EPUB/Kindle."""
from pathlib import Path
import argparse, re
ROOT=Path(__file__).resolve().parents[1]; DOCS=ROOT/"docs"
CORE={
"en":["00-course-principles.md","01-toolchain.md","02-avr-architecture.md","03-gpio.md","04-stack-functions.md","05-timers-interrupts.md","06-pwm.md","07-usart.md","09-dual-uart-bridge.md","10-spi.md","11-twi-i2c.md","12-eeprom.md","13-adc.md","14-data-structures.md","15-volatile-atomicity.md","16-resource-budget.md","17-optimization.md","18-code-size-sram-analysis.md","19-integrated-systems-capstone.md"],
"no":["00-course-principles.md","01-toolchain.md","02-avr-architecture.md","03-gpio.md","04-stack-functions.md","05-timers-interrupts.md","06-pwm.md","07-usart.md","09-dual-uart-bridge.md","10-spi.md","11-twi-i2c.md","12-eeprom.md","13-adc.md","14-data-structures.md","15-volatile-atomicity.md","16-resource-budget.md","17-optimalisering.md","18-kode-storrelse-sram-analyse.md","19-integrert-systems-capstone.md"]}
APP={"en":["appendix-a-arduino.md","appendix-b-debugging.md","appendix-c-disassembly-reverse-engineering.md","appendix-d-c-assembly-compiler.md","appendix-e-memory-internals.md","appendix-f-programming-bootloaders.md","appendix-g-electronics.md","appendix-h-protocol-analysis.md","appendix-i-performance.md","appendix-j-testing-qualification.md","appendix-k-build-board.md","appendix-l-retro-computing.md","appendix-m-datasheet-guide.md","appendix-i-reading-datasheets.md"],"no":["vedlegg-a-arduino.md","vedlegg-b-debugging.md","vedlegg-c-disassembly-reverse-engineering.md","vedlegg-d-c-assembler-kompilator.md","vedlegg-e-minne.md","vedlegg-f-programmering-bootloadere.md","vedlegg-g-elektronikk.md","vedlegg-h-protokollanalyse.md","vedlegg-i-ytelse.md","vedlegg-j-testing-kvalifikasjon.md","vedlegg-k-bygg-avr-board.md","vedlegg-l-retro.md","vedlegg-m-databladguide.md","appendix-i-reading-datasheets.md"]}
def clean(s):
    """Convert MkDocs-oriented Markdown into conservative Pandoc Markdown."""
    # Flatten simple MkDocs admonitions while preserving their text.
    s = re.sub(
        r'^!!! (?:\\w+)(?: "[^"]*")?\\n((?:    .*\\n?)*)',
        lambda m: "\\n" + re.sub(r"^    ", "", m.group(1), flags=re.M) + "\\n",
        s,
        flags=re.M,
    )
    # A combined EPUB manuscript does not need source-file navigation links.
    s = re.sub(
        r'\\[([^\\]]+)\\]\\((?!https?://|#|mailto:)[^)]+\\.md(?:#[^)]*)?\\)',
        r'\\1',
        s,
    )
    return s

def main():
    a=argparse.ArgumentParser(); a.add_argument("language",choices=["en","no"]); a.add_argument("output",type=Path); x=a.parse_args()
    paths=[DOCS/x.language/"COURSE_OUTLINE.md"]+[DOCS/x.language/n for n in CORE[x.language]+APP[x.language]]
    miss=[str(p.relative_to(ROOT)) for p in paths if not p.exists()]
    if miss: raise SystemExit("missing ebook sources: "+", ".join(miss))
    x.output.parent.mkdir(parents=True,exist_ok=True); x.output.write_text("\n\n\\newpage\n\n".join(clean(p.read_text()).rstrip() for p in paths)+"\n")
if __name__=="__main__": main()
