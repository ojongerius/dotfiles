# Otto's dotfiles

Collection of OSX centered dotfiles, programs and settings I use.

If you are looking for something that tries to work for everybody, you should probably look at larger projects listed at https://dotfiles.github.io

## Installation
Make sure you have cloned this repository with --recursive, or run `git
submodule update --init --recursive` to fetch its submodules.

Running _./install.py_ could:

* Install xcode, Homebrew and programs listed in _brew/Brewfile_.
* Clone and link Vim plugins.
* Link Spectacle preferences.
* Run OSX tweaks, color schemes for Iterm2.

Beware; the Zsh theme I use, and Vim powerline depend on a powerline patched font to look good. The font is installed via the Brewfile, but you'll need to set your iTerm2 profile to use it this. You'll have to manually go to settings > general, tick "Load preferences from a custom folder or URL" and point to "$LOCATION_OF_THIS_REPO/dotfiles/iTerm2/com.googlecode.iterm2.plist"
Until I take the time to do this in Applescript.

```bash
>./install.py
usage: install.py [-h] [--dotfiles] [--vim-plugins] [--spectacle] [--brew]
                  [--osx]

optional arguments:
  -h, --help     show this help message and exit
  --dotfiles     Install dotfiles
  --vim-plugins  Linking Vim plugins
  --spectacle    Link Spectacle preferences
  --brew         Install Brew, Brewdle and packages
  --osx          Tweak osx
```

## Dotfiles

Create symlinks to these dotfiles by running _install.py_. Existing files will be renamed with _.orig_ as suffix.

## Vim plugins

Are submodules in vim/bundle. Runnning _install.py_ will link them to _~/vim/bundle_. Existing directories will be renamed with _.orig_ as suffix.

## Spectacle

Spectacle preferences. Runnning _install.py_ will link it to _~/Library/Preferences/_. An existing plist will be renamed with _.orig_ as suffix.

## OSX

Run a whole bunch of OSX tweaks. Taken from [@mathiasbynens](https://github.com/mathiasbynens/dotfiles) with some adjustments.

## Brew

Install xcode, Brew, add taps and Casks. See _brew/Brewfile_ for the list of programs. You can update this file by running ```brew brewdle dump```. See [the project page](https://github.com/Homebrew/homebrew-brewdler) for more information.

## Oh-my-zsh

Install oh-my-zsh, nothing more than ```curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh```.

## Thanks!

*  [Mathias Bynens](https://mathiasbynens.be/) and his fantastic [dotfiles](https://github.com/mathiasbynens/dotfiles).
*  [Yan Pritzker](http://yanpritzker.com/) and his amazing [dotfiles](https://github.com/skwp/dotfiles).
*  [Zach Holman](http://zachholman.com/) and his inspiring [dotfiles](https://github.com/holman/dotfiles)

## Extras

Another nice idea from [@mathiasbynens](https://github.com/mathiasbynens/dotfiles)):
Put things that do not belong in a public repository in a _~/.extra_ and let
_zsh/.zshrc_ source it for you.

## Todo

### Configure
* Configure IntelliJ
* Make gnu versions of find and sed the default
