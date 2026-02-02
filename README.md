# Dotfiles

Personal dotfiles managed with a bare Git repository.

## Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/SirHexxus/.dotfiles/master/.dotfile-scripts/new-workstation.sh | bash
```

Or clone manually:

```bash
git clone --separate-git-dir=$HOME/.dotfiles https://github.com/SirHexxus/.dotfiles.git tmpdotfiles
rsync --recursive --verbose --exclude '.git' tmpdotfiles/ $HOME/
rm -rf tmpdotfiles
```

## What's Included

### Shell Configuration

| File | Purpose |
|------|---------|
| `.bashrc` | Main bash config, sources modular files |
| `.bash_aliases` | Command aliases |
| `.bash_functions` | Shell functions (mkcd, cdls, extract, etc.) |
| `.bash_exports` | Environment variables |
| `.bash_prompt` | Prompt configuration with git branch |
| `.inputrc` | Readline settings (history search, completion) |

### Editor & Tools

| File | Purpose |
|------|---------|
| `.vimrc` | Vim configuration with vim-plug and plugins |
| `.gitconfig` | Git user settings |
| `.tmux.conf` | Tmux configuration |
| `.ssh/config.template` | SSH config template (copy to `config`) |

### Utility Scripts

Located in `~/.local/bin/`:

- **lorem** - Generate Lorem Ipsum text
- **mp3meta** - Display MP3 metadata
- **mp3update** - Batch update MP3 metadata

## Managing Dotfiles

The `dotfiles` alias works like git but for your home directory:

```bash
# Check status
dotfiles status

# Add a file
dotfiles add .some-config

# Commit changes
dotfiles commit -m "Add some-config"

# Push to remote
dotfiles push
```

## Local Customizations

These files are sourced if they exist but are not tracked:

- `~/.bashrc.local` - Machine-specific bash settings
- `~/.vimrc.local` - Machine-specific vim settings
- `~/.tmux.conf.local` - Machine-specific tmux settings

## Key Features

### Readline (`.inputrc`)
- Case-insensitive tab completion
- Arrow up/down searches history by prefix
- Ctrl+Left/Right moves by word

### Shell Functions
- `mkcd <dir>` - Create and enter directory
- `cdls <dir>` - Change directory and list contents
- `extract <file>` - Extract any archive format
- `bak <file>` - Quick backup (creates file.bak)
- `myip` - Show public IP address

### Tmux
- Prefix: `Ctrl+a` (like screen)
- Split: `|` (horizontal), `-` (vertical)
- Navigate: `h/j/k/l` (vim-style)
- Reload config: `prefix + r`

## Dependencies

**Required:**
- git
- rsync

**Optional:**
- vim (for .vimrc)
- tmux (for .tmux.conf)
- fzf (fuzzy history search)
- fastfetch (system info, aliased as neofetch)
- xclip (clipboard support)
- python3-mutagen (for mp3meta/mp3update)

Install optional dependencies:
```bash
sudo apt install vim tmux fzf fastfetch xclip python3-mutagen
```

## Structure

```
~
├── .bashrc              # Main shell config
├── .bash_aliases        # Aliases
├── .bash_functions      # Functions
├── .bash_exports        # Environment variables
├── .bash_prompt         # Prompt config
├── .inputrc             # Readline config
├── .vimrc               # Vim config
├── .gitconfig           # Git config
├── .tmux.conf           # Tmux config
├── .gitignore-dotfiles  # Allowlist for dotfiles repo
├── .dotfiles/           # Bare git repo (metadata only)
├── .dotfile-scripts/
│   └── new-workstation.sh
├── .ssh/
│   └── config.template  # SSH config template
└── .local/bin/
    ├── lorem
    ├── mp3meta
    └── mp3update
```

## License

MIT
