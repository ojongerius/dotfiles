# Otto's dotfiles

Collection of dotfiles I use. If you are looking for something that tries to
work for everybody, you should probably look at larger projects listed at
https://dotfiles.github.io

## Dotfiles

Create symlinks to these dotfiles by running create_symlinks.py. Existing files will be renamed as with ```.orig``` as suffix.

``scripts/create_symlinks.py``

## OSX

Run a whole bunch of OSX customisations. Taken from [@mathiasbynens](https://github.com/mathiasbynens/dotfiles) 
with some customisations.

``scripts/osx.sh``

## Thanks

*  [@mathiasbynens](https://github.com/mathiasbynens/dotfiles)
*  [@skwp](https://github.com/skwp/dotfiles)
*  [@holman](https://github.com/holman/dotfiles)

## Extras

Another nice one from [@mathiasbynens](https://github.com/mathiasbynens/dotfiles)):
Put things that do not belong in a public repository in a ```~.extra``` and let
```zsh/.zshrc``` source it for you.

## Todo

### Bootstrap
* Homebrew
* oh-my-zsh
* Vim plugins: pathogen, syntastic, jedi-vim, nerdtree, vim-flake8,
  vim-colors-solarized vim-tmux-navigator.git
* Autojump, virtualenvwrapper

### Configure
* Configure IntelliJ
* Make gnu versions of find and sed the default
* Symlink Spectacle

