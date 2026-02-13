# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal macOS dotfiles managing configs for Zsh (oh-my-zsh), Git, Tmux, and Homebrew. Terminal is Ghostty, IDEs are WebStorm and PyCharm (via JetBrains Toolbox).

## Installation

The main entry point is `install.py` (Python 3), which supports modular flags:

```bash
python3 install.py --dotfiles       # Symlink all dotfiles to ~/
python3 install.py --ghostty        # Link Ghostty config to ~/.config/ghostty/
python3 install.py --brew           # Install Xcode, Homebrew, and packages from Brewfile
python3 install.py --osx            # Run macOS system tweaks (osx/osx.sh)
python3 install.py --oh-my-zsh      # Install Oh-my-zsh
```


## Architecture

```
dotfiles/
├── install.py          # Installer: symlinks dotfiles, installs packages
├── osx/osx.sh          # 600+ lines of macOS defaults customization
├── zsh/.zshrc          # Oh-my-zsh with avit theme
├── git/.gitconfig      # 50+ aliases, GitHub shortcuts, external includes
├── git/.gitignore      # Global gitignore
├── tmux/.tmux.conf     # Tmux with screen-like bindings (C-a prefix)
├── ghostty/config      # Ghostty terminal config
└── brew/Brewfile       # Homebrew packages and casks (incl. Ghostty, Rectangle, JetBrains Toolbox)
```

**Symlink pattern:** `install.py --dotfiles` finds all `.*` files in subdirectories and symlinks them to `~/`, backing up existing files as `.orig`.

**External config hooks:**
- `~/.extra` — sourced by .zshrc for private/machine-specific config
- `~/gitconfig/config` — included by .gitconfig for local overrides
- `~/.tmux.conf.user` — optionally sourced by .tmux.conf
