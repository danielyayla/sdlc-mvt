# Add contact form submission via API

## Artifacts
- Intent: intents/003-contact.md
- Spec: docs/specs/003-contact.md
- Plan: docs/plans/003-contact.md

## What changed
Adds a config module for the form backend and wires the submit handler. Tests cover the payload builder.

## Dependencies
New dependency: none

## Proof
npm run lint: 0 warnings. npm test: 7 passed. npm run build: Complete!
