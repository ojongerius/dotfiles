# Otto's dotfiles

Collection of macOS dotfiles, programs and settings I use.

If you are looking for something that tries to work for everybody, you should probably look at larger projects listed at https://dotfiles.github.io

## Installation
Running _./install.py_ could:

* Install xcode, Homebrew and programs listed in _brew/Brewfile_.
* Run macOS tweaks.

```bash
>./install.py
usage: install.py [-h] [--dotfiles] [--brew] [--osx] [--oh-my-zsh]

optional arguments:
  -h, --help     show this help message and exit
  --dotfiles     Install dotfiles
  --brew         Install Brew, Brewdle and packages
  --osx          Tweak osx
  --oh-my-zsh    Install Oh-my-zsh
```

## Dotfiles

Create symlinks to these dotfiles by running _install.py_. Existing files will be renamed with _.orig_ as suffix.

## macOS

Run a whole bunch of macOS tweaks. Taken from [@mathiasbynens](https://github.com/mathiasbynens/dotfiles) with some adjustments.

## Brew

Install xcode, Brew, add taps and Casks. See _brew/Brewfile_ for the list of programs.

## Oh-my-zsh

Install oh-my-zsh.

## Thanks!

*  [Mathias Bynens](https://mathiasbynens.be/) and his fantastic [dotfiles](https://github.com/mathiasbynens/dotfiles).
*  [Yan Pritzker](http://yanpritzker.com/) and his amazing [dotfiles](https://github.com/skwp/dotfiles).
*  [Zach Holman](http://zachholman.com/) and his inspiring [dotfiles](https://github.com/holman/dotfiles)

## Extras

Another nice idea from [@mathiasbynens](https://github.com/mathiasbynens/dotfiles)):
Put things that do not belong in a public repository in a _~/.extra_ and let
_zsh/.zshrc_ source it for you.
