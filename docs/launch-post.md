# Launch Post Draft

Short X post:

```text
I open-sourced AGI - Agent Grounded Infrastructure.

It is my Codex harness for long-running engineering work.

Install it, type $agi, and let Codex route itself through skills, MCPs,
subagents, CodeGraph, ADB, Playwright, design, security, validation, and
checkpoints.

Not a prompt dump. A grounded operating harness.

GitHub: https://github.com/don0736/agent-grounded-infrastructure
```

Thread outline:

1. **Problem**
   - Coding agents are strong, but they fail when they edit the wrong layer,
     trust stale context, skip cutovers, or call one green test "done".

2. **Solution**
   - AGI turns broad goals into grounded execution: live repo inspection,
     capability routing, bounded subagents, concrete validation, and ledger
     checkpoints.

3. **One command**
   - `$agi continue`
   - `$agi make this production-ready`
   - `$agi audit this app`
   - `$agi improve this UI`

4. **Core idea**
   - Let the model choose the path, but force evidence, source of truth,
     cutover discipline, and real product gates.

5. **What is included**
   - `$agi` skill, AGENTS template, Codex agents, optional hooks, MCP reference,
     Gemini companion rules, installer, validator, secret scanner.

6. **Ask**
   - Send the repo to your own AI and ask whether it is worth installing.
   - Try it, review it, and suggest high-signal improvements.

Longer install-focused post:

```text
AGI now has the full copy-paste path:

git clone https://github.com/don0736/agent-grounded-infrastructure
cd agent-grounded-infrastructure
./scripts/validate.sh
./scripts/install.sh --dry-run
./scripts/install.sh

Optional hooks:
./scripts/install.sh --hooks --dry-run
./scripts/install.sh --hooks

Optional MCP binaries:
./scripts/install-mcps.sh --dry-run
./scripts/install-mcps.sh

Then use:
$agi continue

The point is simple: the user should not need to know which skill, MCP, hook,
subagent, CodeGraph flow, ADB path, browser tool, design lane, or reviewer to
invoke. The harness routes from live evidence.
```
