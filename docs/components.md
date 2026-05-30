# Components

AGI is small on purpose. Each component exists because it prevents a specific
long-running-agent failure mode.

## `$agi` Skill

File: `skills/agi/SKILL.md`

Why it exists:

- gives the user one entrypoint;
- turns broad prompts into an internal execution brief;
- routes to the right tool or workflow from live repo evidence;
- prevents the user from having to name every skill, MCP, plugin, or subagent.

Failure mode it prevents:

- "I said continue and the agent guessed randomly."
- "The user had to know the exact tool to ask for."

## `AGENTS.md`

File: `templates/AGENTS.md`

Why it exists:

- gives every session the same durable operating model;
- classifies turns as validation, recommendation, or execution;
- requires broad-goal refinement before edits;
- makes validation and checkpoints normal instead of optional.

Failure mode it prevents:

- stale memory overriding live code;
- editing when the user only asked for validation;
- declaring a broad goal done after one narrow pass.

## Subagent Templates

Folder: `templates/codex/agents/`

Why they exist:

- separate exploration from implementation;
- keep read-only mapping cheap;
- reserve high reasoning effort for writing code, critical review, or release
  risk;
- make delegation bounded instead of theatrical.

Included roles:

| Role | Purpose |
| --- | --- |
| `explorer` | Read-only execution-path mapping. |
| `worker` | Bounded implementation with verification. |
| `reviewer` | Correctness, regression, security, and missing-test review. |
| `oracle_critical` | High-risk auth, payment, secrets, concurrency, release, or pre-ship review. |
| `rubric_evaluator` | Checks whether evidence actually proves the slice. |
| `docs_researcher` | Official docs and version-sensitive facts. |
| `benchmark_researcher` | Converts vague "world-class" goals into a usable rubric. |
| `design_pixel_perfect` | UI target, UI-only patch, screenshot validation. |
| `ui_debugger` | Browser/runtime reproduction with console/network/screenshot evidence. |

Failure mode it prevents:

- using expensive reasoning for read-only file listing;
- spawning many agents without a stop condition;
- mixing implementation and review in one unbounded pass.

## MCP Layer

Files:

- `templates/codex/config.example.toml`
- `docs/mcp-reference.md`
- `docs/mcp-installation.md`
- `scripts/install-mcps.sh`

Why it exists:

- gives the agent structured tools for code, docs, browser, GitHub, design, and
  Android evidence;
- makes CodeGraph-first mapping available when a repo is large;
- avoids falling back to manual grep loops too early;
- keeps credentials private by shipping placeholders only.

Failure mode it prevents:

- abandoning a tool because it was not initialized;
- treating search results as proof;
- copying private MCP tokens into a public repo.

## Hooks

Files:

- `templates/codex/hooks/hooks.json`
- `templates/codex/hooks/session_start_autonomy.py`
- `templates/codex/hooks/user_prompt_autonomy.py`
- `templates/codex/hooks/stop_autonomy.py`

Why they exist:

- inject short context at session start and resume;
- classify the prompt lightly before execution;
- discourage plan-only endings for broad `$agi` work;
- keep reminders small so they do not become a second giant prompt stack.

Failure mode it prevents:

- the model starting a resumed session without the operating posture;
- broad prompts ending as "here is the plan";
- validation-only prompts being treated as edit permission.

Hooks are guardrails, not the brain. The skill and project evidence still make
the actual decision.

## Gemini / Antigravity Companion

File: `templates/gemini/GEMINI.md`

Why it exists:

- allows another agent to share the same operating model;
- gives Codex a reasonable second-opinion lane for UI, design, browser, and
  multimodal work;
- defines how to split write scopes and avoid both agents editing the same files.

Failure mode it prevents:

- two models racing each other;
- one model accepting the other's opinion without evidence;
- frontend and backend work drifting apart.

## Validation Scripts

Files:

- `scripts/validate.sh`
- `scripts/sanitize-check.sh`
- `scripts/install.sh --dry-run`
- `scripts/install-mcps.sh --dry-run`

Why they exist:

- prove the repo is syntactically installable;
- prove Markdown links are not broken;
- prove secrets are not accidentally committed;
- show exactly what will be copied before touching the user environment.

Failure mode it prevents:

- "trust me" installs;
- broken README links;
- private state leaking into a public harness.

## Living Checkpoints

AGI does not force one checkpoint filename because every project differs.
Instead, it teaches the agent to find or create a project-local ledger for
non-trivial work.

Why it exists:

- long goals need durable state outside the chat;
- compaction is lossy;
- resumed sessions need objective, evidence, risks, and next slice without
  reading an entire transcript.

Failure mode it prevents:

- repeating old investigations;
- losing accepted decisions;
- marking checklist items without evidence.

