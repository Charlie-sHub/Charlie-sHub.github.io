Review this repository for alignment between the current implementation, repository structure, and documentation.

Scope:
- Check alignment between:
  - the direct request in this prompt
  - SPECIFICATIONS.md
  - AGENTS.md
  - README.md
  - relevant source code
  - relevant content/assets/schemas if they are part of the affected area
- Treat SPECIFICATIONS.md as the primary source of project direction.
- Treat AGENTS.md as operating guidance, not as the main spec.

What to review:
1. Code vs SPECIFICATIONS.md
2. Code vs README.md
3. README.md vs SPECIFICATIONS.md
4. AGENTS.md vs SPECIFICATIONS.md
5. Content/schema/asset structure vs documented direction
6. Public-facing wording vs repo positioning/tone, where relevant

Decision rule:
- If an issue is small and low-risk, fix it directly.
- If an issue is medium or large, do not implement it yet. Summarize it clearly and ask for approval.

Classify issues like this:
- Small:
  - wording drift
  - minor naming inconsistencies
  - outdated doc details
  - small structural mismatches
  - missing comments or small cleanup
  - safe fixes that do not alter project direction, architecture, UX/UI direction, schema direction, or public positioning
- Medium:
  - changes affecting multiple files or layers
  - changes that may lock in a provisional decision
  - meaningful schema or architecture adjustments
  - documentation rewrites that change emphasis materially
  - refactors beyond localized cleanup
- Large:
  - changes to architecture direction
  - changes to UX/UI model
  - new dependencies with structural impact
  - major schema redesign
  - changes that contradict or effectively redefine SPECIFICATIONS.md
  - public positioning changes that materially affect how the repo presents the author or project

Required behavior:
- Read SPECIFICATIONS.md first.
- Extract only the parts relevant to the area being reviewed.
- Check whether the request, code, and docs agree.
- Make the smallest change that fully solves any small issue.
- Do not do unrelated refactors.
- Do not add speculative features.
- Do not silently resolve open questions through implementation.
- Prefer extending existing patterns already present in the repo.

Output format:
1. Alignment summary
   - Brief overall assessment: aligned / partially aligned / misaligned

2. Small issues fixed
   - List each small issue fixed
   - Say which files were changed
   - Keep changes minimal and scoped

3. Medium or large issues found
   For each issue, provide:
   - severity: medium or large
   - area affected
   - what is misaligned
   - why it matters
   - required change
   - files likely affected
   - whether it touches architecture, UX/UI, schema, docs, or positioning

4. Approval request
   - If any medium or large issues exist, stop after summarizing them and ask for approval before making those changes.

5. Final check
   - Confirm whether the repo is now aligned for the reviewed scope after the small fixes only
   - List any remaining open items that need an explicit decision

Important constraints:
- Do not implement medium or large changes without approval.
- If you find a contradiction with SPECIFICATIONS.md, state it explicitly and do not guess.
- If something is intentionally open in the spec, keep the current solution reversible and do not lock in a new direction unless explicitly approved.