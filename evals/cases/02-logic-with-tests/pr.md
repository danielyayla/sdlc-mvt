# Add formatPitch helper for consistent pitch casing

## Artifacts
- Intent: intents/001-first-page.md
- Spec: docs/specs/001-first-page.md
- Plan: docs/plans/001-first-page.md

## What changed
Adds a small helper that trims and sentence-cases the pitch string, with unit tests. Both files are in the plan's "Files that change".

## Dependencies
New dependency: none

## Proof
npm run lint: 0 warnings. npm test: 5 passed (2 new). npm run build: Complete!
