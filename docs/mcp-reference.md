# MCP Reference

This harness treats MCP servers as optional first-class tools. Configure only
what you need.

To install the recommended no-secret binaries, use
[`scripts/install-mcps.sh`](../scripts/install-mcps.sh) or read
[`docs/mcp-installation.md`](mcp-installation.md).

## Recommended MCPs

| MCP | Purpose | Secret Required |
| --- | --- | --- |
| `codegraph` | Code graph, symbol search, callers/callees, impact tracing | No |
| `git` | Git status, diffs, logs, branches | No |
| `github` | GitHub search and repository operations | Yes: `GITHUB_PERSONAL_ACCESS_TOKEN` |
| `fetch` | Fetch URL content | No |
| `openaiDeveloperDocs` | OpenAI official docs | No |
| `brave-search` | Web search | Yes: `BRAVE_API_KEY` |
| `duckduckgo` | Web search fallback | No |
| `playwright` | Browser automation and UI evidence | No |
| `stitch` | Google Stitch design generation | Yes: `STITCH_API_KEY` |
| `scrapling` | Scraping research and page extraction | No/depends on use |
| `time` | Time/date helper | No |
| `grep` | Structured grep MCP | No |

## Install Commands

Preview first:

```bash
./scripts/install-mcps.sh --dry-run
```

Install:

```bash
./scripts/install-mcps.sh
```

Or with the main AGI install:

```bash
AGI_INSTALL_MCPS=1 ./scripts/install.sh
```

## Public Config Rule

Never commit your real config with secrets.

Use `templates/codex/config.example.toml` as a shape reference and keep real
tokens only in your private `~/.codex/config.toml`.

## Capability Rules

- If a first-class tool is installed but not initialized, initialize it safely
  before falling back.
- If a tool is missing credentials, report that and continue with the best
  non-secret fallback.
- Do not let MCP approval prompts block routine local work, but do not blindly
  enable auto approval for network, browser, repository, or scraping tools on a
  shared or unfamiliar machine. Configure approval modes according to your
  security posture.
- MCP output is evidence, not authority. Verify important claims against live
  code, tests, logs, or runtime behavior.

## Example Secret Section

Do this only in your private config:

```toml
[mcp_servers.github.env]
GITHUB_PERSONAL_ACCESS_TOKEN = "REPLACE_WITH_LOCAL_SECRET"

[mcp_servers.brave-search.env]
BRAVE_API_KEY = "REPLACE_WITH_LOCAL_SECRET"

[mcp_servers.stitch.env]
STITCH_API_KEY = "REPLACE_WITH_LOCAL_SECRET"
```
