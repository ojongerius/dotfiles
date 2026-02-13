# Otto's dotfiles

Collection of macOS dotfiles, programs and settings I use.

If you are looking for something that tries to work for everybody, you should probably look at larger projects listed at https://dotfiles.github.io

## Installation
Running _./install.sh_ could:

* Install xcode, Homebrew and programs listed in _brew/Brewfile_.
* Set up Fish shell with Starship prompt.
* Link Ghostty terminal config.
* Link Claude Code skills.
* Run macOS tweaks.

```bash
>./install.sh
Usage: install.sh [OPTIONS]

Options:
  --dotfiles    Symlink all dotfiles to ~/
  --ghostty     Link Ghostty config to ~/.config/ghostty/
  --brew        Install Xcode, Homebrew, and packages from Brewfile
  --osx         Run macOS system tweaks (osx/osx.sh)
  --fish        Set up Fish shell with Starship prompt
  --claude      Link Claude Code skills to ~/.claude/skills/
  --dry-run     Preview what would be done without making changes
  --help        Show this help message
```

## Dotfiles

Create symlinks to these dotfiles by running _install.sh_. Existing files will be renamed with _.orig_ as suffix.

## macOS

Run a whole bunch of macOS tweaks. Taken from [@mathiasbynens](https://github.com/mathiasbynens/dotfiles) with some adjustments.

## Brew

Install xcode, Brew, add taps and Casks. See _brew/Brewfile_ for the list of programs.

## Claude Code

Link Claude Code skills from _claude/skills/_ to _~/.claude/skills/_.

## Fish + Starship

Set up [Fish shell](https://fishshell.com/) with [Starship](https://starship.rs/) prompt. Uses JetBrains Mono Nerd Font for icons. Config files are in _fish/config.fish_ and _starship/starship.toml_.

## Thanks!

*  [Mathias Bynens](https://mathiasbynens.be/) and his fantastic [dotfiles](https://github.com/mathiasbynens/dotfiles).
*  [Yan Pritzker](http://yanpritzker.com/) and his amazing [dotfiles](https://github.com/skwp/dotfiles).
*  [Zach Holman](http://zachholman.com/) and his inspiring [dotfiles](https://github.com/holman/dotfiles)

## Extras

Another nice idea from [@mathiasbynens](https://github.com/mathiasbynens/dotfiles):
Put things that do not belong in a public repository in a _~/.extra.fish_ and let
_fish/config.fish_ source it for you.
