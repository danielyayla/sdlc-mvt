# Review policy

Every pull request is reviewed against these rules by `claude.yml` and by the human who merges it. The rules are written so each one can be checked from the diff and the PR body alone.

## Rules

1. **No secrets in the diff.** No API keys, tokens, passwords, private keys or `.env` values, including in tests, fixtures and comments. Placeholders must be obviously fake (`<your-key>`, `example`).
2. **Logic changes ship with tests in the same PR.** A change to a `.ts`, `.js` or `.mjs` file under `src/` that alters behavior comes with a new or updated test. Copy, content, markdown and style-only changes are exempt.
3. **Never weaken a test to get green.** No deleting, skipping (`.skip`, `.only`, `xit`) or loosening assertions. If a test must change, the PR body says why.
4. **Protected paths need the owner's approval.** Edits under `.github/workflows/`, `.claude/`, or to `CLAUDE.md` or `POLICY.md` are reported as Important and the PR says the owner has approved them.
5. **No new dependency without a line in the PR.** Every package added to `package.json` has a `New dependency: <name> — <why>` line in the PR body. Lockfile changes must match `package.json`; no hand-edited lockfiles.
6. **One PR per plan, and the diff stays inside it.** The PR body links its intent, spec and plan. Files changed are in the plan's "Files that change", or the plan is updated in the same PR with a reason.
7. **Nothing reaches `main` except through a PR with green CI.** No force pushes, no skipping or disabling checks, no `[skip ci]`.
8. **The agent never approves or merges its own PR.** A human merges. Review findings inform, they do not approve.
9. **Static site only.** No runtime servers, serverless functions or third-party scripts (analytics, embeds, fonts from a CDN) unless an accepted intent names them.
10. **Docs stay true.** If a change makes `CLAUDE.md` or `README.md` stale, fix them in the same PR.
11. **Small blast radius.** A PR that touches more than about 10 files, or serves more than one intent, gets split.

## How the reviewer reports

- First line: `VERDICT: PASS` or `VERDICT: FAIL`. FAIL if any rule is breached.
- **Important** findings: anything that breaks behavior, leaks data or breaches a rule above. Cite the rule number and the file.
- **Nits**: style, naming, wording. At most five; summarize the rest as a count.
- Do not report generated files, lockfile churn that matches `package.json`, or anything CI already enforces (lint, formatting).
- When a mistake is flagged for the second time, propose a one-line entry for the "Recurring corrections" section of `CLAUDE.md`.
