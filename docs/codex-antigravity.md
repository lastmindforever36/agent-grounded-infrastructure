# Codex + Antigravity / Gemini Collaboration

AGI is Codex-first, but it includes a companion Gemini/Antigravity operating
file because two strong models can be better than one when they coordinate
cleanly.

File:

- `templates/gemini/GEMINI.md`

## Default Role Split

| Worker | Best default lane |
| --- | --- |
| Codex | backend, Android implementation, scraper/DB/infra, security, release gates, deep codebase surgery |
| Antigravity/Gemini | frontend, mobile UI, visual/design iteration, screenshots, browser-heavy evidence, multimodal critique |

This is a routing default, not a hard limitation. Either model may work on any
surface when evidence says it is the right worker.

## When To Ask For A Second Opinion

Use a second model when it can change a high-risk decision:

- UI direction is ambiguous;
- screenshot evidence conflicts with code assumptions;
- security/auth/payment/release risk is high;
- backend and frontend disagree about the contract;
- a design system or visual target needs multimodal judgment;
- a patch is correct-looking but product quality is uncertain.

Do not ask for a second opinion for routine mechanical edits.

## Collaboration Rules

- Split write scopes before delegating.
- Do not let both agents edit the same files at the same time.
- Record important decisions in a shared ledger when the project uses one.
- Treat consults as advice, not authority.
- Compare advice against live code, logs, tests, screenshots, docs, and runtime
  behavior.

## Example Prompt

```text
$agi use Antigravity/Gemini as a bounded second opinion for this UI flow. Codex
keeps backend and Android code ownership. Ask Gemini to inspect screenshots,
visual hierarchy, accessibility, and browser/mobile evidence, then compare its
advice against live code before editing.
```

## Why This Exists

Long-running work fails when one model becomes overconfident in its own local
story. A second model is useful when it adds different perception or reasoning,
but harmful when it causes unsynchronized edits.

AGI's rule is simple:

> consult occasionally, delegate only with bounded write scopes, and trust
> evidence over either model's confidence.

