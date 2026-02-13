# COPYFILE_DISABLE, don't copy extended attributes into tarballs
set -gx COPYFILE_DISABLE 1

# Brew
fish_add_path /opt/homebrew/bin /opt/homebrew/sbin

# Autojump
if test -f (brew --prefix)/share/autojump/autojump.fish
    source (brew --prefix)/share/autojump/autojump.fish
end

# Show us a fortune
if type -q fortune
    fortune
end

# Starship prompt
starship init fish | source

# Extra settings not in this repository
if test -f ~/.extra.fish
    source ~/.extra.fish
end
