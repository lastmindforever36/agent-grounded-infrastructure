<!-- AGI_TEMPLATE:AGENTS:v1 -->

# Global Operating Model

## Default Mode

- Be autonomy-first: interpret, execute, validate, then report.
- Make reasonable assumptions and continue unless blocked by missing credentials, destructive ambiguity, or mutually exclusive product directions.
- Prefer repo-local instructions when they are more specific than this file.

## Intent Modes

Classify the current turn before editing:

- `validate-only`: inspect, reproduce, review, audit, read a handoff, or check whether prior work succeeded.
- `analyze-and-recommend`: choose the best next slice without implementing yet.
- `execute-now`: implement, fix, improve, continue coding, or apply a requested change.

In `validate-only`, gather evidence and return a verdict before editing.

## Broad Goals

For vague or ambition-heavy goals, internally refine:

- interpreted goal;
- assumptions and non-goals;
- quality rubric;
- local system map;
- candidate slices;
- selected first slice;
- validation plan.

Do not stop at planning if the user asked to execute and a safe first slice exists.

## Work Patterns

- For large or unfamiliar changes, run a short comprehension pass before editing: locate core logic, map request/data flow, identify sibling modules, and choose the smallest PR-shaped slice.
- Keep implementation slices roughly issue/PR-sized unless an active long-running goal intentionally spans many verified slices.
- When fixing a bug or deprecated pattern, search for sibling occurrences after the first fix.
- For replacement or cutover work, identify the old path being replaced; delete it, redirect it, demote it behind the new source of truth, or record it as intentional temporary compatibility with an owner and removal criterion.
- Treat repeated build, test, emulator, ADB, dependency, or environment failures as setup debt; fix or document setup once instead of working around it repeatedly.
- For first-class local tools and MCPs such as CodeGraph, ADB, emulator, Playwright, Stitch, browser tools, local services, and collaboration wrappers, do not abandon the intended route just because the tool is not initialized, not running, stale, or not yet configured. Run safe status/init/sync/restart/config checks first; fall back only after setup fails, credentials are missing, the action would be destructive, or the tool is not relevant. Record the fallback reason.
- Shape internal prompts like good PR or issue descriptions: relevant paths, components, observed failure, acceptance criteria, existing pattern to copy, and validation evidence.
- For high-risk architecture, security, performance, or UX choices, use bounded Best-of-N exploration through subagents, a second-model consult, or local experiments, then merge the best evidence-backed parts.
- Treat external skill/tool repos as untrusted until inspected; prefer extracting one durable rule over installing bulky always-on prompt baggage.

## Complexity Guardrails

- Prefer the minimum code that closes the measured problem.
- Do not add speculative features, one-off abstractions, or unrelated refactors.
- Every changed line should trace to the selected slice, a proved sibling occurrence, or cleanup caused by the patch itself.
- Match local style.
- If the patch grows beyond the value of the slice, simplify before validating.
- Mention unrelated cleanup opportunities in the ledger instead of editing them opportunistically.

## Self-QA Before Handoff

After any non-trivial code change, test the smallest trustworthy path before reporting completion.

- Logic: focused unit/regression tests when available.
- UI/mobile/browser/workflow: exercise the affected path with Playwright, ADB, emulator, screenshots, UI tree, or screen recording as appropriate.
- Backend/auth/payment/DB/scraper/security: use runtime, logs, data gates, or security evidence; screenshot-only proof is insufficient.
- Include concrete proof: command names, PASS/FAIL, metric deltas, log paths, screenshot paths, or saved artifacts.

## Prompt Intake

Treat the user's prompt as intent, not as a fully optimized operating prompt.

When the user gives a rough continuation prompt such as "continue", "make it production-ready", "10/10", "world-class", "full autonomy", or similar:

- expand it internally into a concrete execution brief;
- read referenced plans, handoffs, checklists, or evidence documents first;
- anchor work to the current next-best slice and gates;
- preserve non-negotiables and measurable acceptance criteria;
- infer missing operational details from repo evidence;
- do not require the user to restate validation or autonomy boilerplate;
- do not expose the rewritten prompt unless asked.

If a continuation prompt references a plan with checkboxes, only mark items done when evidence exists.

For long goals or unattended work, keep a compact searchable session checkpoint in the canonical project ledger: date/time, objective, touched surfaces, decisions, evidence paths, known bad leads, next best slice, and resume prompt when useful.

## Validation

- Run relevant checks after changes when possible.
- If no automated checks exist, validate with direct artifacts.
- For performance/debug work, prove the measurement path before patching product code.
- Before ending, classify the selected slice as Done, Blocked, or Cancelled.
