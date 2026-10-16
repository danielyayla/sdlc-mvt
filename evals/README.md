# PR-reviewer eval

Checks that the policy reviewer (the prompt in `.github/workflows/claude.yml` plus `POLICY.md`) reaches the right verdict on known PRs. It tests **policy adherence**, not code quality. Run it whenever `POLICY.md`, `CLAUDE.md`, the review prompt, hooks or the model changes.

## Case format

One directory per case under `cases/`:

```
cases/NN-short-name/
├── pr.md           # PR title and body, as the author would write it
├── diff.patch      # unified diff of the PR
└── expected.txt    # PASS or FAIL (one word)
```

The runner feeds `POLICY.md` + `pr.md` + `diff.patch` to `claude -p` with no tools, asks for the verdict format POLICY.md defines, and compares the first `VERDICT:` line to `expected.txt`.

## Run it

```bash
./evals/run.sh              # all cases, needs a logged-in `claude` CLI
./evals/run.sh --case 04    # one case (prefix match)
./evals/run.sh --dry-run    # validate case structure only, no model calls
```

Exit code is 0 when every verdict matches, 1 otherwise. Each run writes `runs/<timestamp>.md` with the per-case verdicts and the model's reasoning so runs can be compared over time (`runs/` is gitignored; copy a run into a PR if it is evidence).

## Seed cases

| Case | Expected | Rule exercised |
| --- | --- | --- |
| 01-copy-change | PASS | content-only change, no test required (rule 2 exemption) |
| 02-logic-with-tests | PASS | logic plus test in the same PR (rule 2) |
| 03-dependency-declared | PASS | new dependency with a `New dependency:` line (rule 5) |
| 04-hardcoded-secret | FAIL | secret in the diff (rule 1) |
| 05-logic-without-tests | FAIL | logic change, no test, no reason (rule 2) |

## TODO

- Grow to 20+ cases from real PRs. Add a case every time the reviewer misses something a human caught, and every time it flags something wrong. Add one per incident the monitor opens, once the fix ships.
- Add cases for rules 3, 4, 6, 9 and 11, which the seeds do not cover.
- Wire as a CI job on changes to `POLICY.md`, `CLAUDE.md` and `.claude/**` once the API key secret exists (see `docs/GAPS.md`).
