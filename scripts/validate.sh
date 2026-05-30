#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

bash -n scripts/install.sh
bash -n scripts/install-mcps.sh
bash -n scripts/sanitize-check.sh

python3 - <<'PY'
import pathlib
import re
import sys

try:
    import tomllib
except ModuleNotFoundError:
    print("Python tomllib missing; use Python 3.11+ for TOML validation", file=sys.stderr)
    raise

root = pathlib.Path(".")
for path in list(root.glob("templates/**/*.toml")):
    with path.open("rb") as handle:
        tomllib.load(handle)
    print(f"TOML OK {path}")

missing = []
for path in root.rglob("*.md"):
    if ".git" in path.parts:
        continue
    text = path.read_text(encoding="utf-8")
    for match in re.finditer(r"(?<!!)\[[^\]]+\]\(([^)]+)\)", text):
        target = match.group(1).strip()
        if (
            not target
            or target.startswith(("#", "http://", "https://", "mailto:"))
            or target.startswith("REPLACE_")
        ):
            continue
        target = target.split("#", 1)[0]
        target = target.split("?", 1)[0]
        candidate = (path.parent / target).resolve()
        try:
            candidate.relative_to(root.resolve())
        except ValueError:
            missing.append((path, target, "outside repo"))
            continue
        if not candidate.exists():
            missing.append((path, target, "missing"))

if missing:
    for source, target, reason in missing:
        print(f"Broken markdown link in {source}: {target} ({reason})", file=sys.stderr)
    raise SystemExit(1)
print("Markdown links OK")
PY

./scripts/sanitize-check.sh

echo "validate: PASS"
