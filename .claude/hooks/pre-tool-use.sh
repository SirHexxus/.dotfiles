#!/usr/bin/env bash
# PreToolUse hook: block dangerous bash commands before execution
# Receives JSON on stdin: {"tool_name": "Bash", "tool_input": {"command": "..."}}
set -u
set -o pipefail

input="$(cat)"
tool_name="$(printf '%s' "$input" | jq -r '.tool_name // empty')"

[[ "$tool_name" != "Bash" ]] && exit 0

command="$(printf '%s' "$input" | jq -r '.tool_input.command // empty')"

# ── Git commit guard ──────────────────────────────────────────────────────────
# Block `git commit` unless the command is prefixed with APPROVED=1
# Required process: check git log, show proposed message, get explicit approval
# Match `git commit` only at command positions: start of line/string, or after
# &&, ||, ;, |, or $( — prevents false positives from echo/grep/strings
GIT_COMMIT_PATTERN='(^|&&|\|\||[;|]|\$\()\s*([A-Z_]+=\S+\s+)*git\s+commit'
APPROVED_PATTERN='(^|&&|\|\||[;|]|\$\()\s*APPROVED=1\s+git\s+commit'
if printf '%s' "$command" | grep -qP "$GIT_COMMIT_PATTERN"; then
	if ! printf '%s' "$command" | grep -qP "$APPROVED_PATTERN"; then
		printf 'BLOCKED: git commit requires explicit approval first.\n\n'
		printf 'Required process:\n'
		printf '  1. Run: git log --oneline -10  (read existing commit style)\n'
		printf '  2. Run: git diff --staged       (review what will be committed)\n'
		printf '  3. Show the proposed commit message — wait for your approval\n'
		printf '  4. Prefix the commit with APPROVED=1 after you approve\n\n'
		printf 'Example: APPROVED=1 git commit -m "fix: ..."\n'
		exit 2
	fi
fi

dangerous_patterns=(
	'rm\s+-[a-zA-Z]*r[a-zA-Z]*f'
	'rm\s+-[a-zA-Z]*f[a-zA-Z]*r'
	'git\s+push\s+.*--force'
	'git\s+push\s+.*-f\b'
	'git\s+reset\s+--hard'
	'DROP\s+TABLE'
	'DROP\s+DATABASE'
	'mkfs\.'
	'dd\s+.*of=/dev/'
	'chmod\s+-R\s+777'
)

for pattern in "${dangerous_patterns[@]}"; do
	if printf '%s' "$command" | grep -qiP "$pattern"; then
		printf 'BLOCKED: Potentially destructive command detected.\n'
		printf 'Pattern matched: %s\n' "$pattern"
		printf 'Command: %s\n' "$command"
		printf 'Review the command and re-run manually if intentional.\n'
		exit 2
	fi
done

exit 0
