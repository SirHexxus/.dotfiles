#!/usr/bin/env bash
# PostToolUse hook: desktop notification when a Bash tool call completes
# Receives JSON on stdin: {"tool_name": "Bash", "tool_input": {"command": "..."}, ...}
set -u
set -o pipefail

input="$(cat)"
tool_name="$(printf '%s' "$input" | jq -r '.tool_name // empty')"

[[ "$tool_name" != "Bash" ]] && exit 0

command="$(printf '%s' "$input" | jq -r '.tool_input.command // empty')"
# Truncate long commands for the notification body
short_cmd="${command:0:80}"
[[ "${#command}" -gt 80 ]] && short_cmd="${short_cmd}..."

notify-send \
	--urgency=low \
	--app-name="Claude Code" \
	"Bash command complete" \
	"$short_cmd" 2>/dev/null

exit 0
