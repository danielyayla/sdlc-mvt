#!/usr/bin/env bash
# PR-reviewer eval runner. See evals/README.md.
set -euo pipefail

here=$(cd "$(dirname "$0")" && pwd)
root=$(cd "$here/.." && pwd)
dry=false
filter=""

while [ $# -gt 0 ]; do
  case "$1" in
    --dry-run) dry=true ;;
    --case) filter="$2"; shift ;;
    -h|--help) sed -n '2,3p' "$0"; exit 0 ;;
    *) echo "unknown arg: $1" >&2; exit 2 ;;
  esac
  shift
done

policy="$root/POLICY.md"
[ -f "$policy" ] || { echo "POLICY.md not found at $policy" >&2; exit 2; }
if ! $dry; then
  command -v claude >/dev/null || { echo "claude CLI not found; install it or use --dry-run" >&2; exit 2; }
fi

stamp=$(date -u +%Y%m%dT%H%M%SZ)
report="$here/runs/$stamp.md"
mkdir -p "$here/runs"
{
  echo "# Eval run $stamp"
  echo
  echo "| Case | Expected | Got | Result |"
  echo "| --- | --- | --- | --- |"
} > "$report"

pass=0; fail=0; details=""
for dir in "$here"/cases/*/; do
  name=$(basename "$dir")
  [ -n "$filter" ] && [[ "$name" != "$filter"* ]] && continue
  for f in pr.md diff.patch expected.txt; do
    [ -f "$dir/$f" ] || { echo "$name: missing $f" >&2; exit 2; }
  done
  expected=$(tr -d '[:space:]' < "$dir/expected.txt")
  [[ "$expected" == "PASS" || "$expected" == "FAIL" ]] || { echo "$name: expected.txt must be PASS or FAIL" >&2; exit 2; }

  if $dry; then
    printf '%-28s expected %-4s (structure ok)\n' "$name" "$expected"
    echo "| $name | $expected | - | dry-run |" >> "$report"
    continue
  fi

  tmp=$(mktemp)
  {
    echo "You are the policy reviewer for a pull request. Apply ONLY the rules in the policy below."
    echo
    echo "===== POLICY.md ====="
    cat "$policy"
    echo
    echo "===== PULL REQUEST (title and body) ====="
    cat "$dir/pr.md"
    echo
    echo "===== DIFF ====="
    cat "$dir/diff.patch"
    echo
    echo "===== INSTRUCTIONS ====="
    echo "Report exactly as the policy section 'How the reviewer reports' says."
    echo "Your first line must be exactly VERDICT: PASS or VERDICT: FAIL."
  } > "$tmp"
  out=$(claude -p < "$tmp" --tools "" --max-turns 1 --output-format text 2>&1 || true)
  rm -f "$tmp"
  got=$(printf '%s\n' "$out" | grep -Eo 'VERDICT: *(PASS|FAIL)' | head -1 | grep -Eo 'PASS|FAIL' || echo "NONE")
  if [ "$got" = "$expected" ]; then res="ok"; pass=$((pass+1)); else res="MISMATCH"; fail=$((fail+1)); fi
  printf '%-28s expected %-4s got %-4s %s\n' "$name" "$expected" "$got" "$res"
  echo "| $name | $expected | $got | $res |" >> "$report"
  details="$details
## $name

\`\`\`
$out
\`\`\`
"
done

printf '%s\n' "$details" >> "$report"
if $dry; then echo "dry run complete; report: $report"; exit 0; fi
echo
echo "passed $pass, failed $fail; report: $report"
[ "$fail" -eq 0 ]
