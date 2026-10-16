# Spec 001: first page

- Source intent: `intents/001-first-page.md`
- Status: draft
- Author: Claude Code (spec pass), reviewed by Daniel Kapper
- Date: 2026-10-16

## Problem

There is no public page that says what Daniel does and who it is for. Intent 001 asks for a one-page site with the niche and the pitch, deployed to GitHub Pages, with a smoke test and a monitor. It is also the first change to flow through this repo's pipeline, so the spec keeps the product tiny and lets the process carry the weight.

## Requirements

### Functional

1. One route, `/`, renders a single HTML page with: a site name, a one-line niche statement, a pitch paragraph, and one call-to-action link (email or external link).
2. All copy lives in one data file, `src/data/site.json`, so wording changes are content-only PRs (POLICY rule 2 exemption) and never touch templates.
3. The page is served from GitHub Pages at `https://danielyayla.github.io/sdlc-mvt/`; all internal links and asset paths respect the `/sdlc-mvt` base path.
4. `npm run build` writes the site to `dist/`, and `deploy.yml` publishes that directory unchanged.
5. A Playwright smoke test starts the built site with `astro preview`, loads `/sdlc-mvt/`, asserts HTTP 200, exactly one `h1`, and that the pitch text from `site.json` is visible. It runs in the CI `test` job.
6. A Vitest unit test validates `site.json`: every required field is a non-empty string and the CTA is a valid `mailto:` or `https:` URL. This is the only unit test, since the page has no other logic.
7. `npm run lint` runs `astro check` (template and type errors) and must exit non-zero on warnings as well as errors, to satisfy the zero-warnings rule in `CLAUDE.md`. By default `astro check` exits 0 on warnings; the plan pins the flag that raises the failing severity (`--minimum-failing-severity warning` in current Astro) and verifies it against the installed version.

### Non-functional

- No client-side JavaScript shipped; the page is static HTML and CSS only.
- No third-party requests: no CDN fonts, analytics, or embeds (POLICY rule 9). System font stack.
- Page weight under 50 KB total.
- Accessible by default: `lang` attribute, one `h1`, visible focus styles, text contrast at least 4.5:1.
- CI (lint, test, build) completes in under 5 minutes on a GitHub-hosted runner.

## Design

- **Pages / routes:** `src/pages/index.astro` (the only page). `src/layouts/Layout.astro` holds `<head>`, meta tags and global CSS.
- **Components:** none beyond the layout. A single page does not need components yet.
- **Data and content:** `src/data/site.json` with fields `name`, `niche`, `pitch`, `cta: { label, href }`. The page imports it directly. Editing copy means editing this file only.
- **Config:** `astro.config.mjs` with `site: 'https://danielyayla.github.io'` and `base: '/sdlc-mvt'`. `package.json` scripts: `dev`, `build`, `preview`, `lint` (`astro check`), `test` (`vitest run`), `test:e2e` (`playwright test`). `playwright.config.ts` uses `webServer` to run `npm run preview` and sets `baseURL` to the preview origin.
- **Tests:** `src/data/site.test.ts` (Vitest, requirement 6); `e2e/smoke.spec.ts` (Playwright, requirement 5).
- **Deploy and monitor touchpoints:** `deploy.yml` already builds and publishes `dist/` behind the `production` environment; no workflow changes needed. After the first successful deploy the owner sets the repo variable `MONITOR_URL` to the live URL, which arms `monitor.yml`.
- **Dependencies (dev only):** `astro`, `@astrojs/check` and `typescript` (for `astro check`), `vitest`, `@playwright/test`. Five packages, each needing a `New dependency:` line in the build PR (POLICY rule 5).

## Constraints applied

- **Rule 2 (tests for logic):** the only logic is the data-file validation, and it has a unit test. The smoke test covers the rendered page.
- **Rule 4 (protected paths):** no edits to `.github/workflows/`, `.claude/`, `CLAUDE.md` or `POLICY.md`. The existing CI already detects `package.json` and `playwright.config.*` and switches itself on.
- **Rule 5 (dependencies):** five dev dependencies, listed above, each declared in the PR body. Lockfile committed from `npm install`, never hand-edited.
- **Rule 9 (static only):** no runtime, no third-party scripts, system fonts.
- **Rule 10 (docs stay true):** `CLAUDE.md` already documents these commands; the build PR must confirm they match, and update `README.md` only if the setup steps change.
- **Rule 11 (blast radius):** see flagged concern 2.

## Flagged concerns

1. **The copy is unknown.** The intent does not state the niche or the pitch. The build PR will ship `site.json` with clearly marked placeholder text (`[Your niche here]`) unless the owner supplies the words first. Shipping placeholders to a public URL is the owner's call. Recommendation: supply the four strings (name, niche, pitch, CTA) as a comment on this PR, or accept placeholders and follow with a content-only PR.
2. **File count versus rule 11.** An Astro project with tests and config is roughly 11 files: `package.json`, `package-lock.json`, `astro.config.mjs`, `tsconfig.json`, `playwright.config.ts`, `.gitignore` edit, `src/layouts/Layout.astro`, `src/pages/index.astro`, `src/data/site.json`, `src/data/site.test.ts`, `e2e/smoke.spec.ts`. That is at the rule 11 threshold for one intent. Recommendation: the owner waives rule 11 for this PR in the PR body, since splitting a scaffold across two PRs would leave CI red in between.
3. **First real deploy exercises an untested path.** `deploy.yml` uses an environment named `production` rather than the Pages default `github-pages`. `docs/GAPS.md` records that `actions/deploy-pages` may reject this. The first deploy of this intent is the test. If it fails, the fix is a workflow edit (rule 4, owner approval) and does not block the build PR.
4. **The fourth done-when item is not a code change.** "The monitor is armed" requires setting the repo variable `MONITOR_URL`, which only the owner can do and only after the deploy succeeds. The build PR cannot prove it. Recommendation: the owner sets the variable right after approving the deploy, then triggers `monitor.yml` once by hand and links the green run on the intent.
5. **Intent risk is "low" but the PR adds the toolchain.** Five dependencies and the lockfile are the largest diff this repo will see for a while. Risk stays low (nothing external, easy to revert) but the review should check the lockfile matches `package.json` (rule 5).

## Open questions

- What exactly is the niche and the pitch copy? `carried to plan` (see concern 1; placeholders unless answered on this PR).
- Any visual direction, or plain readable defaults? `answered: plain readable defaults.` A system font stack, one column, max width around 60 characters, generous spacing. No design system until a later intent asks for one.
- Should the CTA be an email or a link? `carried to plan` (default `mailto:`, owner to confirm the address or link).

## Acceptance criteria

| Intent done-when | How we prove it |
| --- | --- |
| A single page states the niche and the pitch. | `e2e/smoke.spec.ts` asserts the `h1` and the pitch text from `site.json` are visible at `/sdlc-mvt/`. Screenshot attached to the build PR. |
| The page is live on GitHub Pages at the repo's Pages URL. | The `Deploy` run for the merged build PR succeeds and `curl -sI https://danielyayla.github.io/sdlc-mvt/` returns 200. Link the run on the PR. |
| A Playwright smoke test loads the page and checks the pitch text is present, and it runs in CI. | The CI `test` job on the build PR shows the Playwright step executed and passed. |
| The scheduled monitor is armed against the live URL and opens an Issue labeled `intent` when the page is down. | Repo variable `MONITOR_URL` is set; a manual `monitor.yml` run is green. Failure path proven once by pointing `MONITOR_URL` at a 404 for one manual run, confirming an Issue labeled `intent` and `monitor` appears, then resetting it. |
