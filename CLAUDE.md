# sdlc-mvt

Minimum viable test of the AI-native SDLC playbook. Process first; the site is intent 001.
Stack when the site exists: Node 22, npm, Astro, Vitest (unit), Playwright (smoke/e2e).

## Commands

There is no `package.json` until intent 001 ships. CI skips these steps with "no app yet" until then.

- Install: `npm ci`
- Dev: `npm run dev`
- Build: `npm run build` (must finish with Astro's "Complete!" line and write `dist/`)
- Lint: `npm run lint` (zero warnings)
- Unit tests: `npm test` (Vitest, all green)
- Smoke/e2e: `npx playwright install --with-deps chromium` once, then `npm run test:e2e`

## Verifying your work

Run lint, test and build before reporting any task complete, and paste the output.
If a test fails, fix the code, not the test. Never skip, delete or weaken a test to get green.

## Branches and PRs

- One branch per intent: `intent/NNN-slug` (NNN matches the file in `intents/`).
- One PR per plan. The PR body links the intent, spec and plan it implements.
- Never push to `main`. Everything lands through a PR with green CI. A hook blocks `git push` to main.
- Any edit under `.github/workflows/` pauses for the owner's confirmation (hook) and needs owner approval in review (POLICY rule 4).
- If implementation departs from the plan, update `docs/plans/NNN-slug.md` in the same commit.
- Commit messages: `<type>: <summary>` where type is feat, fix, chore, docs, test, ci.

## The artifact chain

```
intents/NNN-slug.md → docs/specs/NNN-slug.md → docs/plans/NNN-slug.md → PR → evidence → monitor → new intent
```

1. **Intent** (`intents/`, from `intents/INTENT_TEMPLATE.md`): what, why, who asked, done-when, risk. The owner accepts it by setting `Status: accepted`.
2. **Spec** (`docs/specs/`, from `docs/SPEC_TEMPLATE.md`): requirements and design with flagged concerns. Owner accepts it in the PR that adds it.
3. **Plan** (`docs/plans/`, from `docs/PLAN_TEMPLATE.md`): written in plan mode, names files, order, tests and proof. Owner accepts before any code is written.
4. **PR**: implements one plan. Reviewed by `claude.yml` against `POLICY.md`; merged by a human.
5. **Evidence**: the CI run, the review comment and the `production` deploy approval attached to the PR.
6. **Monitor**: `monitor.yml` curls the live URL on a schedule. A failure opens an Issue labeled `intent`.
7. **New intent**: triage the Issue; if it is real, copy it to `intents/NNN-slug.md` and the loop restarts.

## Policy and review

`POLICY.md` is the rulebook every PR is reviewed against. Read it before opening a PR.
Comment `@claude` on a PR or Issue to have the action address it.

## Recurring corrections

When a mistake is corrected for the second time, the correction goes here as one line.

(none yet)
