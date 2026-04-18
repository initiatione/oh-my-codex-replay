---
title: "Karpathy guidelines as default coding discipline"
tags: ["omx", "skills", "coding-style", "prompting", "decision", "refactor"]
created: 2026-04-18T18:52:20.717Z
updated: 2026-04-18T19:03:05.363Z
sources: ["multica-ai/andrej-karpathy-skills", "local integration on 2026-04-19", "local integration refinements on 2026-04-19"]
links: []
category: decision
confidence: high
schemaVersion: 1
---

# Karpathy guidelines as default coding discipline

Decision: install the `karpathy-guidelines` skill and also merge its core principles into the default Codex/OMX prompt layer so future coding work follows the style even without explicit skill invocation.

Why this decision:
- Installing the skill alone is not sufficient for default behavior because skills are primarily explicit or routed capabilities.
- The strongest parts of the skill align with OMX goals: avoid silent assumptions, prefer the simplest sufficient implementation, keep edits surgical, and define verification goals before editing.
- Merging the condensed principles into the global instruction prompt and executor prompt makes the behavior default while still preserving the skill for explicit stricter use.

What was integrated:
- `~/.codex/prompts/instruction.md` now includes a default coding-discipline section with Karpathy-inspired rules.
- `~/.codex/prompts/executor.md` now reinforces assumption surfacing, simplicity, surgical changes, and verification-first execution.
- `~/.codex/skills/karpathy-guidelines` is installed as a reusable skill.

Operational guidance:
- Treat the installed skill as the explicit high-discipline variant.
- Treat the merged prompt rules as the default baseline for future development work.
- If future OMX prompt changes create conflicts, preserve the concise merged principles rather than duplicating the full skill text.

---

## Update (2026-04-18T18:56:41.428Z)

Refinement: the Karpathy-style defaults remain the baseline for normal coding, debugging, and review work, but refactor/cleanup/deslop/architecture tasks are an explicit exception path.

Updated rule:
- For ordinary tasks, prefer explicit assumptions, simplest sufficient implementation, surgical changes, and verification-first execution.
- For refactor-class tasks, optimize for the simplest resulting architecture rather than the smallest diff.
- Permit bounded structural changes across multiple files and necessary abstractions when they are required to complete the refactor coherently.
- Keep the same discipline around explicit assumptions, plans, and verification, and prefer locking behavior with tests or concrete before/after checks when practical before broad structural edits.

Why this refinement was added:
- A strict smallest-diff / surgical-only interpretation can be too conservative for real refactor work.
- OMX should default to disciplined coding without crippling cleanup or architecture improvements when the task genuinely requires restructuring.

Prompt changes:
- `~/.codex/prompts/instruction.md` now distinguishes ordinary development from refactor/cleanup work.
- `~/.codex/prompts/executor.md` now explicitly allows bounded structural refactor changes and verification-before-restructure behavior.

---

## Update (2026-04-18T18:58:37.857Z)

Further refinement: ordinary development tasks also require the best result, not merely the smallest diff.

Updated interpretation:
- For ordinary tasks, optimize for the best verified outcome within the approved scope.
- Treat smallest-diff and surgical-edit guidance as heuristics for reducing risk, scope creep, and collateral damage, not as the end goal.
- Simplicity still means choosing the simplest high-confidence solution that achieves the desired result well.
- Refactor/cleanup exceptions remain in place: bounded structural changes and necessary abstractions are allowed when required for the simplest resulting architecture.

Prompt changes:
- `~/.codex/prompts/instruction.md` now explicitly states `best result within scope` and reframes smallest diff as a control heuristic.
- `~/.codex/prompts/executor.md` now says the executor should optimize for the best result within scope and implement the simplest change that delivers the best verified result within scope.

---

## Update (2026-04-18T19:00:41.601Z)

Additional sync: the `best result within scope` interpretation is now reflected across more OMX role prompts.

Extended prompt alignment:
- `~/.codex/prompts/planner.md` now plans for the best executable result within scope and explicitly treats smallest-diff thinking as an implementation heuristic rather than a planning goal.
- `~/.codex/prompts/test-engineer.md` now optimizes for the strongest confidence gain within scope rather than under-testing to keep changes small.
- `~/.codex/prompts/code-simplifier.md` now optimizes for the clearest and most maintainable resulting code within scope, treating smaller diffs and fewer lines as heuristics rather than the objective.

Result:
- The ordinary-task rule is now consistent across planning, testing, simplification, and execution roles: pursue the best verified result within scope while using simplicity and limited diff size to control risk rather than to define success.

---

## Update (2026-04-18T19:03:05.363Z)

Additional light-touch sync: the best-result-within-scope rule is now reflected in debugger and architect prompts with intentionally low weight to avoid role drift.

Debugger refinement:
- Still prioritizes reproduction, evidence, and one hypothesis at a time.
- Now clarifies that minimal-fix thinking is a guard against symptom patching, not a reason to avoid the stronger root-cause fix within scope.

Architect refinement:
- Still remains read-only and evidence-first.
- Now clarifies that the goal of the analysis is the best grounded recommendation within scope, while smaller change sets remain implementation heuristics rather than the analytical objective.

Design intent:
- Preserve role identity first.
- Add only a small bias toward outcome quality so the broader OMX philosophy stays coherent without overpowering each role's original mission.
