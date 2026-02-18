#!/usr/bin/env bash

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRY_RUN=false

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

_symlink() {
    local source="$1" destination="$2"

    if $DRY_RUN; then
        echo "DRY-RUN: Would link $source -> $destination"
        return
    fi

    # Already linked correctly — nothing to do
    if [ -L "$destination" ] && [ "$(readlink "$destination")" = "$source" ]; then
        echo "INFO: Nothing to do here: $destination LGTM."
        return
    fi

    # Back up existing file/symlink
    if [ -e "$destination" ] || [ -L "$destination" ]; then
        local backup
        backup="${destination}.orig.$(date +%Y%m%d%H%M%S)"
        mv "$destination" "$backup"
        echo "INFO: Created backup $backup"
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
  --fish        Set up Fish shell with Starship prompt
  --claude      Link Claude Code skills to ~/.claude/skills/
  --dry-run     Preview what would be done without making changes
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
    touch "$HOME/.extra"
}

do_ghostty() {
    echo "Working on Ghostty config.."
    mkdir -p "$HOME/.config/ghostty"
    _symlink "$(realpath "$REPO_DIR/ghostty/config")" "$HOME/.config/ghostty/config"
}

do_brew() {
    echo "Working on Brew and programs.."
    if $DRY_RUN; then
        echo "DRY-RUN: Would install Xcode CLI tools, Homebrew, and packages from Brewfile"
        return
    fi
    if ! xcode-select -p &>/dev/null; then
        xcode-select --install
    fi
    if ! command -v brew &>/dev/null; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew bundle --file="$REPO_DIR/brew/Brewfile"
}

do_osx() {
    echo "Working on osx customisations.."
    if $DRY_RUN; then
        echo "DRY-RUN: Would run macOS system tweaks from osx/osx.sh"
        return
    fi
    bash "$REPO_DIR/osx/osx.sh"
}

do_fish() {
    echo "Working on Fish shell setup.."
    mkdir -p "$HOME/.config/fish"
    _symlink "$(realpath "$REPO_DIR/fish/config.fish")" "$HOME/.config/fish/config.fish"
    _symlink "$(realpath "$REPO_DIR/fish/functions")" "$HOME/.config/fish/functions"
    _symlink "$(realpath "$REPO_DIR/starship/starship.toml")" "$HOME/.config/starship.toml"
    touch "$HOME/.extra.fish"

    local fish_path
    fish_path="$(command -v fish || true)"
    if [ -n "$fish_path" ]; then
        if ! grep -qx "$fish_path" /etc/shells; then
            echo "$fish_path" | sudo tee -a /etc/shells
        fi
        if [ "$SHELL" != "$fish_path" ]; then
            chsh -s "$fish_path"
        fi
    fi
}

do_claude() {
    echo "Working on Claude Code skills.."
    mkdir -p "$HOME/.claude/skills"
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
            --dry-run)   DRY_RUN=true ;;
            --dotfiles)  do_dotfiles ;;
            --ghostty)   do_ghostty ;;
            --brew)      do_brew ;;
            --osx)       do_osx ;;
            --fish)      do_fish ;;
            --claude)    do_claude ;;
            --help)      usage ;;
            *)           echo "Unknown option: $arg"; usage; exit 1 ;;
        esac
    done
fi
