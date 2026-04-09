# AGENTS.md

## Purpose

This file tells coding agents how to operate safely in this repository.

It is **not** the main project specification.
Before making changes, read `SPECIFICATIONS.md` and treat it as the primary source for project direction, constraints, architecture, and open decisions.

This file should stay focused on:
- agent behavior
- edit discipline
- ambiguity handling
- workflow rules

---

## Primary references

Check these sources in this order:

1. direct user request
2. `SPECIFICATIONS.md`
3. existing repo code and structure
4. `README.md`

Do not duplicate stable project direction here if it already belongs in `SPECIFICATIONS.md`.

---

## Before making changes

1. Read `SPECIFICATIONS.md` first.
2. Extract only the parts relevant to the task.
3. Check whether the request, current code, and repository docs agree.

If you find a contradiction:
- state it explicitly
- do not guess
- ask for clarification before making the change

Examples of contradiction:
- the request conflicts with `SPECIFICATIONS.md`
- the codebase has drifted from documented direction
- the task would force a decision that the spec still marks as open

If the spec leaves something intentionally open, choose the smallest reasonable and reversible implementation consistent with the current direction only when doing so does not materially decide an open UX, UI, schema, or architecture question.

---

## Tooling commands

This repository uses FVM for Flutter SDK version management.

When running Flutter or Dart commands for this repository:
- prefer `fvm flutter ...` over `flutter ...`
- prefer `fvm dart ...` over `dart ...`
- treat `.fvmrc` as the source of truth for the expected SDK version

Do not assume the globally active `flutter` or `dart` binary matches the version required by this repository.

---

## Before changing UI code

For tasks affecting presentation, layout, navigation, interaction, or styling:

1. Re-read the relevant UX, UI, styling, and AI-assisted sections in `SPECIFICATIONS.md`.
2. Identify whether the task is implementing an established rule, a provisional preference, or an open decision as defined in `SPECIFICATIONS.md`.
3. Reuse existing widgets, tokens, and patterns before creating new ones.
4. Keep style values centralized where practical rather than solving local issues with scattered literals.
5. Do not treat provisional preferences or open decisions as settled through implementation.
6. Treat any new reusable pattern, interaction model, or visual treatment as a clarification point and ask first.
7. Legacy static-site files may remain at the repo root for migration or reference, but new website UI work should treat Flutter files under `lib/presentation/` and `web/` as the primary implementation path unless the task explicitly targets legacy artifacts.

---

## Editing rules

- Make the smallest change that fully solves the task.
- Do not perform unrelated refactors.
- Do not add speculative features.
- Do not introduce abstraction unless the current task clearly needs it.
- Do not silently change project direction through implementation.
- Prefer extending existing patterns already present in the repo over importing a new pattern casually.

If a requested change would materially alter project direction, architecture, scope, or documentation policy, surface that first instead of quietly implementing it.

---

## Coding standards

- Use descriptive identifiers. Prefer clear names such as `messageController` over shortened names such as `msgCtrl`.
- Prefer self-explanatory code. Add comments only when the intent, constraint, or non-obvious logic would not be clear from the code itself.
- Prefer `if (...) { ... } else { ... }` when it improves clarity. Avoid early-return chains when they make the control flow harder to follow.
- Use `Option` and `Either` for optional or failure paths where the repository’s existing patterns call for them.
- Centralize configuration values, constants, enums, and shared tokens. Avoid scattered magic numbers and hardcoded values.
- Do not place secrets, tokens, or personal data in code, logs, examples, fixtures, or documentation.
- Use trailing commas consistently where valid and formatter-friendly. Omit them only when the language syntax or tooling would reject them.

---

## Implementation vs proposal rule

Before changing code, determine whether the task is:
- implementing existing documented direction
- proposing a new direction not yet documented

Use the decision status model in `SPECIFICATIONS.md` when making that distinction.

If the task is implementing existing direction, proceed with the smallest clear change consistent with the spec and current code patterns.

If the task is proposing a new direction, or would materially settle an open or provisional point, surface that explicitly and ask before locking it in through code.

Do not hide new project direction inside generated implementation.

---

## Public-facing content rules

This repository is public.
Treat repository-visible code comments, docs, content structure, and copy as public-facing material.

Keep public-facing writing:
- clear
- grounded
- professional
- practical

Avoid:
- internal-only planning language
- manipulative audience-optimization language
- inflated claims
- sensitive details better kept outside the repo

Do not drift into a stronger security identity than the documented evidence supports.

### Portfolio framing guardrail

For generated public-facing UI copy such as labels, summaries, and section descriptions:
- keep development as the base
- frame security as a real direction of growth, not a completed transformation
- avoid inflated cybersecurity claims
- prefer evidence-backed, restrained wording over branding-heavy language

---

## Documentation discipline

Keep the documents aligned, but do not duplicate them unnecessarily.

Use them like this:
- `SPECIFICATIONS.md`: project direction, constraints, architecture, open decisions
- `README.md`: public repo introduction and usage context
- `AGENTS.md`: agent operating instructions

Update:
- `SPECIFICATIONS.md` when durable project direction changes
- `AGENTS.md` when agent workflow guidance changes
- `README.md` when public-facing repo explanation or setup guidance changes

If the information already belongs in `SPECIFICATIONS.md`, prefer updating that file rather than repeating it here.

---

## Ambiguity handling

Ask for clarification before changing code when:
- the task conflicts with `SPECIFICATIONS.md`
- multiple valid interpretations would lead to meaningfully different implementations
- the task would lock in an open product, UX, UI, schema, or architecture decision
- the safe public/private boundary is unclear

If clarification is not strictly required, proceed with the least risky interpretation and keep the implementation easy to revise.

---

## UI ambiguity rules

For UI-related tasks, follow the decision status model in `SPECIFICATIONS.md` and ask for clarification before implementing if any of these are materially unclear:
- page structure
- section order
- navigation pattern
- disclosure pattern
- whether a new component family is needed
- visual hierarchy
- motion or animation behavior
- mobile-versus-desktop layout differences
- whether a styling choice is local or project-wide

Vague aesthetic language alone is not sufficient design direction.

---

## Quality bar for changes

Every change should aim to be:
- scoped
- understandable
- maintainable
- consistent with the repo’s documented direction
- easy for a human maintainer to review

AI assistance is allowed, but do not treat generated output as correct by default.
Committed changes should be understandable and reviewable by a human.

---

## Generated UI code quality rules

Generated UI code should:
- stay readable and reviewable
- prefer small purpose-driven widgets over large monolithic build methods
- avoid speculative abstraction
- avoid duplicated styling logic where practical
- preserve explicit content-to-UI flow
- remain easy to test where behavior matters

Generated UI should not:
- add dependencies for superficial convenience
- hardcode broad project-wide decisions into one page implementation
- couple raw asset data directly to rendering in ways that bypass the intended validation flow

---

## Closing open decisions

If an approved change resolves an open or provisional direction in `SPECIFICATIONS.md`, update the specification in the same change when appropriate.

Do not leave a durable project decision living only in generated implementation.

---

## Commit messages

When asked to prepare a commit message:
- inspect the staged diff first
- write a short subject in past tense
- keep it specific enough to describe the actual change
- avoid vague or overly broad subjects

Examples:
- `Updated AGENTS guidance`
- `Added content validation`
- `Renamed theme tokens`
- `Removed legacy assets`
