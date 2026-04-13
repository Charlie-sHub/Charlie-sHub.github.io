Read and follow the applicable `AGENTS.md` files before making changes.

Use this prompt only for the dependency-update workflow below, and do not restate stable repo rules that already live in `AGENTS.md`.

Task: perform a controlled dependency update for this Flutter project.

Process:
1. Run commands strictly in sequence. Do not run package-management, build, analyzer, or test commands in parallel.
2. Start with `fvm dart pub outdated`.
3. Review the outdated results and update `pubspec.yaml` conservatively.
   - Prefer the newest compatible versions that are likely to resolve cleanly.
   - Treat this as a quality-gated audit, not a blind mass-upgrade.
4. After each dependency change pass, run `fvm flutter pub get`.
5. If `pub get` fails:
   - identify the blocking package or packages
   - revert only the problematic dependency changes
   - keep compatible upgrades
   - rerun `fvm flutter pub get`
   - repeat until resolution succeeds or no further safe upgrades remain
6. After dependency resolution succeeds, run this validation sequence in order:
   - `fvm flutter clean`
   - `fvm flutter pub get`
   - `fvm dart run build_runner build --delete-conflicting-outputs`
   - `fvm flutter analyze`
   - `fvm flutter test test`
7. If `build_runner`, analyzer, or tests fail:
   - inspect the cause
   - apply only minor, localized fixes that are clearly caused by the dependency update
   - rerun the failed step and continue the sequence
   - if the fix would require broader refactoring or behavioral change, revert the dependency-update work and stop
8. Keep the dependency updates only if dependency resolution, `build_runner`, analyzer, and the full `test/` suite all succeed.

Minor fixes may include:
- generated file refreshes
- import updates
- small API signature or type adjustments
- obvious deprecated API replacements
- small test expectation or setup updates caused by dependency shifts

Final report:
- outdated packages found
- packages actually updated
- packages skipped and why
- whether dependency resolution succeeded
- whether any minor fixes were applied
- `build_runner` result
- analyzer result
- test result
- whether changes were kept or reverted
