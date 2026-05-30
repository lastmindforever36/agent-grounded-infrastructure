# AGI - Agent Grounded Infrastructure

AGI is a Codex harness for long-running, evidence-grounded engineering work.

It is not a magic prompt and it is not "artificial general intelligence".
AGI means **Agent Grounded Infrastructure**: a small operating system of
instructions, skills, agents, MCP routing, validation habits, and public-safe
templates that make a coding agent behave like a disciplined product engineer.

The core idea:

> Give the model freedom to solve the problem, but ground every move in live
> code, concrete evidence, clear ownership, and durable checkpoints.

## What This Repo Contains

- `skills/agi/SKILL.md` - the main AGI router skill.
- `templates/AGENTS.md` - global operating rules for Codex-style agents.
- `templates/codex/config.example.toml` - sanitized Codex config template.
- `templates/codex/agents/` - bounded subagent role templates.
- `templates/codex/hooks/` - optional lightweight autonomy hooks.
- `templates/gemini/GEMINI.md` - optional Antigravity/Gemini companion rules.
- `docs/mcp-reference.md` - MCP inventory and required credentials.
- `scripts/install.sh` - local installer with backup and dry-run support.
- `scripts/validate.sh` - static validation for templates and scripts.
- `scripts/sanitize-check.sh` - secret leak scanner for this repo.

No private sessions, profiles, tokens, API keys, logs, SQLite state, or local
project data are included.

## Quick Start

```bash
git clone https://github.com/don0736/agent-grounded-infrastructure.git
cd agent-grounded-infrastructure

./scripts/validate.sh
./scripts/install.sh --dry-run
./scripts/install.sh
```

Then open Codex and use:

```text
$agi continue from the current state. Pick the next highest-impact slice,
validate it with concrete evidence, update the checkpoint, and keep the goal
active unless the actual objective is complete.
```

You do not need to name every skill or MCP. AGI is the router. It inspects the
live repo state and chooses the right capability: CodeGraph, ADB, Playwright,
security review, design, docs, browser QA, batch runners, or a bounded
subagent.

## Why AGI Works

Most agent failures are not model-intelligence failures. They are grounding
failures:

- editing before understanding ownership;
- fixing the wrong layer;
- trusting stale docs over live runtime;
- treating one green test as product proof;
- burning expensive reasoning on repetitive queues;
- adding new paths without deleting or demoting old paths;
- spawning subagents for theater instead of evidence.

AGI makes those failure modes explicit and routes around them.

## The Operating Loop

1. Interpret the user's outcome.
2. Inspect the live repo, runtime, logs, docs, and checkpoints.
3. Select one high-leverage slice.
4. Falsify the strategy before editing.
5. Make the smallest structural change that moves the product.
6. Validate with concrete artifacts.
7. Update the ledger/checkpoint.
8. Reassess the next slice.

For long `/goal` work, the goal stays active across turns. One passing gate is
not the whole product.

## Public Safety

This repository ships with placeholders only. You must add your own credentials
locally for optional MCPs such as GitHub, Brave Search, and Stitch. Never commit
your real `~/.codex/config.toml`, `~/.codex/sessions`, `~/.codex-profiles`,
tokens, cookies, or account state.

Run this before publishing:

```bash
./scripts/sanitize-check.sh
```

## License

MIT.
