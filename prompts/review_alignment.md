Read and follow the applicable `AGENTS.md` files before making changes.

Use `SPECIFICATIONS.md` as the canonical source for product, architecture, scope, invariants, and open decisions. Use this prompt only for the alignment-review task below, and do not restate stable repo rules that already live in `AGENTS.md`.

Scope:
- Check alignment between:
  - the direct request in this prompt
  - `SPECIFICATIONS.md`
  - `AGENTS.md`
  - `README.md`
  - relevant source code
  - relevant content, assets, and schemas when they affect the reviewed area

What to review:
1. Code vs `SPECIFICATIONS.md`
2. Code vs `README.md`
3. `README.md` vs `SPECIFICATIONS.md`
4. `AGENTS.md` vs `SPECIFICATIONS.md`
5. Content, schema, and asset structure vs documented direction
6. Public-facing wording vs repo positioning and tone, where relevant

Decision rule:
- Fix only small, low-risk alignment issues directly.
- Summarize medium or large issues and ask for approval before changing them.

Classify issues like this:
- Small:
  - wording drift
  - minor naming inconsistencies
  - outdated doc details
  - small structural mismatches
  - localized cleanup that does not change project direction
- Medium:
  - changes affecting multiple files or layers
  - changes that may lock in a provisional decision
  - meaningful schema, architecture, or documentation-structure changes
  - rewrites that materially change emphasis
- Large:
  - changes to architecture direction
  - changes to the UX or UI model
  - major schema redesign
  - new dependencies with structural impact
  - changes that contradict or effectively redefine `SPECIFICATIONS.md`
  - public positioning changes that materially change how the repo presents the author or project

Output format:
1. Alignment summary
   - Brief overall assessment: aligned, partially aligned, or misaligned

2. Small issues fixed
   - List each small issue fixed
   - Say which files were changed

3. Medium or large issues found
   For each issue, provide:
   - severity
   - area affected
   - what is misaligned
   - why it matters
   - required change
   - files likely affected
   - whether it touches architecture, UX/UI, schema, docs, or positioning

4. Approval request
   - If any medium or large issues exist, stop after summarizing them and ask for approval before making those changes.

5. Final check
   - Confirm whether the repo is aligned for the reviewed scope after the small fixes only
   - List any remaining open items that still need an explicit decision

Important constraints:
- Read only the `SPECIFICATIONS.md` sections relevant to the reviewed area.
- If you find a contradiction with `SPECIFICATIONS.md`, state it explicitly and do not guess.
- Keep any direct fixes minimal and localized.
