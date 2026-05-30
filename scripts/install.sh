#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
AGENTS_HOME="${AGENTS_HOME:-$HOME/.agents}"
DRY_RUN=0
FORCE=0
INSTALL_SKILL=1
INSTALL_AGENTS=1
INSTALL_HOOKS="${AGI_INSTALL_HOOKS:-0}"
INSTALL_HOME_AGENTS=1
INSTALL_CONFIG=1
PROJECT_LOCAL_DIR=""

usage() {
  cat <<'EOF'
Usage: scripts/install.sh [--dry-run] [--force] [--hooks] [--no-hooks]
                          [--skill-only] [--agents-only]
                          [--skip-home-agents] [--project-local DIR]

Installs AGI Codex harness templates into the local user environment.

Environment:
  CODEX_HOME   default: $HOME/.codex
  AGENTS_HOME  default: $HOME/.agents
  AGI_INSTALL_HOOKS=1  install Codex hook templates
  AGI_INSTALL_GEMINI=1 to install templates/gemini/GEMINI.md even if .gemini does not exist
  AGI_INSTALL_MCPS=1 to also run scripts/install-mcps.sh

No secrets are installed. Edit $CODEX_HOME/config.toml manually for local MCP credentials.
Hooks are opt-in because they change runtime behavior on every Codex prompt.
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --dry-run) DRY_RUN=1 ;;
    --force) FORCE=1 ;;
    --hooks) INSTALL_HOOKS=1 ;;
    --no-hooks) INSTALL_HOOKS=0 ;;
    --skill-only)
      INSTALL_SKILL=1
      INSTALL_AGENTS=0
      INSTALL_HOOKS=0
      INSTALL_HOME_AGENTS=0
      INSTALL_CONFIG=0
      ;;
    --agents-only)
      INSTALL_SKILL=0
      INSTALL_AGENTS=1
      INSTALL_HOOKS=0
      INSTALL_HOME_AGENTS=0
      INSTALL_CONFIG=0
      ;;
    --skip-home-agents) INSTALL_HOME_AGENTS=0 ;;
    --project-local)
      if [ "${2:-}" = "" ]; then
        echo "ERROR: --project-local requires a directory." >&2
        exit 2
      fi
      PROJECT_LOCAL_DIR="$2"
      INSTALL_HOME_AGENTS=0
      shift
      ;;
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

backup_if_exists() {
  local target="$1"
  if [ ! -e "$target" ] && [ ! -L "$target" ]; then
    return 0
  fi

  local backup="${target}.bak.$(date +%Y%m%d-%H%M%S)"
  local counter=1
  while [ -e "$backup" ] || [ -L "$backup" ]; do
    backup="${target}.bak.$(date +%Y%m%d-%H%M%S).$counter"
    counter=$((counter + 1))
  done
  run mv "$target" "$backup"
}

install_file() {
  local src="$1"
  local dst="$2"
  run mkdir -p "$(dirname "$dst")"
  backup_if_exists "$dst"
  run cp "$src" "$dst"
}

install_dir() {
  local src="$1"
  local dst="$2"
  run mkdir -p "$(dirname "$dst")"
  backup_if_exists "$dst"
  run cp -R "$src" "$dst"
}

if [ "$INSTALL_SKILL" -eq 1 ]; then
  install_dir "$ROOT/skills/agi" "$CODEX_HOME/skills/agi"
fi

if [ "$INSTALL_AGENTS" -eq 1 ]; then
  install_dir "$ROOT/templates/codex/agents" "$CODEX_HOME/agents"
fi

if [ "$INSTALL_HOOKS" = "1" ]; then
  install_dir "$ROOT/templates/codex/hooks" "$CODEX_HOME/hooks"
  install_file "$ROOT/templates/codex/hooks/hooks.json" "$CODEX_HOME/hooks.json"
else
  echo "Skipping Codex hooks. Re-run with --hooks or AGI_INSTALL_HOOKS=1 to install them."
fi

if [ "$INSTALL_CONFIG" -eq 1 ]; then
  install_file "$ROOT/templates/codex/config.example.toml" "$CODEX_HOME/config.example.toml"
fi

if [ "$INSTALL_HOME_AGENTS" -eq 1 ] && { [ ! -e "$HOME/AGENTS.md" ] || [ "$FORCE" -eq 1 ]; }; then
  install_file "$ROOT/templates/AGENTS.md" "$HOME/AGENTS.md"
elif [ "$INSTALL_HOME_AGENTS" -eq 1 ]; then
  echo "Skipping $HOME/AGENTS.md because it already exists. Use --force to replace with backup."
fi

if [ "$PROJECT_LOCAL_DIR" != "" ]; then
  run mkdir -p "$PROJECT_LOCAL_DIR"
  install_file "$ROOT/templates/AGENTS.md" "$PROJECT_LOCAL_DIR/AGENTS.md"
fi

if [ "${AGI_INSTALL_GEMINI:-0}" = "1" ] || [ -d "$HOME/.gemini" ]; then
  install_file "$ROOT/templates/gemini/GEMINI.md" "$HOME/.gemini/GEMINI.md"
fi

if [ "${AGI_INSTALL_MCPS:-0}" = "1" ]; then
  if [ "$DRY_RUN" -eq 1 ]; then
    "$ROOT/scripts/install-mcps.sh" --dry-run
  else
    run "$ROOT/scripts/install-mcps.sh"
  fi
fi

echo "AGI install complete."
echo "Next: copy relevant sections from $CODEX_HOME/config.example.toml into your private $CODEX_HOME/config.toml and add local MCP secrets there."
