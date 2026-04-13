# AGENTS.md

## Repo purpose

This repository contains a public portfolio website built with Flutter Web, along with its public-safe content, assets, tests, and repository documentation.

Use this file for repo workflow, validation, edit discipline, and change safety. Use `SPECIFICATIONS.md` for product direction, architecture, scope, invariants, and open decisions.

## Source of truth

Use repository sources in this order:

1. direct user request
2. this `AGENTS.md` for how to work in the repo
3. `SPECIFICATIONS.md` for what is true about the project
4. relevant code, tests, schemas, assets, and content
5. `README.md` for public-facing repository context

If these sources conflict:
- state the contradiction clearly
- do not guess
- ask before making a change that would settle the conflict

If the spec leaves something open, choose the smallest reversible implementation that does not materially decide an open product, UX, UI, schema, or architecture question.

## Important paths

- `SPECIFICATIONS.md`: canonical project direction, constraints, and open decisions
- `README.md`: public introduction and usage context
- `prompts/`: reusable task templates; keep them task-specific and let them defer to `AGENTS.md` for stable repo rules
- `lib/presentation/`, `lib/application/`, `lib/domain/`, `lib/data/`: primary Flutter implementation layers
- `assets/content/`: structured public content
- `assets/media/` and `assets/documents/`: supporting public assets
- `schemas/`: design-time contracts for structured content
- `test/`: automated coverage
- `web/` plus root legacy site files: migration or bootstrapping surfaces; do not treat them as the default target for new Flutter UI work unless the task explicitly calls for them

## Workflow

Before editing:

1. Read the relevant `SPECIFICATIONS.md` sections for the touched area.
2. Check the request, spec, and current implementation for agreement.
3. Identify whether the task is implementing established direction or would settle an open or provisional decision.

Proceed with the smallest coherent change when the direction is already established. Pause and ask when the task would materially change project direction, architecture, schema rules, UX/UI behavior, public positioning, or documentation policy.

## Tooling and validation

This repo uses FVM. Treat `.fvmrc` as the Flutter SDK source of truth.

When running Flutter or Dart commands:
- prefer `fvm flutter ...`
- prefer `fvm dart ...`

Use the lightest validation that proves the change:

- Interactive local run when needed: `fvm flutter run -d chrome` or another available web target
- Docs or prompt-only changes: proofread the edited files and run `git diff --check`
- Dart or Flutter code changes: run `fvm dart format <paths>`, `fvm flutter analyze`, and the relevant tests under `test/`
- Changes to `freezed`, DTO, or generated-model surfaces: run `fvm dart run build_runner build --delete-conflicting-outputs`
- Build verification when the task affects release output or explicitly asks for it: run `fvm flutter build web`

If you cannot run a relevant validation step, say so in the final handoff.

## Conventions and constraints

- Make the smallest change that fully solves the task.
- Do not do unrelated refactors or add speculative features.
- Prefer existing widgets, validators, tokens, patterns, and file structure before introducing new ones.
- Keep styling values centralized when working in presentation code, especially under `lib/presentation/core/theme/` and shared presentation widgets.
- Use descriptive names, keep constants centralized, and avoid scattered magic values.
- Prefer `if (...) { ... } else { ... }` when it improves clarity. 
- Avoid early-return chains.
- Use `Option` and `Either` where the existing domain patterns already call for them.
- Add comments only when the intent or constraint would otherwise be unclear.
- Keep public-facing copy, comments, and docs professional, factual, and restrained. Do not overstate security claims.
- Do not place secrets, tokens, or personal data in code, docs, fixtures, or examples.

For reusable documentation:
- keep durable repo workflow guidance in `AGENTS.md`
- keep product and architecture truth in `SPECIFICATIONS.md`
- keep `README.md` user-facing
- keep `prompts/` focused on task-specific instructions instead of restating repo policy

## UI and architecture safety

For presentation, layout, navigation, interaction, or styling work:
- re-read the relevant UX, UI, styling, and AI-assisted sections in `SPECIFICATIONS.md`
- reuse existing widgets and tokens before creating new reusable patterns
- do not silently turn a provisional or open UI preference into a settled project rule

For architecture, schema, or content-model work:
- keep changes aligned with the layered structure and content flow documented in `SPECIFICATIONS.md`
- do not quietly redefine validation boundaries, schema expectations, or repo structure

## Completion criteria

A task is done when:

- the request, `AGENTS.md`, `SPECIFICATIONS.md`, and changed files agree for the edited scope
- the diff is minimal, readable, and reviewable
- generated files are updated when needed
- relevant validation has been run, or any limitation has been stated clearly
- no durable project decision is left living only in code when the spec should also be updated

## Change safety notes

- This is a public repository. Avoid internal-only planning language in public-facing files.
- Do not move the repo-level `AGENTS.md` into `.codex/`.
- Do not create extra workflow documents such as `PLANS.md` or `code_review.md` unless the user explicitly asks for them.
- Do not remove legacy files, change documentation roles, or alter public positioning without clear instruction.

## Commit messages

When asked to prepare a commit message:
- inspect the staged diff first
- use a short past-tense subject
- keep it specific to the actual change
