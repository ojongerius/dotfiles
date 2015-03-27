# Otto's dotfiles

Collection of dotfiles I use. If you are looking for something that tries to
work for everybody, you should probably look at larger projects listed at
https://dotfiles.github.io

## Dotfiles

Create symlinks to these dotfiles by running ```create_symlinks.py```. Existing files will be renamed with ```.orig``` as suffix. This will link Vim plugins unless you pass ```--no-vim-plugins-please``` (a simple ```--no``` will do too), like so:

```bash
scripts/create_symlinks.py --no-vim-plugins-please
```

## Vim plugins

Are submodules in vim/bundle. Runnning ```create_symlinks.py``` will link them
to ~/vim/bundle. Existing directories will be renamed with ```.orig``` as
suffix.

```bash
scripts/create_symlinks.py
```

## OSX

Run a whole bunch of OSX customisations. Taken from [@mathiasbynens](https://github.com/mathiasbynens/dotfiles) 
with some customisations.

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
* Vim plugins: pathogen, syntastic, jedi-vim, nerdtree, vim-flake8,
  vim-colors-solarized vim-tmux-navigator.git
* Autojump, virtualenvwrapper

### Configure
* Configure IntelliJ
* Make gnu versions of find and sed the default
* Symlink Spectacle

