# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Append to the history file, don't overwrite it
shopt -s histappend

# Check the window size after each command
shopt -s checkwinsize

# Enable extended globbing
shopt -s extglob

# Bash version >= 4 features
shopt -s autocd   2>/dev/null || true
shopt -s dirspell 2>/dev/null || true
shopt -s cdspell  2>/dev/null || true

# Make less more friendly for non-text input files
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Enable color support of ls and common tools
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Basic ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Alert alias for long running commands (use: sleep 10; alert)
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Dotfile management alias
alias dotfiles='/usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME"'

# Load modular configuration files
[ -f ~/.bash_exports ]   && . ~/.bash_exports
[ -f ~/.bash_prompt ]    && . ~/.bash_prompt
[ -f ~/.bash_aliases ]   && . ~/.bash_aliases
[ -f ~/.bash_functions ] && . ~/.bash_functions

# Load bash completion
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
elif [ -f /etc/bash/bash_completion ]; then
    . /etc/bash/bash_completion
elif [ -f ~/.bash_completion ]; then
    . ~/.bash_completion
fi

# fzf integration (if installed)
[ -f ~/.fzf.bash ] && . ~/.fzf.bash

# Local customizations (not tracked in dotfiles)
[ -f ~/.bashrc.local ] && . ~/.bashrc.local
