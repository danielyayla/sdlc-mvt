# sdlc-mvt

A minimum viable test of Anthropic's AI-native SDLC playbook, run on GitHub free tier with Claude Code.

This repo holds the **process** first. The product (a one-page site) is the first intent to flow through it.

## The loop

```
intents/NNN-slug.md  →  docs/specs/NNN-slug.md  →  docs/plans/NNN-slug.md  →  PR  →  evidence  →  monitor  →  new intent
   (what & why)          (requirements/design)       (files, order, proof)   (reviewed     (CI run,      (monitor.yml   (Issue labeled
                                                                              against       review,        curls the      `intent`)
                                                                              POLICY.md)    deploy ok)     live URL)
```

Each stage ends by committing an artifact. The next stage starts by reading it. A human accepts each artifact; the agent never approves its own work.

## Where things live

| Thing | Path |
| --- | --- |
| Agent conventions, commands, recurring corrections | `CLAUDE.md` |
| Review policy every PR is checked against | `POLICY.md` |
| Intents (one file per idea) | `intents/` |
| Spec and plan templates, specs, plans, known gaps | `docs/` |
| CI, PR review, deploy, monitor workflows | `.github/workflows/` |
| Claude Code hooks (push guard, workflow-edit gate) | `.claude/` |
| PR-reviewer eval | `evals/` |
| One-time GitHub setup (labels, environment, protection) | `scripts/bootstrap-github.sh` |

## Setup after cloning

1. Add the repo secret `ANTHROPIC_API_KEY` (Settings → Secrets → Actions). The PR reviewer and the monitor's diagnosis step need it.
2. Run `scripts/bootstrap-github.sh` once (needs `gh` logged in as the owner).
3. After the first deploy, set the repo variable `MONITOR_URL` to the live Pages URL to arm the monitor.
