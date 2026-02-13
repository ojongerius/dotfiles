# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal macOS dotfiles managing configs for Fish (with Starship prompt), Git, Tmux, and Homebrew. Terminal is Ghostty, IDEs are WebStorm and PyCharm (via JetBrains Toolbox).

## Installation

The main entry point is `install.sh` (Bash), which supports modular flags:

```bash
./install.sh --dotfiles       # Symlink all dotfiles to ~/
./install.sh --ghostty        # Link Ghostty config to ~/.config/ghostty/
./install.sh --brew           # Install Xcode, Homebrew, and packages from Brewfile
./install.sh --osx            # Run macOS system tweaks (osx/osx.sh)
./install.sh --fish           # Set up Fish shell with Starship prompt
./install.sh --claude         # Link Claude Code skills to ~/.claude/skills/
```


## Architecture

```
dotfiles/
├── install.sh          # Installer: symlinks dotfiles, installs packages
├── osx/osx.sh          # 600+ lines of macOS defaults customization
├── fish/config.fish    # Fish shell config (Starship prompt, autojump, etc.)
├── starship/starship.toml # Starship prompt configuration
├── git/.gitconfig      # 50+ aliases, GitHub shortcuts, external includes
├── git/.gitignore      # Global gitignore
├── tmux/.tmux.conf     # Tmux with screen-like bindings (C-a prefix)
├── ghostty/config      # Ghostty terminal config
├── claude/skills/      # Claude Code skills (symlinked to ~/.claude/skills/)
└── brew/Brewfile       # Homebrew packages and casks (incl. Ghostty, Rectangle, JetBrains Toolbox)
```

**Symlink pattern:** `install.sh --dotfiles` finds all `.*` files in subdirectories and symlinks them to `~/`, backing up existing files as `.orig`.

**External config hooks:**
- `~/.extra.fish` — sourced by config.fish for private/machine-specific config
- `~/gitconfig/config` — included by .gitconfig for local overrides
- `~/.tmux.conf.user` — optionally sourced by .tmux.conf
