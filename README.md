# Otto's dotfiles

Personal macOS dotfiles managing configs for Fish, Starship, Git, Tmux, Ghostty, and more.

## What's included

| Tool | Config | Purpose |
|------|--------|---------|
| [Fish](https://fishshell.com/) | `fish/config.fish` | Shell |
| [Starship](https://starship.rs/) | `starship/starship.toml` | Prompt with Nerd Font icons |
| [Ghostty](https://ghostty.org/) | `ghostty/config` | Terminal |
| Git | `git/.gitconfig` | 50+ aliases and GitHub shortcuts |
| Tmux | `tmux/.tmux.conf` | Terminal multiplexer (`C-a` prefix) |
| [Homebrew](https://brew.sh/) | `brew/Brewfile` | Package management |
| macOS | `osx/osx.sh` | System defaults tweaks |
| [Claude Code](https://claude.ai/code) | `claude/skills/` | AI assistant skills |

## Quick start

```bash
git clone https://github.com/ojongerius/dotfiles.git
cd dotfiles
./install.sh --dotfiles --fish --ghostty --brew --osx --claude
```

## Install options

Each flag can be run independently or combined. Add `--dry-run` to preview changes.

```
--dotfiles    Symlink all dotfiles to ~/
--ghostty     Link Ghostty config to ~/.config/ghostty/
--brew        Install Xcode, Homebrew, and packages from Brewfile
--osx         Run macOS system tweaks (osx/osx.sh)
--fish        Set up Fish shell with Starship prompt
--claude      Link Claude Code skills to ~/.claude/skills/
--dry-run     Preview what would be done without making changes
--help        Show help message
```

Existing files are backed up with a `.orig` suffix before being replaced.

## Modern CLI replacements

Installed via Brewfile — use these instead of the defaults:

| Use | Instead of |
|-----|------------|
| `eza` | `ls` |
| `bat` | `cat` |
| `rg` | `grep` |
| `fd` | `find` |
| `delta` | `diff` (auto-used as git pager) |

## Customization

These files are sourced/included automatically but kept out of version control:

- **`~/.extra.fish`** — private or machine-specific Fish config (sourced by `config.fish`)
- **`~/gitconfig/config`** — local Git overrides (included by `.gitconfig`)
- **`~/.tmux.conf.user`** — local Tmux overrides (sourced by `.tmux.conf`)

## Thanks

- [Mathias Bynens](https://mathiasbynens.be/) and his [dotfiles](https://github.com/mathiasbynens/dotfiles)
- [Yan Pritzker](http://yanpritzker.com/) and his [dotfiles](https://github.com/skwp/dotfiles)
- [Zach Holman](http://zachholman.com/) and his [dotfiles](https://github.com/holman/dotfiles)
