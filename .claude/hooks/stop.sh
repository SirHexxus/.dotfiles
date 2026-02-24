#!/usr/bin/env bash
# Stop hook: append a one-line session summary to ~/.claude/session-log.txt
# Receives JSON on stdin: {"session_id": "...", "transcript_path": "..."}
set -u
set -o pipefail

LOG_FILE="$HOME/.claude/session-log.txt"

input="$(cat)"
session_id="$(printf '%s' "$input" | jq -r '.session_id // "unknown"')"
transcript_path="$(printf '%s' "$input" | jq -r '.transcript_path // ""')"

# Use working directory as project hint
project_dir="$(pwd)"

timestamp="$(date '+%Y-%m-%d %H:%M')"

printf '%s  session=%s  dir=%s\n' \
	"$timestamp" "$session_id" "$project_dir" \
	>> "$LOG_FILE"

exit 0
