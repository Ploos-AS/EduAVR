#!/bin/sh
set -eu
fail(){ printf 'M6 FAIL: %s\n' "$*" >&2; exit 1; }

command -v make >/dev/null 2>&1 || fail "make missing"
command -v mkdocs >/dev/null 2>&1 || fail "mkdocs missing"

printf '%s\n' "== M6 build =="
make clean all disasm size

printf '%s\n' "== M6 Q1 =="
sh tools/check_q1.sh

printf '%s\n' "== M6 resource gate =="
sh tools/check_resource_budget.sh

printf '%s\n' "== M6 capstone =="
sh tools/check_capstone_q1.sh

printf '%s\n' "== M6 memory report =="
sh tools/analyze_memory.sh
test -s build/memory-report.txt || fail "memory report is empty"

printf '%s\n' "== M6 docs =="
mkdocs build --strict

printf '%s\n' "M6 QUALIFICATION PASS"
