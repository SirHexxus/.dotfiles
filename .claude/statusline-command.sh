#!/usr/bin/env bash
# ~/.claude/statusline-command.sh
# Status line mirroring ~/.bash_prompt PS1:
#   green user@host : blue cwd  yellow (git-branch)

input=$(cat)
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
[ -z "$cwd" ] && cwd=$(pwd)

# Git branch (skip optional locks to avoid contention)
git_branch=$(git -C "$cwd" --no-optional-locks branch 2>/dev/null \
    | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/')

printf '\033[01;32m%s@%s\033[00m:\033[01;34m%s\033[33m%s\033[00m' \
    "$(whoami)" "$(hostname -s)" "$cwd" "$git_branch"
