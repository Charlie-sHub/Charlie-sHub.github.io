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

## Architecture And Boundaries

- This is a Flutter Web project using a horizontal `presentation`,
  `application`, `domain`, and `data` structure. Preserve that structure unless
  the user explicitly asks for an architectural change and the specification is
  updated.
- The current state-management pattern is lightweight `flutter_bloc` `Cubit`
  orchestration, with `ContentCubit` loading public content through
  `ContentRepositoryInterface`. Do not introduce BLoC event classes,
  ChangeNotifier/Provider view models, Riverpod, service locators, new
  repository layers, or feature-slice architecture unless the project already
  moves that way or the task explicitly requires it.
- Keep widgets focused on rendering state, local interaction, and dispatching
  callbacks or Cubit calls. Keep content loading, orchestration, validation, and
  business rules out of reusable widgets.
- Keep external data access behind the established domain/data boundary:
  repositories and data sources load assets, DTOs deserialize raw JSON, domain
  values/entities express validation, and presentation handles display and
  fallback states.
- Use `RepositoryProvider`/`BlocProvider` where the app already does. Do not add
  `get_it` or another dependency-injection mechanism unless the user requests it
  and the project direction is updated.
- Keep validation rules in shared validators, value objects, DTO-to-domain
  mapping, and entity construction. Do not scatter validation decisions through
  UI code, Cubits, or repositories.

## Implementation Conventions

- Use Puro for Flutter and Dart commands. Treat `.puro.json` as the Flutter SDK
  environment source of truth.
- Prefer `puro flutter ...` and `puro dart ...`.
- Keep styling values centralized when working in presentation code, especially
  under `lib/presentation/core/theme/` and shared presentation widgets.
- Use descriptive names, centralized constants, and avoid scattered magic
  values.
- Prefer `if (...) { ... } else { ... }` over just `if (...) { ... } ...`.
- Avoid early-return chains when they make flow harder to follow.
- Use `Option` and `Either` where existing domain patterns call for them.
- Add comments only when intent or constraints would otherwise be unclear.

## Flutter UI Work

- Prefer responsive layouts derived from incoming constraints. Use
  `LayoutBuilder` for local adaptive decisions and `MediaQuery.sizeOf` only for
  app- or window-level sizing needs.
- Use `Flexible`, `Expanded`, `ConstrainedBox`, `Align`, and scroll views based
  on clear parent/child constraint reasoning. Do not fix unclear overflow by
  guessing random widths, heights, `Expanded` placements, or scroll wrappers.
- Keep reusable widgets small and purpose-driven. Extract focused widgets when a
  build method becomes deeply nested or mixes unrelated rendering concerns.
- Keep styling values centralized under `lib/presentation/core/theme/` and
  shared presentation widgets. Hardcoded dimensions are acceptable only when
  they are intentional design constants and belong in the theme/layout tokens
  when reused.
- Do not put remote requests, asset/database writes, plugin calls, or
  business-rule decisions directly in reusable presentation widgets.

## DevTools And Runtime Diagnosis

- Coding agents cannot inspect Flutter DevTools directly. Inspect code, tests,
  constraints, and widget composition first.
- For layout overflow, render-size, constraint, rebuild, or widget-tree issues
  that cannot be solved confidently from code and tests alone, tell the
  developer exactly what to inspect in DevTools, such as parent constraints, the
  overflowing render object, Layout Explorer output, widget tree position,
  rebuild behavior, or runtime error details.
- When recommending a layout fix, explain the constraint path that makes the fix
  appropriate.

## Data, Packages, And Platform Integration

- Keep APIs, platform services, external SDKs, browser interop, and Flutter
  plugins isolated behind the project's established data/service/repository or
  presentation utility boundaries. Follow existing conditional-import patterns
  for web-specific behavior.
- Prefer maintained Flutter packages/plugins for platform features when they add
  clear value, but keep dependency additions conservative and consistent with
  `SPECIFICATIONS.md`.
- Check current package documentation before using package-specific APIs when
  docs or tooling are available. If current docs are unavailable, state the
  assumption in the final handoff and isolate the package-specific code behind
  the appropriate boundary.
- Keep structured content JSON-first under `assets/content/`; supporting media
  and documents stay in the asset/document paths described by
  `SPECIFICATIONS.md`.

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
- Keep dependency setup explicit in tests. Use existing `BlocProvider`,
  `RepositoryProvider`, test Cubits, fake repositories, and generated mocks
  before introducing new test infrastructure.
- Add or update unit tests for business, validation, mapping, repository, or
  application logic changes.
- Add or update widget tests for meaningful UI behavior, content-driven
  rendering, fallback states, and interaction changes. Add integration tests
  only when the existing setup supports them or the requested change justifies
  the extra surface.
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
- Dart or Flutter code changes: run `puro dart format <paths>`,
  `puro flutter analyze`, and relevant tests under `test/`.
- Package, lint, or dependency changes: run the relevant Puro-backed pub,
  analyzer, formatter, and test commands needed to prove the changed surface.
- Changes to `freezed`, DTO, or generated-model surfaces: run
  `puro dart run build_runner build --delete-conflicting-outputs`.
- Release-output or deployment changes: run `puro flutter build web` unless the
  user asks for a narrower check.
- Interactive local run when needed: `puro flutter run -d chrome` or another
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
