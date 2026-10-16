#!/usr/bin/env bash
# PreToolUse hook for Edit|Write|MultiEdit.
#   - ask: any target path under .github/workflows/ (POLICY rule 4)
set -euo pipefail

input=$(cat)
paths=$(printf '%s' "$input" | jq -r '[.tool_input.file_path?, (.tool_input.edits // [])[]?.file_path?] | map(select(. != null)) | .[]')

if printf '%s\n' "$paths" | grep -q '\.github/workflows/'; then
  jq -n '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"ask",permissionDecisionReason:"Editing a file under .github/workflows/. Workflow edits need the owner'"'"'s confirmation (POLICY rule 4)."}}'
fi
exit 0
