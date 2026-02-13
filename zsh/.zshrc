# For oh-my-zsh
export ZSH=$HOME/.oh-my-zsh

# COPYFILE_DISABLE, don't copy extended attributes into tarballs
export COPYFILE_DISABLE=1

# Theme
ZSH_THEME="avit"

ENABLE_CORRECTION="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Plugins to use
plugins=(git)
source $ZSH/oh-my-zsh.sh
bindkey "^R" history-incremental-search-backward

# Please don't share history
unsetopt share_history

# Brew
export PATH=/opt/homebrew/bin:/opt/homebrew/sbin:$PATH # Prefer brew over native

# Autojump
[[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh

# Show us a fortune
command -v fortune >/dev/null 2>&1 && fortune

# disable "sure you want to delete all the files"
setopt rmstarsilent

# Extra settings not in this repository
. ~/.extra
