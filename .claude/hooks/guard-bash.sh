#!/usr/bin/env bash
# PreToolUse hook for Bash.
#   - deny:  `git push` that targets main/master (explicitly, or implicitly while on main)
#   - ask:   any command that touches .github/workflows/ (POLICY rule 4)
# Prints nothing and exits 0 when the command is fine.
set -euo pipefail

input=$(cat)
cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // ""')

decide() {
  jq -n --arg d "$1" --arg r "$2" \
    '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:$d,permissionDecisionReason:$r}}'
  exit 0
}

if printf '%s' "$cmd" | grep -Eq '(^|[;&|[:space:]])git[[:space:]]+push([[:space:]]|$)'; then
  # Explicit refspec naming main or master
  if printf '%s' "$cmd" | grep -Eq 'git[[:space:]]+push[^;&|]*[[:space:]:/](main|master)([[:space:]]|$|:)'; then
    decide deny "Pushing to main is blocked. Open a PR from a branch named intent/NNN-slug instead (CLAUDE.md, POLICY rule 7)."
  fi
  # No refspec given: the push goes to the current branch's upstream
  if ! printf '%s' "$cmd" | grep -Eq 'git[[:space:]]+push([[:space:]]+-[-[:alnum:]=]+)*[[:space:]]+[[:alnum:]]'; then
    branch=$(git -C "${CLAUDE_PROJECT_DIR:-.}" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")
    if [ "$branch" = "main" ] || [ "$branch" = "master" ]; then
      decide deny "You are on $branch and 'git push' would push it. Switch to an intent/NNN-slug branch and open a PR (POLICY rule 7)."
    fi
  fi
fi

if printf '%s' "$cmd" | grep -q '\.github/workflows'; then
  decide ask "This command touches .github/workflows/. Workflow edits need the owner's confirmation (POLICY rule 4)."
fi

exit 0
