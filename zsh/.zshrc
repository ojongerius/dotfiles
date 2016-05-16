# For oh-my-zsh
export ZSH=$HOME/.oh-my-zsh

# Solarized
export SOLARIZED_THEME=dark

# COPYFILE_DISABLE, don't copy extended attributes into tarballs
export COPYFILE_DISABLE=1

# Theme
ZSH_THEME="agnoster"

ENABLE_CORRECTION="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
export KEYTIMEOUT=1

# Plugins to use
plugins=(git, vi-mode, golang)
source $ZSH/oh-my-zsh.sh
bindkey "^R" history-incremental-search-backward

# Please don't share history
unsetopt share_history

CHARLIE_PATH="/Users/${USER}/atlassian/agent-charlie/bin:/Users/${USER}/atlassian/bin"
PACKER_PATH="/Applications/Packer/bin"
TERRAFORM_PATH="/Applications/terraform"
ATLASSIAN_SDK_PATH="/usr/local/Cellar/atlassian-plugin-sdk/4.2.12/libexec"
ANDROID_DEV_PATH="Users/${USER}/dev/android/adt-bundle-mac-x86_64-20140321/sdk/tools:/Users/${USER}/dev/android/adt-bundle-mac-x86_64-20140321/sdk/platform-tools"
export PATH=$PATH:$CHARLIE_PATH:$PACKER_PATH:$TERRAFORM_PATH:$ATLASSIAN_SDK_PATH:$ANDROID_DEV_PATH

# Python dev
[[ -f /usr/local/bin/virtualenvwrapper.sh ]] && source /usr/local/bin/virtualenvwrapper.sh
alias ipy="python -c 'import IPython; IPython.terminal.ipapp.launch_new_instance()'" # Make ipython respect virtualenv

# Go dev
export GOPATH=$HOME/gocode
export PATH=$PATH:$GOPATH/bin:/usr/local/opt/go/libexec/bin

# Brew
export PATH=/usr/local/bin:/usr/local/sbin:$PATH # Prefer brew over native
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# Java
export JAVA_HOME=$(/usr/libexec/java_home)
export PATH=${JAVA_HOME}/bin:$PATH

# Vagrant
#export VAGRANT_DELTA_PROVISION=true # Default to delta provisioning

# Autojump
[[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh

# Show us a fortune
command -v foo >/dev/null 2>&1 && fortune

alias vi=/usr/local/bin/vim

# Extra settings not in this repository
. ~/.extra

eval "$(docker-machine env default)"
