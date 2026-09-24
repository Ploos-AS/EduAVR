#!/usr/bin/env python3
"""Check structural English/Norwegian documentation parity.

This gate deliberately checks structure, not translation quality. Semantic parity
still requires review, but missing learner-facing counterparts should fail CI.
"""
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1] / "docs"
EN = ROOT / "en"
NO = ROOT / "no"

def md_files(root):
    return {p.relative_to(root).as_posix() for p in root.rglob("*.md")}

en = md_files(EN)
no = md_files(NO)

# Norwegian files may use translated slugs, so exact filenames are not a useful
# invariant. Gate on the number and numbered course/appendix structure instead.
def numbered(files):
    return sorted(p for p in files if Path(p).name[:2].isdigit())

errors = []
if len(en) != len(no):
    errors.append(f"Markdown file count differs: EN={len(en)} NO={len(no)}")
if len(numbered(en)) != len(numbered(no)):
    errors.append(
        f"Numbered lesson count differs: EN={len(numbered(en))} NO={len(numbered(no))}"
    )

# Every language track must retain its landing page.
for lang, files in (("EN", en), ("NO", no)):
    if "index.md" not in files:
        errors.append(f"{lang}: missing index.md")

if errors:
    print("Documentation parity gate: FAIL")
    for error in errors:
        print(f"- {error}")
    sys.exit(1)

print(f"Documentation parity gate: PASS (EN={len(en)} markdown files, NO={len(no)})")
print("Note: semantic translation parity remains a human-review requirement.")
