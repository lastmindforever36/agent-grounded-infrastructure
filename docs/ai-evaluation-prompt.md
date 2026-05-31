# AI Evaluation Prompt

Use this when you want another AI to review AGI before installing it.

```text
You are reviewing an open-source Codex harness:

https://github.com/lastmindforever36/agent-grounded-infrastructure

Task:
Decide whether this is worth installing for serious long-running software work.

Read:
- README.md
- skills/agi/SKILL.md
- templates/AGENTS.md
- templates/codex/config.example.toml
- docs/architecture.md
- docs/usage.md
- docs/mcp-reference.md
- docs/mcp-installation.md
- docs/components.md
- docs/codex-antigravity.md
- scripts/install.sh
- scripts/install-mcps.sh
- scripts/validate.sh
- scripts/sanitize-check.sh

Evaluate it against real agent failure modes:
1. stale or compacted context;
2. editing the wrong layer;
3. weak validation;
4. premature "done";
5. subagent fan-out without purpose;
6. repetitive item-by-item work instead of batch runners;
7. old and new paths competing silently;
8. uninitialized tools being abandoned too early;
9. secret leakage through copied local configs;
10. confusing installation.
11. unclear MCP setup;
12. unclear hook behavior;
13. unclear collaboration with other agents such as Gemini/Antigravity.

Return:
- verdict: install / do not install / install with changes;
- what problem this harness actually solves;
- strongest design choices;
- weakest or riskiest parts;
- whether the install process is safe;
- whether the `$agi` interface is understandable;
- what you would change before recommending it to another developer.

Do not judge it as a full agent product. Judge it as a Codex operating harness:
skills, instructions, subagent roles, MCP routing, hooks, validation, and
secret-safe templates.
```

## Short Version

```text
Review https://github.com/lastmindforever36/agent-grounded-infrastructure and tell me if
it is worth installing for Codex. Judge it by whether it prevents real long-run
agent failures: stale context, weak validation, wrong-layer fixes, subagent
theater, manual queue burn, premature completion, and secret leakage.
```
