# Security And Secrets

This repository must stay public-safe.

## Never Commit

- `~/.codex/config.toml` with real tokens.
- `~/.codex/sessions/`.
- `~/.codex-profiles/`.
- `~/.codex/logs_*.sqlite`.
- `~/.codex/state_*.sqlite`.
- `~/.codex/goals_*.sqlite`.
- browser cookies.
- account manager state.
- API keys.
- GitHub tokens.
- SSH keys.
- local project secrets.

## Before Publishing

```bash
./scripts/sanitize-check.sh
git status --short
```

`./scripts/validate.sh` also runs optional `gitleaks` and `trufflehog`
filesystem scans when those binaries are installed. Use at least one stronger
scanner before tagging a public release if you touched templates, scripts,
config examples, or docs that mention credentials.

If the scanner flags a real secret, rotate it before publishing. Removing it
from a commit is not enough once it was pushed.

## Safe Placeholders

Use obvious placeholders:

- `REPLACE_WITH_LOCAL_SECRET`
- `YOUR_GITHUB_USER`
- `YOUR_PROJECT_PATH`

Do not use realistic-looking fake tokens; scanners and humans should not need
to guess.

## Runtime Safety

AGI can be used with strict or permissive Codex settings. For public defaults,
prefer safe settings first and document any power-user mode as a deliberate
local choice.
