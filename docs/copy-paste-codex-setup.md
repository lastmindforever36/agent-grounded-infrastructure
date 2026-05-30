# Copy-Paste Codex Setup

This page explains exactly what AGI copies and what the user must keep private.

## Install

```bash
git clone https://github.com/don0736/agent-grounded-infrastructure.git
cd agent-grounded-infrastructure
./scripts/validate.sh
./scripts/install.sh --dry-run
./scripts/install.sh
```

Optional MCP binaries:

```bash
./scripts/install-mcps.sh --dry-run
./scripts/install-mcps.sh
```

## Installed Layout

```text
~/.codex/
  skills/
    agi/
      SKILL.md
  agents/
    default.toml
    explorer.toml
    worker.toml
    reviewer.toml
    oracle_critical.toml
    rubric_evaluator.toml
    docs_researcher.toml
    benchmark_researcher.toml
    design_pixel_perfect.toml
    ui_debugger.toml
  hooks/
    session_start_autonomy.py
    user_prompt_autonomy.py
    stop_autonomy.py
  hooks.json
  config.example.toml

~/AGENTS.md
~/.gemini/GEMINI.md   # optional
```

If `AGI_INSTALL_MCPS=1` is used, the installer also runs
`scripts/install-mcps.sh`.

## What To Copy Into Your Private Config

Use `templates/codex/config.example.toml` as a shape reference. Copy only the
parts you want into your private `~/.codex/config.toml`.

Example:

```toml
model = "gpt-5.5"
model_reasoning_effort = "xhigh"

[features]
hooks = true
goals = true
memories = true

[mcp_servers.codegraph]
command = "codegraph"
args = ["serve", "--mcp"]
default_tools_approval_mode = "auto"
```

For MCPs that need credentials, add your own values locally:

```toml
[mcp_servers.github.env]
GITHUB_PERSONAL_ACCESS_TOKEN = "REPLACE_WITH_LOCAL_SECRET"

[mcp_servers.brave-search.env]
BRAVE_API_KEY = "REPLACE_WITH_LOCAL_SECRET"

[mcp_servers.stitch.env]
STITCH_API_KEY = "REPLACE_WITH_LOCAL_SECRET"
```

Never commit your private config after adding real values.

## What Not To Copy

Do not copy these into a public repo:

- `~/.codex/config.toml` after adding secrets;
- `~/.codex/sessions`;
- `~/.codex-profiles`;
- browser cookies;
- tokens;
- account state;
- local project logs;
- local databases.

## First Prompt After Install

```text
$agi inspect this repo and tell me the highest-leverage first slice. Read the
live code, project instructions, current tests, and any checkpoint/ledger first.
Do not edit until you know the validation surface.
```

## Long Goal Prompt

```text
/goal $agi make this project production-ready. Work by verified slices. For
each slice, inspect live state, choose the highest-leverage next action, try to
falsify the strategy before editing, validate with concrete artifacts, update
the checkpoint, and keep the goal active until the actual objective is done.
```
