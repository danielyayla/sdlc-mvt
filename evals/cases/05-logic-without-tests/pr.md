# Handle empty pitch gracefully

## Artifacts
- Intent: intents/001-first-page.md
- Spec: docs/specs/001-first-page.md
- Plan: docs/plans/001-first-page.md

## What changed
formatPitch now falls back to a default string when the input is empty, so the page never renders a blank pitch.

## Dependencies
New dependency: none

## Proof
npm run lint: 0 warnings. npm test: 5 passed. npm run build: Complete!
