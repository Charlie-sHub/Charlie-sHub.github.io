# Portfolio Website

Public repository for my portfolio website and its content structure.

This project is intentionally treated as a real software project, not just a visual landing page. Its purpose is to present software development work, security-oriented engineering thinking, certifications, technical learning, and the way I plan, structure, and communicate technical work.

The site is being built with Flutter Web and is designed to stay content-driven, maintainable, and easy to extend over time.

---

## Overview

This repository contains the implementation and public-safe content for a portfolio website focused on:

- software development work
- security-oriented engineering
- certifications and technical learning
- project breakdowns and technical reasoning
- maintainable structure and clear documentation

The goal is not only to show finished work, but to show how that work is planned, built, validated, and explained.

---

## Current Direction

The current implementation direction is:

- **Flutter Web** as the core stack
- **content-first structure**, with structured public JSON under `assets/content/`, supporting images under `assets/media/`, and downloadable documents under `assets/documents/`
- **horizontal layered architecture** rather than feature slices
- **snake_case naming** for content slugs and slug-derived asset directories
- **public-safe documentation** that explains the project without exposing internal planning material

This repository is expected to evolve, but the direction is to keep the codebase understandable, durable, and easy to review.

It is also more engineered than a simple static portfolio strictly needs to be. That is intentional: part of the project is to show architecture, maintainability, validation, engineering habits, and the way I normally structure software.

Some legacy site code and assets also remain temporarily in the repository while the Flutter replacement is still being completed.

---

## What the Website Should Show

The site is intended to surface the strongest proof quickly, while still allowing deeper exploration.

Core content areas currently represented in `assets/content/` include:

- **Home**  
  A clear introduction, areas of focus, and direct paths to projects, certifications, and contact details.

- **Projects**  
  Not just what was built, but why it mattered, how it was structured, what trade-offs were involved, and what was learned.

- **Security Write-ups / Case Studies**  
  Application-security-oriented observations, defensive case studies, and secure engineering notes that are safe to publish.

- **Certifications**  
  Certifications supported by useful context where possible, such as summaries, practical takeaways, and selected supporting materials.

- **Courses / Technical Learning**  
  Structured learning material that supports the portfolio's technical direction without being treated as a project or case study.

- **About / Working Style**  
  A concise explanation of how I approach architecture, maintainability, documentation, and the overlap between development and security.

- **Resume**  
  Structured resume metadata under `assets/content/resume/`, with the downloadable CV PDF handled separately under `assets/documents/resume/`.

---

## Main Proof Assets

Two projects currently matter most in the portfolio structure:

### PAMi
A major proof project intended to show current engineering thinking more than surface polish alone.

Areas likely to be emphasized include:

- architecture
- authentication and access-related decisions
- validation and input handling
- testing strategy
- CI / automation
- dependency hygiene
- security-aware trade-offs

Where needed, work-in-progress sections will stay high-level and public-safe.

### World On
An older but still meaningful project that shows earlier-stage product thinking and execution.

Its value is mainly in:

- planning
- project management
- development execution
- iteration on product behavior and UX

It should stay honest about its age, context, and limitations.

---

## Tech Stack

Core stack and implementation direction:

- **Flutter Web**
- **Dart**
- **Cubit** for lightweight content-loading orchestration
- **JSON-based content assets**
- **`dartz` value-object style validation where it adds real value**
- **careful dependency selection**

---

## Architecture Snapshot

The intended top-level structure follows horizontal layers:

```text
lib/
  presentation/
  application/
  domain/
  data/

assets/
  content/
    about/
    case_studies/
    certifications/
    courses/
    projects/
    resume/
  media/
    ui/
      backgrounds/
      icons/
    content/
      projects/
        pami/
        world_on/
  documents/
    certifications/
    resume/
```

High-level layer roles:

- `presentation` → UI, pages, sections, widgets, styling, app shell
- `application` → lightweight content-state orchestration
- `domain` → app-facing models and entities whose fields may still carry explicit validation failures
- `data` → asset loading, DTOs, JSON deserialization, repository logic

Preferred content flow:

```text
asset content -> DTO -> domain entity with potentially invalid fields -> state -> presentation
```

This keeps raw public content separate from app-facing domain state. Domain entities may still carry explicit field failures until the loading or application layer decides how to surface them. JSON remains the source of structured content, while images and PDFs are supporting assets referenced from JSON where appropriate.

---

## Repository Structure

Expected repository-visible documentation includes:

- `README.md` — public introduction and usage context
- `SPECIFICATIONS.md` — project direction, constraints, and architecture
- `AGENTS.md` — repo-specific operating guidance for coding agents

The README is intentionally lighter than the specification. It should help a public reader understand the repo quickly without repeating the entire project spec.

---

## Build

Standard release build:

```bash
flutter build web
```

---

## Design and UX Direction

The current design direction is intentionally restrained.

High-level goals:

- calm and structured
- technically credible
- easy to scan
- minimalist without feeling empty
- deliberate rather than decorative

The current preference is to start from a strong clean base and refine visual treatment gradually, rather than overdesigning the first implementation.

---

## AI-Assisted Development

AI was used during development of the website and parts of the documentation. It is used as a tool, with human review and understanding of committed work.

Using AI responsibly is part of current software development practice, but responsibility for the final result remains human.

---

## Status

This project is still in an early but deliberate stage.

Other parts remain intentionally open and will be refined as the project becomes more concrete, especially:

- detailed UX behavior
- final UI system
- content schemas
- deeper project breakdown formats
- whether more advanced navigation or filtering is worth adding later

---

## Why This Repository Exists

This repository is part portfolio, part technical artifact.

It is meant to show not only what I have built, but how I think:

- how I structure work
- how I handle trade-offs
- how I keep systems maintainable
- how development and security thinking reinforce each other
- how I document decisions in a way that stays useful over time
