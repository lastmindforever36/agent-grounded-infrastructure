#!/usr/bin/env bash
set -euo pipefail

DRY_RUN=0
SKIP_NODE=0
SKIP_UV=0

usage() {
  cat <<'EOF'
Usage: scripts/install-mcps.sh [--dry-run] [--skip-node] [--skip-uv]

Installs the no-secret MCP/client binaries used by AGI.

This script does not write API keys and does not copy private Codex state.
After installing binaries, copy the relevant MCP blocks from
templates/codex/config.example.toml into your private ~/.codex/config.toml and
add your own credentials for GitHub, Brave Search, Stitch, etc.

Environment:
  AGI_CONFIGURE_CODEGRAPH=1  run "codegraph install --target codex --location global -y"
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --dry-run) DRY_RUN=1 ;;
    --skip-node) SKIP_NODE=1 ;;
    --skip-uv) SKIP_UV=1 ;;
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

need_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "ERROR: required command not found: $1" >&2
    echo "Install it first or rerun with the matching --skip-* flag." >&2
    exit 2
  fi
}

if [ "$SKIP_NODE" -ne 1 ]; then
  need_command npm
  run npm install -g \
    @colbymchenry/codegraph \
    @playwright/mcp \
    @modelcontextprotocol/server-github \
    @modelcontextprotocol/server-brave-search \
    @_davideast/stitch-mcp
fi

if [ "$SKIP_UV" -ne 1 ]; then
  need_command uv
  run uv tool install mcp-server-git
  run uv tool install mcp-server-fetch
  run uv tool install mcp-server-time
  run uv tool install grep-mcp
  run uv tool install duckduckgo-mcp-server
  run uv tool install scrapling
fi

if [ "${AGI_CONFIGURE_CODEGRAPH:-0}" = "1" ]; then
  if command -v codegraph >/dev/null 2>&1 || [ "$DRY_RUN" -eq 1 ]; then
    run codegraph install --target codex --location global -y
  else
    echo "ERROR: codegraph not found after install." >&2
    exit 1
  fi
fi

if [ "$DRY_RUN" -eq 0 ]; then
  echo "Installed/checked AGI MCP binaries:"
  for command_name in \
    codegraph \
    playwright-mcp \
    mcp-server-github \
    mcp-server-brave-search \
    stitch-mcp \
    mcp-server-git \
    mcp-server-fetch \
    mcp-server-time \
    grep-mcp \
    duckduckgo-mcp-server \
    scrapling
  do
    if command -v "$command_name" >/dev/null 2>&1; then
      printf '  PASS %-28s %s\n' "$command_name" "$(command -v "$command_name")"
    else
      printf '  MISS %-28s\n' "$command_name"
    fi
  done
fi

echo "MCP install step complete."
