#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
DRY_RUN=0
INCLUDE_HOME_AGENTS=0
INCLUDE_GEMINI=0

usage() {
  cat <<'EOF'
Usage: scripts/uninstall.sh [--dry-run] [--include-home-agents] [--include-gemini]

Removes public AGI files installed by scripts/install.sh.

By default this removes only AGI-owned Codex skill, agent, hook, and example
config files. It does not remove ~/AGENTS.md or ~/.gemini/GEMINI.md unless you
explicitly pass the matching flag and the file looks AGI-owned.
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --dry-run) DRY_RUN=1 ;;
    --include-home-agents) INCLUDE_HOME_AGENTS=1 ;;
    --include-gemini) INCLUDE_GEMINI=1 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage; exit 2 ;;
  esac
  shift
done

run() {
  if [ "$DRY_RUN" -eq 1 ]; then
    printf '[dry-run]'
    printf ' %q' "$@"
    printf '\n'
  else
    "$@"
  fi
}

safe_rm() {
  local target="$1"
  if [ -e "$target" ] || [ -L "$target" ]; then
    run rm -rf "$target"
  fi
}

safe_rm "$CODEX_HOME/skills/agi"
safe_rm "$CODEX_HOME/config.example.toml"

for agent_name in \
  benchmark_researcher.toml \
  default.toml \
  design_pixel_perfect.toml \
  docs_researcher.toml \
  explorer.toml \
  oracle_critical.toml \
  reviewer.toml \
  rubric_evaluator.toml \
  ui_debugger.toml \
  worker.toml
do
  safe_rm "$CODEX_HOME/agents/$agent_name"
done

for hook_name in \
  session_start_autonomy.py \
  stop_autonomy.py \
  user_prompt_autonomy.py
do
  safe_rm "$CODEX_HOME/hooks/$hook_name"
done

if [ -f "$CODEX_HOME/hooks.json" ] && grep -q "session_start_autonomy.py" "$CODEX_HOME/hooks.json"; then
  safe_rm "$CODEX_HOME/hooks.json"
fi

if [ "$INCLUDE_HOME_AGENTS" -eq 1 ] && [ -f "$HOME/AGENTS.md" ]; then
  if grep -q "AGI_TEMPLATE:AGENTS:v1" "$HOME/AGENTS.md"; then
    safe_rm "$HOME/AGENTS.md"
  else
    echo "Skipping $HOME/AGENTS.md because it does not look AGI-owned." >&2
  fi
fi

if [ "$INCLUDE_GEMINI" -eq 1 ] && [ -f "$HOME/.gemini/GEMINI.md" ]; then
  if grep -q "AGI_TEMPLATE:GEMINI:v1" "$HOME/.gemini/GEMINI.md"; then
    safe_rm "$HOME/.gemini/GEMINI.md"
  else
    echo "Skipping $HOME/.gemini/GEMINI.md because it does not look AGI-owned." >&2
  fi
fi

echo "AGI uninstall step complete."
