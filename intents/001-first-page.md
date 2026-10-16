# Intent 001: first page

- Status: draft
- Author: Daniel Kapper
- Date: 2026-10-16
- Source: idea

## What

Ship a one-page site with my niche and pitch, deployed to GitHub Pages, with a smoke test and a monitor.

## Why

<!-- Expanded from the one-line ask. Correct anything that is not what you meant. -->

There is no public page that says what I do and who it is for. This is also the first real change to flow through the pipeline in this repo, so it exercises every stage of the loop end to end.

## Who asked

Daniel Kapper (repo owner).

## Done when

<!-- Expanded from the one-line ask. Correct anything that is not what you meant. -->

- [ ] A single page states the niche and the pitch.
- [ ] The page is live on GitHub Pages at the repo's Pages URL.
- [ ] A Playwright smoke test loads the page and checks the pitch text is present, and it runs in CI.
- [ ] The scheduled monitor is armed against the live URL and opens an Issue labeled `intent` when the page is down.

## Risk level

low. Static content, no secrets, no new logic beyond a test. The workflow and environment plumbing already exist.

## Out of scope

Multiple pages, a blog, contact forms, analytics, custom domain.

## Open questions

- What exactly is the niche and the pitch copy? (The spec needs the words, or a placeholder the owner replaces.)
- Any visual direction, or plain readable defaults?
