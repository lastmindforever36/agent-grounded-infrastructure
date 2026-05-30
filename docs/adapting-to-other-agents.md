# Adapting AGI To Other AI Agents

AGI is written for Codex, but the operating model is portable.

The portable parts are:

- one router command or mode;
- an `AGENTS.md`-style global operating model;
- bounded subagent roles;
- MCP/tool routing;
- hooks or lifecycle reminders when supported;
- validation and secret scanning;
- durable checkpoints for long work.

## Minimal Port

For another agent, copy these ideas:

1. Use `templates/AGENTS.md` as the global rules file.
2. Convert `skills/agi/SKILL.md` into that agent's skill/mode/command format.
3. Convert `templates/codex/agents/*.toml` into that agent's subagent format.
4. Keep `docs/mcp-reference.md` and `docs/mcp-installation.md` as the tool
   inventory.
5. Keep `scripts/sanitize-check.sh` and `scripts/validate.sh`.
6. Keep a project-local checkpoint or ledger.

## What To Rename

You can rename `$agi` to whatever your agent supports:

- `/agi`
- `ultrawork`
- `deep-work`
- `continue-goal`
- `production-mode`

The name is less important than the contract:

```text
Interpret the goal, inspect live state, choose the highest-impact slice,
falsify the strategy, implement only when justified, validate with concrete
evidence, update the checkpoint, and continue until the actual objective is
done.
```

## What Not To Copy Blindly

- Do not copy private Codex sessions.
- Do not copy private MCP credentials.
- Do not force every model to use Codex-specific config syntax.
- Do not keep subagent roles that your target agent cannot actually run.
- Do not turn the whole system into a giant always-on prompt if the target agent
  has better native primitives.

## Test The Port

Ask the target agent:

```text
Here is AGI - Agent Grounded Infrastructure:
https://github.com/don0736/agent-grounded-infrastructure

Port the operating model to your own agent runtime. Preserve the outcome:
one-command routing, evidence-first execution, bounded delegation, MCP/tool
setup debt handling, checkpoints, and secret safety. Do not copy Codex-only
syntax unless your runtime supports it.
```

