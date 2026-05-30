# Architecture

AGI is a layered harness.

For a component-by-component explanation, see [`components.md`](components.md).

## 1. Global Operating Model

`templates/AGENTS.md` contains the durable rules every session should inherit:

- intent classification;
- broad-goal refinement;
- tool setup debt handling;
- CodeGraph-first mapping when available;
- cutover/anti-accretion;
- concrete validation;
- checkpoint discipline.

This file should stay small enough to be read often.

## 2. AGI Skill

`skills/agi/SKILL.md` is the user-facing router.

The user says `$agi continue` or `$agi <goal>`. AGI then:

- infers the current surface from the repo state;
- chooses the minimum relevant capability set;
- routes to Android, browser, security, design, docs, CodeGraph, batch runners,
  or subagents only when useful;
- validates the selected slice before reporting.

## 3. Agent Roles

`templates/codex/agents/` defines bounded subagents:

- `default` - root orchestrator.
- `explorer` - read-only execution-path mapper.
- `worker` - bounded implementation.
- `reviewer` - correctness/regression/security review.
- `oracle_critical` - high-risk xhigh review.
- `rubric_evaluator` - acceptance and evidence sufficiency.
- `docs_researcher` - official docs and version-sensitive facts.
- `design_pixel_perfect` - visual target, UI patch, screenshot validation.
- `benchmark_researcher` - converts vague benchmark goals into rubrics.

AGI avoids broad fan-out. A subagent must have a mission, scope, evidence
target, and stop condition.

## 4. MCP Layer

MCPs are optional accelerators, not hard requirements.

Recommended MCPs:

- CodeGraph for architecture mapping and impact analysis.
- Git for local repo status and diffs.
- GitHub for source search and repository operations.
- Fetch and official docs endpoints for source-backed facts.
- Playwright/browser tools for UI evidence.
- Stitch for high-end design direction.
- Android testing plugins for emulator, ADB, logcat, and performance evidence.

See `docs/mcp-reference.md`.

Use `scripts/install-mcps.sh` to install the recommended no-secret MCP binaries.

## 5. Hooks

Optional hooks add lightweight reminders at session start, prompt submit, and
stop. They should never replace the actual skill logic and should stay short.

## 6. Collaboration

`templates/gemini/GEMINI.md` mirrors the core rules for Google Antigravity or
Gemini-style agents. Use it when two agents coordinate on one project:

- split write scopes;
- consult occasionally on high-risk decisions;
- record decisions in a shared ledger;
- compare advice against live evidence before acting.

See [`codex-antigravity.md`](codex-antigravity.md).
