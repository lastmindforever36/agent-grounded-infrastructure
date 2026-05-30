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

Install AGI templates and MCP binaries together:

```bash
AGI_INSTALL_MCPS=1 ./scripts/install.sh --dry-run
AGI_INSTALL_MCPS=1 ./scripts/install.sh
```

## What It Installs

Node/npm tools:

```bash
npm install -g \
  @colbymchenry/codegraph \
  @playwright/mcp \
  @modelcontextprotocol/server-github \
  @modelcontextprotocol/server-brave-search \
  @_davideast/stitch-mcp
```

Python/uv tools:

```bash
uv tool install mcp-server-git
uv tool install mcp-server-fetch
uv tool install mcp-server-time
uv tool install grep-mcp
uv tool install duckduckgo-mcp-server
uv tool install scrapling
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

## If A Tool Is Missing

AGI should not immediately abandon a first-class tool just because it is absent,
stale, or uninitialized.

Expected behavior:

1. check whether the binary exists;
2. run safe init/status/sync/config if relevant;
3. fall back only after setup fails, credentials are missing, or the tool is not
   relevant;
4. record the fallback reason.

