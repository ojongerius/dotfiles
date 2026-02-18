# COPYFILE_DISABLE, don't copy extended attributes into tarballs
set -gx COPYFILE_DISABLE 1

# Brew
fish_add_path /opt/homebrew/bin /opt/homebrew/sbin

# Zoxide
if type -q zoxide
    zoxide init fish | source
end

# Show us a fortune
if type -q fortune
    fortune
end

# Starship prompt
starship init fish | source

# Aliases
alias webstorm "open -a /Users/ottojongerius/Applications/WebStorm.app"

# Extra settings not in this repository
if test -f ~/.extra.fish
    source ~/.extra.fish
end
