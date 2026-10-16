# Add sitemap integration

## Artifacts
- Intent: intents/002-sitemap.md
- Spec: docs/specs/002-sitemap.md
- Plan: docs/plans/002-sitemap.md

## What changed
Adds the official Astro sitemap integration so search engines can find the page. Config and package files only, both listed in the plan.

## Dependencies
New dependency: @astrojs/sitemap — official Astro integration, generates sitemap-index.xml at build; no runtime code.

## Proof
npm run lint: 0 warnings. npm test: 5 passed. npm run build: Complete! (sitemap-index.xml written to dist/)
