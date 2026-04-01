Task: perform a controlled dependency update for this Flutter project.

Process and sequencing:
- Run commands strictly in sequence.
- Do not run multiple package-management, build, analyzer, or test commands in parallel.
- Wait for each command to finish and inspect the result before deciding the next step.

Rules:
1. Start by running:
   - `fvm dart pub outdated`

2. Review the outdated results and update `pubspec.yaml` conservatively and intentionally.
   - Prefer the newest compatible versions that are likely to work without breaking dependency resolution.
   - Do not perform a blind mass-upgrade.
   - Do not make unrelated code changes.

3. After each dependency update pass, run:
   - `fvm flutter pub get`

4. If `pub get` reports dependency resolution or versioning errors:
   - identify the package or packages causing the conflict
   - do not force broken versions
   - revert only the problematic dependency change(s)
   - keep compatible dependency upgrades
   - run `fvm flutter pub get` again
   - repeat this loop until either:
     - dependency resolution succeeds, or
     - no further safe upgrades can be made without breaking resolution

5. Only after dependency resolution succeeds, run this validation sequence in order:
   - `fvm flutter clean`
   - `fvm flutter pub get`
   - `fvm dart run build_runner build --delete-conflicting-outputs`
   - `fvm flutter analyze`
   - `fvm flutter test test`

6. If `build_runner` fails:
   - inspect the cause
   - if the required fix is minor and clearly caused by the dependency update, implement it
   - examples of minor fixes:
     - generated file refreshes
     - import updates
     - small API signature adjustments
     - minor annotation or config fixes
   - after the fix, rerun the failed command and continue the sequence
   - if the fix is not minor, or would require broader refactoring, revert all dependency/version changes made in this task, restore the repo to its original state, and stop

7. If analyzer issues appear:
   - inspect the errors
   - if the required fixes are minor and clearly caused by the dependency update, implement them
   - examples of minor fixes:
     - import cleanup
     - renamed symbols
     - small type adjustments
     - obvious deprecated API replacements
     - formatting or lint-safe code updates required by the new versions
   - do not make unrelated refactors
   - rerun `fvm flutter analyze` after fixes
   - if the issues require medium or large code changes, revert all dependency/version changes made in this task, restore the repo to its original state, and stop

8. If tests fail:
   - inspect the failures
   - if the required fixes are minor and clearly caused by the dependency update, implement them
   - examples of minor fixes:
     - matcher updates
     - mock or generated file refreshes
     - small test expectation changes caused by dependency API shifts
     - minor setup adjustments
   - rerun only the affected tests first if useful, then rerun:
     - `fvm flutter test test`
   - if fixing the tests requires broader behavioral changes, refactors, or non-trivial production-code changes, revert all dependency/version changes made in this task, restore the repo to its original state, and stop

9. Keep the dependency updates only if all of the following are true:
   - dependency resolution succeeds
   - `build_runner` succeeds
   - analyzer succeeds
   - all tests in `test/` succeed

10. At the end, provide a clear rundown with:
   - outdated packages found
   - packages actually updated
   - packages skipped and why
   - whether dependency resolution succeeded
   - whether any minor fixes were applied
   - `build_runner` result
   - analyzer result
   - test result
   - whether changes were kept or reverted

Execution notes:
- Treat this as a quality-gated dependency audit/update, not a blind upgrade.
- Keep compatible upgrades when possible.
- Skip packages that block the upgrade graph rather than breaking the repo.
- Minor fixes are allowed only when they are directly required by the dependency update and are small, localized, and low-risk.
- Do not leave the repository in a broken state.
- If full rollback is required, revert dependency changes and any related minor fixes made during this task.