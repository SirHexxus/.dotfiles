#!/usr/bin/env bash
# PreToolUse hook: block dangerous bash commands before execution
# Receives JSON on stdin: {"tool_name": "Bash", "tool_input": {"command": "..."}}
set -u
set -o pipefail

input="$(cat)"
tool_name="$(printf '%s' "$input" | jq -r '.tool_name // empty')"

[[ "$tool_name" != "Bash" ]] && exit 0

command="$(printf '%s' "$input" | jq -r '.tool_input.command // empty')"

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
