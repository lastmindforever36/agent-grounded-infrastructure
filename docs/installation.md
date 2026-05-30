# Installation

## Requirements

- Linux or macOS shell.
- Codex CLI installed.
- Python 3.11+ recommended for TOML validation.
- Optional MCP server binaries installed for the capabilities you want.

## Install

Ask an agent to do it:

```text
Install AGI from https://github.com/don0736/agent-grounded-infrastructure.
Read the README and docs/installation.md first. Run validate, run install
with --dry-run, explain what files will be copied, then install only the
public-safe harness. Do not copy private tokens, sessions, profiles, cookies,
logs, or account state.
```

Or run it yourself:

```bash
./scripts/validate.sh
./scripts/install.sh --dry-run
./scripts/install.sh
```

Hooks are opt-in because they run on every Codex session/prompt/stop event:

```bash
./scripts/install.sh --hooks --dry-run
./scripts/install.sh --hooks
```

Optional MCP binaries:

```bash
./scripts/install-mcps.sh --dry-run
./scripts/install-mcps.sh
```

Or together:

```bash
AGI_INSTALL_MCPS=1 ./scripts/install.sh --dry-run
AGI_INSTALL_MCPS=1 ./scripts/install.sh
```

The installer writes:

- `skills/agi` into `$CODEX_HOME/skills/agi`;
- Codex agent templates into `$CODEX_HOME/agents`;
- hook templates into `$CODEX_HOME/hooks` only when `--hooks` or
  `AGI_INSTALL_HOOKS=1` is used;
- `config.example.toml` into `$CODEX_HOME/config.example.toml`;
- `templates/AGENTS.md` into `$HOME/AGENTS.md` if no file exists;
- `templates/gemini/GEMINI.md` into `$HOME/.gemini/GEMINI.md` if requested or
  if the directory already exists.
- optional MCP binaries when `AGI_INSTALL_MCPS=1`.

Existing files are backed up unless you run with `--dry-run`. `--force`
replaces the target cleanly instead of merging directories, while still leaving
a timestamped backup.

## Safer Install Modes

Install only the router skill:

```bash
./scripts/install.sh --skill-only --dry-run
./scripts/install.sh --skill-only
```

Install only the subagent templates:

```bash
./scripts/install.sh --agents-only --dry-run
./scripts/install.sh --agents-only
```

Avoid global `~/AGENTS.md` and install the operating model in one project:

```bash
./scripts/install.sh --skip-home-agents --project-local /path/to/project --dry-run
./scripts/install.sh --skip-home-agents --project-local /path/to/project
```

Test the installer in an isolated HOME before touching your real user profile:

```bash
tmp_home="$(mktemp -d)"
HOME="$tmp_home" CODEX_HOME="$tmp_home/.codex" ./scripts/install.sh --dry-run
HOME="$tmp_home" CODEX_HOME="$tmp_home/.codex" ./scripts/install.sh --hooks
find "$tmp_home" -maxdepth 4 -type f | sort
```

Undo AGI-owned installed files:

```bash
./scripts/uninstall.sh --dry-run
./scripts/uninstall.sh
```

Restore a backup created by the installer:

```bash
./scripts/restore-backup.sh --target "$HOME/.codex/agents" --dry-run
./scripts/restore-backup.sh --target "$HOME/.codex/agents"
```

## Environment Variables

```bash
export CODEX_HOME="$HOME/.codex"
export AGI_INSTALL_HOOKS=1
export AGI_INSTALL_GEMINI=1
```

## MCP Credentials

Do not commit secrets. Add them only to your private local config.

Typical optional secrets:

- `GITHUB_PERSONAL_ACCESS_TOKEN`
- `BRAVE_API_KEY`
- `STITCH_API_KEY`

See `docs/mcp-reference.md`.

For the exact copied layout, see
[`docs/copy-paste-codex-setup.md`](copy-paste-codex-setup.md).

For MCP installation details, see
[`docs/mcp-installation.md`](mcp-installation.md).

## After Install

Open Codex and run:

```text
$agi inspect this repo and tell me the highest-leverage first slice. Do not
edit files until you have mapped the live code and validation surface.
```

For long work:

```text
/goal $agi turn this project into a production-ready release. Work by verified
slices, validate with artifacts, and keep a compact checkpoint after each
material slice.
```
