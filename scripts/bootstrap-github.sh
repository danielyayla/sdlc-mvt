#!/usr/bin/env bash
# One-time GitHub setup for this repo. Idempotent; safe to re-run.
# Needs: gh logged in as the repo owner. Everything here is free-tier on a public repo.
#   - labels: intent, monitor
#   - environment `production` with the owner as required reviewer (gates deploy.yml)
#   - Pages source = GitHub Actions
#   - branch protection on main: required checks lint/test/build, PR required, no force push,
#     linear history, applies to admins. 0 approvals because a sole maintainer cannot approve
#     their own PR (see docs/GAPS.md).
set -euo pipefail

repo=${1:-$(gh repo view --json nameWithOwner -q .nameWithOwner)}
owner=${repo%%/*}
owner_id=$(gh api "users/$owner" -q .id)
echo "repo: $repo (owner $owner, id $owner_id)"

echo "-- labels"
gh label create intent  --repo "$repo" --color 0E8A16 --description "An idea or finding entering the loop (intents/)" --force >/dev/null
gh label create monitor --repo "$repo" --color D93F0B --description "Opened by monitor.yml on a failed probe" --force >/dev/null

echo "-- environment: production (required reviewer: $owner)"
gh api -X PUT "repos/$repo/environments/production" \
  --input - >/dev/null <<JSON
{"reviewers":[{"type":"User","id":$owner_id}],"prevent_self_review":false,"deployment_branch_policy":{"protected_branches":true,"custom_branch_policies":false}}
JSON

echo "-- pages: build from GitHub Actions"
if gh api "repos/$repo/pages" >/dev/null 2>&1; then
  gh api -X PUT "repos/$repo/pages" -f build_type=workflow >/dev/null
else
  gh api -X POST "repos/$repo/pages" -f build_type=workflow >/dev/null
fi

echo "-- branch protection: main"
gh api -X PUT "repos/$repo/branches/main/protection" --input - >/dev/null <<'JSON'
{
  "required_status_checks": {"strict": true, "contexts": ["lint", "test", "build"]},
  "enforce_admins": true,
  "required_pull_request_reviews": {"required_approving_review_count": 0, "dismiss_stale_reviews": true},
  "restrictions": null,
  "required_linear_history": true,
  "allow_force_pushes": false,
  "allow_deletions": false,
  "required_conversation_resolution": true
}
JSON

echo "done. Remaining manual steps:"
echo "  1. Run: claude setup-token   then: gh secret set CLAUDE_CODE_OAUTH_TOKEN --repo $repo"
echo "  2. After the first deploy, set repo variable MONITOR_URL to the live Pages URL."
