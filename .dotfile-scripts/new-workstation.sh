#!/usr/bin/env bash
#
# new-workstation.sh - Bootstrap dotfiles on a new machine
#
# Usage: curl -fsSL https://raw.githubusercontent.com/SirHexxus/.dotfiles/master/.dotfile-scripts/new-workstation.sh | bash
#    or: bash new-workstation.sh
#

set -e

DOTFILES_REPO="https://github.com/SirHexxus/.dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d_%H%M%S)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

info() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# Check for required dependencies
check_dependencies() {
    info "Checking dependencies..."

    local missing=()

    command -v git >/dev/null 2>&1 || missing+=("git")
    command -v rsync >/dev/null 2>&1 || missing+=("rsync")

    if [ ${#missing[@]} -ne 0 ]; then
        error "Missing required dependencies: ${missing[*]}\nInstall them with: sudo apt install ${missing[*]}"
    fi

    info "All dependencies satisfied."
}

# Backup existing dotfiles
backup_existing() {
    info "Checking for existing dotfiles to backup..."

    local files_to_backup=(
        ".bashrc"
        ".bash_aliases"
        ".bash_functions"
        ".bash_exports"
        ".bash_prompt"
        ".vimrc"
        ".gitconfig"
        ".inputrc"
        ".tmux.conf"
    )

    local needs_backup=false
    for file in "${files_to_backup[@]}"; do
        if [ -f "$HOME/$file" ] && [ ! -L "$HOME/$file" ]; then
            needs_backup=true
            break
        fi
    done

    if [ "$needs_backup" = true ]; then
        info "Backing up existing dotfiles to $BACKUP_DIR"
        mkdir -p "$BACKUP_DIR"

        for file in "${files_to_backup[@]}"; do
            if [ -f "$HOME/$file" ] && [ ! -L "$HOME/$file" ]; then
                cp "$HOME/$file" "$BACKUP_DIR/" 2>/dev/null && \
                    info "  Backed up $file" || true
            fi
        done
    else
        info "No existing dotfiles to backup."
    fi
}

# Clone and install dotfiles
install_dotfiles() {
    if [ -d "$DOTFILES_DIR" ]; then
        warn "Dotfiles directory already exists at $DOTFILES_DIR"
        warn "Pulling latest changes..."
        git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" pull || true
    else
        info "Cloning dotfiles repository..."
        git clone --separate-git-dir="$DOTFILES_DIR" "$DOTFILES_REPO" tmpdotfiles
        rsync --recursive --verbose --exclude '.git' tmpdotfiles/ "$HOME/"
        rm -rf tmpdotfiles
    fi

    # Configure the bare repo to ignore untracked files
    git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" config status.showUntrackedFiles no

    # Set up the custom gitignore
    if [ -f "$HOME/.gitignore-dotfiles" ]; then
        git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" config core.excludesFile "$HOME/.gitignore-dotfiles"
    fi

    info "Dotfiles installed successfully."
}

# Create necessary directories
create_directories() {
    info "Creating necessary directories..."

    mkdir -p "$HOME/.local/bin"
    mkdir -p "$HOME/.ssh/sockets"
    chmod 700 "$HOME/.ssh"

    info "Directories created."
}

# Install vim plugins
install_vim_plugins() {
    if command -v vim >/dev/null 2>&1 && [ -f "$HOME/.vimrc" ]; then
        info "Installing Vim plugins..."

        # Install vim-plug if not present
        if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
            curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
                https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim 2>/dev/null || \
                warn "Could not download vim-plug. Install manually."
        fi

        # Install plugins
        vim +PlugInstall +qall 2>/dev/null || \
            warn "Vim plugin installation may have had issues. Run :PlugInstall manually."

        info "Vim plugins installed."
    else
        warn "Vim not found or .vimrc missing. Skipping plugin installation."
    fi
}

# Print optional dependency suggestions
suggest_optional() {
    echo ""
    info "Optional packages you may want to install:"
    echo "  - fzf         : Fuzzy finder (Ctrl+R history search)"
    echo "  - tmux        : Terminal multiplexer"
    echo "  - fastfetch   : System info display (aliased as neofetch)"
    echo "  - xclip       : Clipboard support"
    echo "  - python3-mutagen : MP3 metadata support for mp3meta/mp3update"
    echo ""
    echo "Install with: sudo apt install fzf tmux fastfetch xclip python3-mutagen"
}

# Main
main() {
    echo ""
    echo "=================================="
    echo "  Dotfiles Installation Script"
    echo "=================================="
    echo ""

    check_dependencies
    backup_existing
    install_dotfiles
    create_directories
    install_vim_plugins
    suggest_optional

    echo ""
    info "Installation complete!"
    info "Restart your shell or run: source ~/.bashrc"
    echo ""
}

main "$@"
