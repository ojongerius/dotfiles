# Otto's dotfiles

Collection of dotfiles I use. If you are looking for something that tries to
work for everybody, you should probably look at larger projects listed at
https://dotfiles.github.io

## Dotfiles

Create symlinks to these dotfiles by running ```create_symlinks.py```. Existing files will be renamed with ```.orig``` as suffix.

```create_symlinks.py``` will link Vim plugins unless you pass ```--no-vim-plugins-please``` (a simple ```--no-vim``` will do, too)

```create_symlinks.py``` will link Spectacle preferences unless you pass ```--no-spectacle-please``` (a simple ```--no-spectacle``` will do too), see ```--help``` for more:

```bash
> scripts/create_symlinks.py --help
usage: create_symlinks.py [-h] [--no-vim-plugins-please]
                          [--no-spectacle-please]

optional arguments:
  -h, --help            show this help message and exit
  --no-vim-plugins-please
                        Skip linking Vim plugins.
  --no-spectacle-please
                        Skip linking Spectacle preferences.
```

## Vim plugins

Are submodules in vim/bundle. Runnning ```create_symlinks.py``` will link them
to ~/vim/bundle. Existing directories will be renamed with ```.orig``` as
suffix.

```bash
scripts/create_symlinks.py
```

## Spectacle

Spectacle preferences. Runnning ```create_symlinks.py``` will link it to ```~/Library/Preferences/```. A existing plist will be renamed with ```.orig``` as suffix.

```bash
scripts/create_symlinks.py
```

## OSX

Run a whole bunch of OSX tweaks. Taken from [@mathiasbynens](https://github.com/mathiasbynens/dotfiles) with some adjustments.

```bash
scripts/osx.sh
```

## Thanks!

*  [Mathias Bynens](https://mathiasbynens.be/) and his fantastic [dotfiles](https://github.com/mathiasbynens/dotfiles).
*  [Yan Pritzker](http://yanpritzker.com/) and his amazing [dotfiles](https://github.com/skwp/dotfiles).
*  [Zach Holman](http://zachholman.com/) and his inspiring [dotfiles](https://github.com/holman/dotfiles)

## Extras

Another nice one from [@mathiasbynens](https://github.com/mathiasbynens/dotfiles)):
Put things that do not belong in a public repository in a ```~/.extra``` and let
```zsh/.zshrc``` source it for you.

## Todo

### Bootstrap
* Homebrew
* oh-my-zsh
* Autojump, virtualenvwrapper

### Configure
* Configure IntelliJ
* Make gnu versions of find and sed the default
* Symlink Spectacle
