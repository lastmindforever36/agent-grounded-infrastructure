#!/usr/bin/env bash
set -euo pipefail

DRY_RUN=0
TARGET=""

usage() {
  cat <<'EOF'
Usage: scripts/restore-backup.sh --target PATH [--dry-run]

Restores the most recent PATH.bak.TIMESTAMP backup created by scripts/install.sh.
The current PATH is moved to PATH.pre-restore.TIMESTAMP before the backup is
restored.
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --dry-run) DRY_RUN=1 ;;
    --target)
      if [ "${2:-}" = "" ]; then
        echo "ERROR: --target requires a path." >&2
        exit 2
      fi
      TARGET="$2"
      shift
      ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage; exit 2 ;;
  esac
  shift
done

if [ "$TARGET" = "" ]; then
  usage >&2
  exit 2
fi

target_dir="$(dirname "$TARGET")"
if [ ! -d "$target_dir" ]; then
  echo "ERROR: target directory does not exist: $target_dir" >&2
  exit 1
fi

run() {
  if [ "$DRY_RUN" -eq 1 ]; then
    printf '[dry-run]'
    printf ' %q' "$@"
    printf '\n'
  else
    "$@"
  fi
}

backup="$(find "$target_dir" -maxdepth 1 -name "$(basename "$TARGET").bak.*" -printf '%T@ %p\n' 2>/dev/null | sort -n | tail -n 1 | cut -d' ' -f2-)"
if [ "$backup" = "" ]; then
  echo "ERROR: no backup found for $TARGET" >&2
  exit 1
fi

if [ -e "$TARGET" ] || [ -L "$TARGET" ]; then
  run mv "$TARGET" "${TARGET}.pre-restore.$(date +%Y%m%d-%H%M%S)"
fi

run mv "$backup" "$TARGET"
echo "Restored $TARGET from $backup"
