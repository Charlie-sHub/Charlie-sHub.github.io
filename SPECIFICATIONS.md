# SPECIFICATIONS.md

> Working public-safe specification for the portfolio website repository.  
> Defines the current direction, constraints, and implementation principles for the project.  
> It will evolve as the project becomes more concrete.

---

## 1. Purpose

This repository contains the portfolio website and its public content structure.

The website should present:
- software development work
- security-oriented engineering work
- certifications and technical learning
- project thinking, implementation quality, and documentation habits

The portfolio should also reflect:
- structured planning
- maintainable implementation
- clear technical communication
- security-aware engineering

---

## 2. Project status

This is an early working specification.

Some parts of the project are already established:
- the website can be rebuilt fully within this repository, including replacement of the current implementation
- Flutter Web is the intended core stack
- the codebase should use a horizontal layered structure rather than feature slices
- public website content should be JSON-first under `assets/content/`
- content should be repository-driven rather than tightly embedded in UI code
- the codebase should remain simple, maintainable, and understandable

Some parts are intentionally still open:
- detailed UX behavior and interaction decisions
- detailed UI specification
- the exact content schema and normalization rules for all sections
- whether any template or external baseline is worth reusing

This document should evolve as those decisions become concrete.

---

## 3. High-level objectives

The website should:

- present the author's work and strongest proof clearly and professionally
- show both development capability and security-aware thinking
- support maintainability and incremental growth
- work well as an open repository and technical artifact without unnecessary complexity

---

## 4. Core principles

### 4.1 Content should drive the site
Prefer clear, version-controlled content over presentation-first hardcoded pages.

### 4.2 Simplicity is preferred
Prefer simpler implementations when they do not weaken the result or remove useful structure.

### 4.3 Maintainability matters
Architecture should stay understandable and avoid abstraction for its own sake.

### 4.4 Security is part of engineering quality
Treat security as part of disciplined software construction, not as a cosmetic add-on.

### 4.5 Documentation should be useful
Repository-visible documentation should be clear, practical, and professional.

### 4.6 The project should be easy to extend
Adding projects, case studies, certifications, courses, and resume metadata should not require restructuring the site.

---

## 5. Intended audience

The site should remain understandable to readers with different levels of technical context. It should stay clear, credible, and easy to navigate without diluting the work itself.

---

## 6. Scope

### In scope
- portfolio website implementation
- structure for projects, case studies, certifications, courses, resume metadata, and related content
- repository-visible documentation required to maintain the project
- secure and maintainable implementation decisions
- clear presentation of technical work
- future UX/UI design decisions once properly defined

### Out of scope for now
- final visual design system
- final animation and motion rules
- detailed copy for every section
- search and filtering in the initial implementation
- speculative features with unclear value
- advanced experimental elements unless they clearly improve the site

---

## 7. Website content and asset model

The website should be content-driven and JSON-first.

Preferred direction:
- `assets/content/` stores structured, public-safe JSON content
- `assets/media/` stores images and other visual assets
- `assets/documents/` stores PDFs and other downloadable supporting documents
- JSON remains the source of structured public content and metadata
- images and downloadable documents are supporting assets referenced from JSON where appropriate
- content may originate from private source material elsewhere, but this repository should favor structured public-safe JSON
- Flutter should load content and supporting assets from the repository in a Flutter-friendly way
- new JSON content files should be addable without manual presentation-layer changes for each entry
- content discovery should be automatic where practical
- ordering and curation should be driven primarily by explicit metadata in the content itself, especially priority
- the system should support surfacing the most important items first without presentation-layer rewiring
- supporting images and documents do not need to participate in the same structured parsing and validation flow as JSON content files
- project image fields may remain optional so unfinished projects, including PAMi, do not require fake placeholders
- the CV or resume PDF should be treated as a site-level downloadable document under `assets/documents/resume/`, while structured resume metadata may still live under `assets/content/resume/`

Current structured content areas under `assets/content/` should reflect the repository's current direction:
- `about/`
- `case_studies/`
- `certifications/`
- `courses/`
- `projects/`
- `resume/`

Recommended supporting asset conventions:
- UI or decorative imagery such as backgrounds, textures, and icons should live under `assets/media/ui/...`
- content-tied images such as project screenshots, thumbnails, hero images, and certification badges should live under `assets/media/content/<section>/<slug>/...`
- downloadable PDFs such as certification PDFs and CV or resume PDFs should live under `assets/documents/<section>/...`

Slug and asset-directory naming conventions:
- structured content `slug` values should use `snake_case`
- asset directories derived from content slugs should also use `snake_case`
- examples of preferred slug or asset-directory naming include `world_on`, `security_plus`, and `google_cybersecurity`
- do not use `kebab-case` for content slugs or slug-derived asset directory names

Exact JSON schemas, final image field names, and final document field names remain intentionally open. They should be formalized later during normalization of source material and implementation, without overdesigning the final schemas too early.

Schema evolution should preserve extensibility. New content types or schema refinements should not force broad presentation-layer rewrites where that can reasonably be avoided.

Initial example structure:

```text
assets/
  content/
    about/
      *.json
    case_studies/
      *.json
    certifications/
      *.json
    courses/
      *.json
    projects/
      *.json
    resume/
      *.json
  media/
    ui/
      backgrounds/
      textures/
      icons/
    content/
      projects/
        world_on/
        pami/
      certifications/
        security_plus/
      courses/
        google_cybersecurity/
  documents/
    certifications/
      *.pdf
    courses/
      *.pdf
    resume/
      *.pdf
```

This structure may evolve, but the distinction between structured JSON content and supporting media or document assets should remain clear. Assets should stay easy to version, review, extend, and discover without being scattered unpredictably across the codebase.

---

## 8. Core sections

The exact section order may change, but the website should support at least the following content areas.

### 8.1 Home
The home section should communicate:
- who the author is
- areas of focus
- major technologies and strengths
- clear paths toward projects, certifications, and contact/resume access

### 8.2 Projects
Projects should not only show outcomes. They should explain:
- what was built
- why it mattered
- how it was structured
- what trade-offs were involved
- what was learned
- where relevant, what security or reliability considerations mattered

### 8.3 Security write-ups / case studies
This section may include:
- secure coding write-ups
- incident analysis
- application security observations
- defensive case studies
- selected real-world lessons, where safe and appropriate to publish

### 8.4 Certifications
Certifications should include more than titles where possible. Useful supporting material may include:
- short summaries
- key topics covered
- practical takeaways
- labs or exercises, where worth highlighting

### 8.5 Courses / technical learning
This section may include:
- completed courses
- practical takeaways
- labs or exercises, where worth highlighting
- selected references that genuinely helped shape technical growth

### 8.6 About / working style
This section may explain:
- planning habits
- approach to architecture
- documentation mindset
- maintainability values
- how development and security thinking connect

---

## 9. Major proof assets

Selected projects should serve as concrete proof of how work is planned, built, and communicated.

The current specification treats PAMi and World On as major proof assets for different reasons.

### 9.1 PAMi

PAMi should be one of the strongest project sections on the site. Its presentation should emphasize the engineering decisions behind it as much as the product itself.

Potential areas to highlight:
- architecture
- authentication and access-related decisions
- validation and input handling
- testing strategy
- dependency hygiene
- CI / automation
- threat-aware thinking
- trade-offs between product goals and implementation constraints

If PAMi is still unfinished or unreleased, the website may use:
- a work-in-progress label
- high-level architecture information
- implementation reasoning that is safe to share publicly

Do not publish sensitive, premature, or unsafe details for the sake of completeness.

### 9.2 World On

World On should also be treated as a meaningful proof project. It is older work and should be presented as such. It reflects an earlier stage of the author's development history and predates the current AI-assisted workflow.

Its current proof value lies mainly in:
- project planning
- project management
- product thinking
- development execution

World On should not be framed as a major security proof asset at this stage.

Its presentation should stay honest about its age, context, and limitations.

It may later be revisited for modernization, cleanup, or stronger security-oriented improvements if that becomes worthwhile.

---

## 10. Security requirements

Treat the website as a real software project, not just a static visual artifact.

The implementation should consider:
- minimizing unnecessary third-party dependencies
- avoiding unsafe content rendering patterns
- dependency hygiene and updates
- security-conscious handling of any dynamic content
- keeping the site simple enough to reduce avoidable risk
- documenting relevant protective decisions when that adds value

---

## 11. Technical direction

### 11.1 Core stack
The intended core framework is **Flutter Web**. It aligns with the author's development background, demonstrates Flutter capability directly, and leaves room for richer interaction if needed later.

### 11.2 Repository direction
The new site may be a full rebuild within the existing repository. The current site does not need preservation for its own sake.

New implementation work should be treated as durable project code rather than disposable scaffolding, even where UX, UI, or content details remain open.

### 11.3 Legacy footprint
Legacy files may remain temporarily where they still serve as entry points, bootstrapping surfaces, or migration support.

Replace or remove legacy code, structure, and assets once they no longer support the new implementation. Adapt legacy material only where it has clear implementation value.

### 11.4 Architecture direction
The implementation should use a horizontal layered structure rather than feature slices.

This mirrors the author's normal development style. It is more formal than a minimal portfolio implementation, deliberately making validation, maintainability, and explicit content boundaries visible.

Preferred top-level layers:
- `presentation`
- `application`
- `domain`
- `data`

Layer responsibilities:
- `presentation`: Flutter UI, pages, sections, widgets, app shell and routing, visual rendering, and themes
- `application`: lightweight state management and orchestration using `Cubit`, with one `ContentCubit` for loading public content and one `ThemeCubit` for theme mode and visual configuration
- `domain`: validated app-facing models, `dartz`-based value objects where they genuinely add value, and content entities composed from those value objects at the validation boundary
- `data`: asset loading from `assets/content/`, DTOs, JSON deserialization, and repository or data access implementations where needed

### 11.5 Content and data flow direction
Public JSON content in this repository should enter the app through a simple validated flow.

Preferred flow:
- asset content
- DTO
- validated domain object
- content state
- presentation

Preferred implementation direction:
- DTOs use `freezed` and JSON serialization and handle raw asset deserialization
- `dartz` at the validation boundary allows domain value objects to represent valid data or failures explicitly
- entities are composed from validated value objects
- explicit validation boundary between raw asset data and trusted app data
- malformed or invalid content should fail fast during development rather than pass silently into trusted app state
- content state should represent validated content and explicit failure or degraded states rather than mask invalid asset data
- presentation should still provide robust fallback handling for missing, failed, or degraded content states, but fallback rendering should not replace proper validation
- PDFs may still be handled as supporting assets outside this structured JSON validation flow where that is more appropriate
- a separate mapper layer is not required unless later complexity clearly justifies it

### 11.6 Testing direction
Meaningful automated testing is part of the repository's engineering standard. Validation, content loading, state handling, and important presentation behavior should ship with automated coverage rather than be left as optional cleanup.

Layer expectations:
- `domain`: test validation rules, `dartz`-based value objects, entity construction from validated values, and edge cases around required fields, formats, ranges, and other normalization decisions
- `data`: test DTO deserialization, raw JSON parsing, content and asset loading behavior, and failure cases such as missing fields, malformed values, missing assets, or unsupported shapes
- `application`: test `Cubit` behavior through observable state transitions, especially `ContentCubit` loading, success, degraded, and failure paths, and any `ThemeCubit` behavior that materially changes presentation
- `presentation`: use widget tests for meaningful behavior such as conditional rendering, content-driven UI behavior, and fallback or degraded states; avoid trivial render-only tests

Testing guidance:
- exercise the DTO-to-domain validation boundary directly so invalid content is rejected predictably before entering trusted app state
- treat malformed or invalid content as a first-class test target
- test failure paths and fallback UI behavior where the app is expected to degrade gracefully
- cover the content-loading paths that determine whether entries under `assets/content/` are surfaced, rejected, or shown with fallback handling
- prefer tests that verify important logic and important UI behavior over exhaustive tests for every small widget

### 11.7 Theme and configuration direction
Theme-related files should live under `lib/presentation/theme/`.

Centralize colors, typography assignments, theme tokens, light/dark values, and blur or transparency tuning there or in closely related configuration so visual refinement does not require scattered edits.

Aim for practical flexibility, not an overengineered design system.

### 11.8 External dependencies
External dependencies should be chosen carefully.

Avoid:
- fragile integrations with low value
- dependencies that complicate maintenance without clear benefit
- services that make the site feel dependent on external uptime for core value

---

## 12. UX direction

> Current UX direction is provisional and subject to refinement during implementation.

The intended experience should feel calm, structured, deliberate, technically credible, and easy to trust: minimal without becoming sparse, elegant through restraint rather than decoration, and technical without feeling mechanical.

The current UX direction favors structural simplicity, evidence-first hierarchy, and clear section-based navigation.

The site should support two levels of use:
- a quick pass for understanding who the author is, what kind of work is being presented, and where the strongest proof appears
- a deeper pass for exploring architecture, implementation choices, project breakdowns, and technical reasoning

Preferred direction:
- desktop-first layout that remains fully responsive and mobile-friendly
- v1 should favor a single-page structure if it remains clean, usable, and easy to navigate
- section-based navigation as the default interaction model
- anchor or hash-based navigation is the preferred low-complexity direction for the initial implementation
- major projects, supporting credentials, and technical depth surfaced early without unnecessary interaction overhead
- top-level content easy to scan at a high level, with deeper detail available without making the first view dense
- straightforward movement through content before introducing more state-driven patterns
- progressive disclosure where it helps reveal technical depth gradually rather than placing everything at first glance
- expand or collapse patterns used selectively for deeper technical detail where they improve clarity
- tabs, hidden panels, or similar patterns only where they clearly reduce clutter
- scrolling, hover, and reveal effects kept secondary to content clarity

A cleaner path-style routing model can wait unless later needs justify the extra complexity.

Interaction should improve clarity, not compete with content.

Avoid:
- tab-heavy interaction models or more elaborate routing than the initial implementation needs
- clutter that weakens scanning and hierarchy
- unnecessary friction between the reader and the underlying proof
- decorative interaction that distracts from technical substance
- generic landing-page interaction patterns that weaken credibility
- over-designed interaction patterns that obscure structure or proof

Start with a clean structural base, then refine interaction patterns where the benefits are clear.

---

## 13. UI direction

> Current UI direction is provisional and subject to refinement during implementation.

The intended visual direction is minimalist, elegant, and deliberate.

Preferred characteristics:
- a warm overall identity rather than generic tech styling
- warm orange tones as part of the core palette direction
- light and dark themes that feel like two modes of the same visual identity
- transparency and blur as intended signature elements, introduced progressively from a strong clean base
- selective use of high-resolution landscape imagery as atmospheric texture where it supports mood and identity without adding visual noise

Color and typography should feel intentional, consistent, readable, and easy to evolve before decorative effects are layered in.

Current preferred font direction:
- `Geometria` as the main font candidate for body and interface text
- `Moving Skate` as a sparse accent candidate for the author's name or similarly high-value moments
- monospace used selectively for technical accents, labels, metadata, or comparable supporting roles rather than as the default reading font

These remain current preferences rather than fixed requirements. Placeholder fonts may be used during implementation, and final choices remain subject to availability, usability, and refinement.

Animation and visual effects should be restrained and purposeful.

Avoid:
- generic trend-driven visual treatments
- interchangeable gradient-heavy tech styling
- inconsistent font pairings or weak hierarchy
- animation or visual effects that distract from content
- blur, transparency, or imagery that reduce readability or scannability

The site should feel professional, deliberate, and clearly authored rather than generic or hastily assembled. Exact palette values, typography settings, and effect intensity remain subject to refinement.

---

## 14. Content and publication boundaries

This repository is public-facing.

Repository-visible documentation should be:
- clear
- professional
- practical
- safe to publish

Avoid in repository-visible documents:
- internal planning language that is only useful privately
- manipulative or overly explicit audience-optimization language
- sensitive details that are better kept outside the repository
- details that weaken clarity without improving the public artifact

Private planning and internal working material should remain outside this repository.

---

## 15. AI-assisted development policy

AI may assist development, documentation, planning, and analysis, but:

- AI must not be treated as a black box
- committed code should be understood by a human
- generated suggestions should be reviewed critically
- maintainability matters more than speed alone
- architecture should remain justified, not decorative
- trade-offs should be thought through explicitly for non-trivial decisions

---

## 16. Documentation requirements

This repository is expected to contain, over time:

- `SPECIFICATIONS.md`
- `README.md`
- `AGENTS.md`
- implementation code
- content files
- supporting assets

### 16.1 SPECIFICATIONS.md
Defines project direction, scope, principles, and architectural constraints.

### 16.2 README.md
Introduces the project clearly to a public reader.

### 16.3 AGENTS.md
Provides repo-specific guidance for AI-assisted work on this repository.

These documents should stay aligned without unnecessary duplication.

---

## 17. Quality expectations

The finished project should aim for:

- clear first impression and strong content scannability
- technically credible, maintainable implementation
- sensible responsiveness and accessible basic structure
- stable repository documentation
- easy addition of future content
- a result that feels like a real technical artifact, not a rushed or generic landing page

---

## 18. Open items to refine later

The following areas are expected to change as the project evolves:

- detailed UX behavior and interaction decisions
- detailed UI specification
- section ordering
- exact content schema and normalization rules
- how deep individual project breakdowns should go
- whether a cleaner path-style routing model becomes worthwhile later
- whether search and filtering become worthwhile later
- whether courses and case studies deserve separate navigation priority
- whether any experimental features are actually worth implementing

Open items should be resolved progressively rather than guessed too early.

---

## 19. Change policy

Update this specification when:
- major direction changes are made
- scope changes materially
- UX or UI decisions become concrete
- architecture rules are clarified
- repository-visible documentation policy changes
- content structure becomes more defined

---

## 20. Current implementation stance

For now, the safest implementation stance is:

- keep the architecture simple and explicit
- keep content and rendering reasonably separated
- treat new implementation work as durable project code
- defer UX/UI precision until it is defined
- favor clarity over cleverness
- treat the site as both a portfolio and a real software project
