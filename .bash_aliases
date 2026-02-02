# ~/.bash_aliases - Shell aliases

# Directory listing
alias ld='ls -Al --group-directories-first'

# System info
alias neofetch='fastfetch'
alias nf='neofetch'
alias clnf='clear && neofetch'

# Networking
alias ipls='ip a | grep "inet "'

# Clipboard
alias copy='xclip -selection clipboard'
alias paste='xclip -selection clipboard -o'

# Homelab
alias hlactivate='source ~/homelab-management/.venv/bin/activate'

# Applications
alias megamek='java -jar /home/james/megamek/MekHQ-0.50.06/MegaMek.jar &'

# Safety nets
alias rm='rm -I'
alias mv='mv -i'
alias cp='cp -i'

# Shortcuts
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias reload='source ~/.bashrc'
