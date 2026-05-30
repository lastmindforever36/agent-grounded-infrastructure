# MCP Installation

AGI ships a public-safe MCP config template and an optional MCP binary installer.

The installer only installs tools. It does **not** install secrets.

## Install Recommended MCP Binaries

Preview:

```bash
./scripts/install-mcps.sh --dry-run
```

Install:

```bash
./scripts/install-mcps.sh
```

The installer pins package versions by default so the same public command does
not silently change behavior when upstream packages release a new version.

Use latest upstream only when you intentionally want it:

```bash
./scripts/install-mcps.sh --floating
```

Install AGI templates and MCP binaries together:

```bash
AGI_INSTALL_MCPS=1 ./scripts/install.sh --dry-run
AGI_INSTALL_MCPS=1 ./scripts/install.sh
```

## What It Installs

Node/npm tools:

```bash
npm install -g \
  @colbymchenry/codegraph@0.9.4 \
  @playwright/mcp@0.0.74 \
  @modelcontextprotocol/server-github@2025.4.8 \
  @modelcontextprotocol/server-brave-search@0.6.2 \
  @_davideast/stitch-mcp@0.5.5
```

Python/uv tools:

```bash
uv tool install mcp-server-git==2026.1.14
uv tool install mcp-server-fetch==2025.4.7
uv tool install mcp-server-time==2026.1.26
uv tool install grep-mcp==1.0.3
uv tool install duckduckgo-mcp-server==0.3.0
uv tool install scrapling==0.4.7
```

## CodeGraph

CodeGraph is the most important local codebase MCP in this harness.

Why AGI cares about it:

- it builds a local semantic graph instead of repeatedly grepping everything;
- it can answer symbol context, callers, callees, impact, and affected tests;
- it is useful before broad refactors, root-cause tracing, and architecture
  mapping;
- if a repo is not initialized, AGI should run `codegraph init`, `codegraph
  index`, and `codegraph status` before falling back.

Basic usage inside a repo:

```bash
codegraph init .
codegraph index .
codegraph status .
codegraph context "trace how playback request reaches the player"
```

Optional Codex registration:

```bash
AGI_CONFIGURE_CODEGRAPH=1 ./scripts/install-mcps.sh
```

The public AGI config already includes a CodeGraph MCP block:

```toml
[mcp_servers.codegraph]
command = "codegraph"
args = ["serve", "--mcp"]
default_tools_approval_mode = "auto"
```

## Secret-Requiring MCPs

These need private local credentials:

| MCP | Credential |
| --- | --- |
| GitHub | `GITHUB_PERSONAL_ACCESS_TOKEN` |
| Brave Search | `BRAVE_API_KEY` |
| Stitch | `STITCH_API_KEY` |

Add them only to your private `~/.codex/config.toml`.

Do not commit the private config.

## Approval Posture

`templates/codex/config.example.toml` shows autonomous MCP routing because AGI is
built for long-running local work. For a shared machine, unknown repository, or
sensitive environment, review Codex's current MCP approval-mode docs and tighten
the approval posture before enabling browser, search, GitHub, or scraping MCPs.

## If A Tool Is Missing

AGI should not immediately abandon a first-class tool just because it is absent,
stale, or uninitialized.

Expected behavior:

1. check whether the binary exists;
2. run safe init/status/sync/config if relevant;
3. fall back only after setup fails, credentials are missing, or the tool is not
   relevant;
4. record the fallback reason.
