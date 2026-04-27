# AGENTS.md

Repo-specific operating guidance for AI coding agents.

Use `SPECIFICATIONS.md` for product direction, architecture, scope, UX/UI
baselines, deployment facts, domain rules, and open decisions. Keep this file
focused on how to work in the repository.

## Source Of Truth

Use repository sources in this order:

1. direct user request
2. this `AGENTS.md` for agent workflow and safety rules
3. `SPECIFICATIONS.md` for project, product, architecture, and documentation truth
4. relevant code, tests, schemas, assets, and content
5. `README.md` for public-facing repository context

If sources conflict, state the contradiction clearly and ask before making a
change that would settle project direction. If the spec leaves something open,
choose the smallest reversible implementation that does not materially decide an
open product, UX, UI, schema, or architecture question.

## Before Editing

- Read the relevant `SPECIFICATIONS.md` sections for the touched area.
- Check the request, spec, and current implementation for agreement.
- Identify whether the task implements established direction or would change a
  baseline, settle an open decision, or alter documentation policy.
- Proceed when direction is established. Ask only when blocked or when the
  change would materially decide project direction.

## Scope Discipline

- Make the smallest coherent change that fully solves the task.
- Do not do unrelated refactors, speculative features, or broad documentation
  restructuring.
- Preserve established architecture, public positioning, documentation roles,
  and deployment expectations unless explicitly asked to change them.
- Prefer existing widgets, validators, tokens, patterns, and file structure
  before introducing new abstractions.
- Do not move the repo-level `AGENTS.md` into `.codex/`.
- Do not create extra workflow documents such as `PLANS.md` or
  `code_review.md` unless the user explicitly asks for them.

## Implementation Conventions

- Use FVM for Flutter and Dart commands. Treat `.fvmrc` as the Flutter SDK
  source of truth.
- Prefer `fvm flutter ...` and `fvm dart ...`.
- Keep styling values centralized when working in presentation code, especially
  under `lib/presentation/core/theme/` and shared presentation widgets.
- Use descriptive names, centralized constants, and avoid scattered magic
  values.
- Prefer `if (...) { ... } else { ... }` over just `if (...) { ... } ...`.
- Avoid early-return chains when they make flow harder to follow.
- Use `Option` and `Either` where existing domain patterns call for them.
- Add comments only when intent or constraints would otherwise be unclear.

## Test conventions

- Do not wrap every test in a file with a single broad parent `group`. Prefer
  purposeful `group` blocks with descriptive labels, such as `success tests`
  for happy paths and `failure tests` for failures, exceptions, invalid input,
  and behavior that is expected to fail. Skip this split only when it would
  make the tests less clear.
- All active tests should pass. Skipped placeholder tests are acceptable only
  while a surface is intentionally scaffolded without real behavior.
- Use `mockito` for generated test mocks. Prefer the
  `@GenerateNiceMocks([...])` approach over hand-written mocks.
- Use `get_it` for dependency injection. Keep dependency setup explicit in
  tests, and reset test registrations after each test that mutates the
  container.
- Keep common test variables, such as mocked dependencies, near the top of the
  file so all tests can use them.
- Keep variables that are common only to one group near the top of that group;
  for example, `validEmail` in a `success tests` group and `invalidEmail` in a
  `failure tests` group.
- Do not repeat identical Arrange setup inside every test when a value is used
  across all tests in the same scope. Declare it once at the narrowest common
  scope, such as the current group, and keep individual Arrange sections for
  test-specific setup only.
- Follow the AAA pattern as closely as practical in each test:
  - put `// Arrange` above setup, variables, fixtures, and mock stubs
  - put `// Act` above the action being tested
  - put `// Assert` above assertions and verifications
- Always leave trailing commas in multi-line invocations and collections.
  Prefer closures that close as `},);` rather than `});`.

## Documentation Boundaries

- Keep durable repo workflow guidance in `AGENTS.md`.
- Keep product behavior, architecture decisions, domain rules, UX/UI decisions,
  deployment facts, and open items in `SPECIFICATIONS.md` or another appropriate
  spec document.
- Keep `README.md` public-facing and lighter than the specification.
- Keep `prompts/` task-specific; let prompts defer to `AGENTS.md` for stable
  repo rules.
- Keep public-facing copy, comments, and docs professional, factual, and
  restrained.

## Security And Public Safety

- This is a public repository. Do not place secrets, tokens, private planning,
  internal-only material, or personal data in code, docs, fixtures, prompts, or
  examples.
- Do not overstate security claims.
- Avoid unsafe content rendering patterns and unnecessary third-party
  dependencies. Follow the security and dependency direction in
  `SPECIFICATIONS.md`.

## Verification

Use the lightest validation that proves the change:

- Docs or prompt-only changes: proofread the edited files and run
  `git diff --check`.
- Dart or Flutter code changes: run `fvm dart format <paths>`,
  `fvm flutter analyze`, and relevant tests under `test/`.
- Changes to `freezed`, DTO, or generated-model surfaces: run
  `fvm dart run build_runner build --delete-conflicting-outputs`.
- Release-output or deployment changes: run `fvm flutter build web` unless the
  user asks for a narrower check.
- Interactive local run when needed: `fvm flutter run -d chrome` or another
  available web target.

If a relevant check cannot be run, state the limitation in the final handoff.

## Done When

- The request, this file, `SPECIFICATIONS.md`, and changed files agree for the
  edited scope.
- The diff is minimal, readable, and reviewable.
- Generated files are updated when needed.
- Relevant validation has been run, or skipped checks are explained.
- No durable project decision is left only in code or agent guidance when it
  belongs in the specification.

## Reviews And Commit Messages

For code reviews, lead with bugs, regressions, risks, and missing tests. Order
findings by severity and cite file and line references. If no issues are found,
say so and note any residual risk or unrun checks.

When asked to prepare a commit message, inspect the staged diff first. Use a
short past-tense subject that matches the actual change.
