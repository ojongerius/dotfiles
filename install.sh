#!/usr/bin/env bash

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

_symlink() {
    local source="$1" destination="$2"

    # Already linked correctly — nothing to do
    if [ -L "$destination" ] && [ "$(readlink "$destination")" = "$source" ]; then
        echo "INFO: Nothing to do here: $destination LGTM."
        return
    fi

    # Back up existing file/symlink
    if [ -e "$destination" ] || [ -L "$destination" ]; then
        mv "$destination" "${destination}.orig"
        echo "INFO: Created backup ${destination}.orig"
    fi

    ln -s "$source" "$destination"
    echo "INFO: Linked $source to $destination"
}

usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Options:
  --dotfiles    Symlink all dotfiles to ~/
  --ghostty     Link Ghostty config to ~/.config/ghostty/
  --brew        Install Xcode, Homebrew, and packages from Brewfile
  --osx         Run macOS system tweaks (osx/osx.sh)
  --oh-my-zsh   Install Oh-my-zsh
  --claude      Link Claude Code skills to ~/.claude/skills/
  --help        Show this help message
EOF
}

# ---------------------------------------------------------------------------
# Tasks
# ---------------------------------------------------------------------------

do_dotfiles() {
    echo "Working on dotfiles.."
    for dir in "$REPO_DIR"/*/; do
        for file in "$dir".*; do
            [ -e "$file" ] || continue
            name="$(basename "$file")"
            [[ "$name" == "." || "$name" == ".." ]] && continue
            _symlink "$(realpath "$file")" "$HOME/$name"
        done
    done
    touch ~/.extra
}

do_ghostty() {
    echo "Working on Ghostty config.."
    mkdir -p ~/.config/ghostty
    _symlink "$REPO_DIR/ghostty/config" ~/.config/ghostty/config
}

do_brew() {
    echo "Working on Brew and programs.."
    if ! xcode-select -p &>/dev/null; then
        xcode-select --install
    fi
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew bundle --file="$REPO_DIR/brew/Brewfile"
}

do_osx() {
    echo "Working on osx customisations.."
    bash "$REPO_DIR/osx/osx.sh"
}

do_oh_my_zsh() {
    echo "Working on Oh-my-zsh.."
    curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
}

do_claude() {
    echo "Working on Claude Code skills.."
    mkdir -p ~/.claude/skills
    for skill_dir in "$REPO_DIR/claude/skills"/*/; do
        [ -d "$skill_dir" ] || continue
        name="$(basename "$skill_dir")"
        _symlink "$(realpath "$skill_dir")" "$HOME/.claude/skills/$name"
    done
}

# ---------------------------------------------------------------------------
# Main — only runs when executed directly, not when sourced (e.g. by tests)
# ---------------------------------------------------------------------------

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    if [ $# -eq 0 ]; then
        usage
        exit 0
    fi

    for arg in "$@"; do
        case "$arg" in
            --dotfiles)  do_dotfiles ;;
            --ghostty)   do_ghostty ;;
            --brew)      do_brew ;;
            --osx)       do_osx ;;
            --oh-my-zsh) do_oh_my_zsh ;;
            --claude)    do_claude ;;
            --help)      usage ;;
            *)           echo "Unknown option: $arg"; usage; exit 1 ;;
        esac
    done
fi
