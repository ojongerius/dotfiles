#!/usr/bin/env bats

setup() {
    TEST_DIR="$BATS_TEST_TMPDIR"
    source "$BATS_TEST_DIRNAME/install.sh"
}

# --- _symlink tests (ported from TestCreateLinks) ---

@test "_symlink creates symlink to destination" {
    local src="$TEST_DIR/source"
    local dest="$TEST_DIR/dest"
    echo "data" > "$src"

    _symlink "$src" "$dest"

    [ -L "$dest" ]
    [ "$(readlink "$dest")" = "$src" ]
}

@test "_symlink skips when symlink already correct" {
    local src="$TEST_DIR/source"
    local dest="$TEST_DIR/dest"
    echo "data" > "$src"
    ln -s "$src" "$dest"

    run _symlink "$src" "$dest"

    [ "$status" -eq 0 ]
    [[ "$output" == *"LGTM"* ]]
    [ -L "$dest" ]
    [ "$(readlink "$dest")" = "$src" ]
}

@test "_symlink backs up existing file and creates symlink" {
    local src="$TEST_DIR/source"
    local dest="$TEST_DIR/dest"
    echo "new" > "$src"
    echo "old" > "$dest"

    _symlink "$src" "$dest"

    [ -L "$dest" ]
    [ "$(readlink "$dest")" = "$src" ]
    local backup
    backup=$(ls "${dest}".orig.* 2>/dev/null)
    [ -f "$backup" ]
    [ "$(cat "$backup")" = "old" ]
}

@test "_symlink backs up existing wrong symlink and creates correct one" {
    local src="$TEST_DIR/source"
    local wrong="$TEST_DIR/wrong"
    local dest="$TEST_DIR/dest"
    echo "right" > "$src"
    echo "wrong" > "$wrong"
    ln -s "$wrong" "$dest"

    _symlink "$src" "$dest"

    [ -L "$dest" ]
    [ "$(readlink "$dest")" = "$src" ]
    local backup
    backup=$(ls "${dest}".orig.* 2>/dev/null)
    [ -L "$backup" ]
    [ "$(readlink "$backup")" = "$wrong" ]
}

# --- do_dotfiles test (ported from TestProccessDotfiles) ---

@test "do_dotfiles only links dotfiles, ignores regular files" {
    local fake_home="$TEST_DIR/home"
    local repo="$TEST_DIR/repo"
    local subdir="$repo/mydir"
    mkdir -p "$fake_home" "$subdir"

    echo "dotfile" > "$subdir/.config"
    echo "regular" > "$subdir/readme"

    # Override HOME and REPO_DIR so do_dotfiles uses our temp dirs
    HOME="$fake_home"
    REPO_DIR="$repo"

    do_dotfiles

    [ -L "$fake_home/.config" ]
    [ ! -e "$fake_home/readme" ]
    [ -f "$fake_home/.extra" ]
}

# --- backup test (ported from TestBackup) ---

# --- do_fish tests ---

@test "do_fish symlinks fish config, functions, and starship config" {
    local fake_home="$TEST_DIR/home"
    mkdir -p "$fake_home/.config"

    local repo="$TEST_DIR/repo"
    mkdir -p "$repo/fish/functions" "$repo/starship"
    echo "fish cfg" > "$repo/fish/config.fish"
    echo "starship cfg" > "$repo/starship/starship.toml"
    echo "function test; end" > "$repo/fish/functions/test.fish"

    HOME="$fake_home"
    REPO_DIR="$repo"
    # Stub out chsh/sudo/grep to avoid system changes in tests
    chsh() { :; }
    sudo() { :; }
    export -f chsh sudo

    do_fish

    [ -L "$fake_home/.config/fish/config.fish" ]
    [ -L "$fake_home/.config/fish/functions" ]
    [ -L "$fake_home/.config/starship.toml" ]
    [ -f "$fake_home/.extra.fish" ]
}

@test "backup via _symlink renames file with .orig timestamp suffix" {
    local dest="$TEST_DIR/myfile"
    local src="$TEST_DIR/newsrc"
    echo "content" > "$dest"
    echo "new" > "$src"

    _symlink "$src" "$dest"

    [ -L "$dest" ]
    local backup
    backup=$(ls "${dest}".orig.* 2>/dev/null)
    [ -f "$backup" ]
    [ "$(cat "$backup")" = "content" ]
}

# --- do_ghostty tests ---

@test "do_ghostty creates config directory and symlinks config" {
    local fake_home="$TEST_DIR/home"
    mkdir -p "$fake_home"

    HOME="$fake_home"

    do_ghostty

    [ -d "$fake_home/.config/ghostty" ]
    [ -L "$fake_home/.config/ghostty/config" ]
}

@test "do_ghostty is idempotent" {
    local fake_home="$TEST_DIR/home"
    mkdir -p "$fake_home"

    HOME="$fake_home"

    do_ghostty
    run do_ghostty

    [ "$status" -eq 0 ]
    [[ "$output" == *"LGTM"* ]]
}

# --- do_claude tests ---

@test "do_claude symlinks skill directories" {
    local fake_home="$TEST_DIR/home"
    local repo="$TEST_DIR/repo"
    mkdir -p "$fake_home" "$repo/claude/skills/my-skill"
    echo "skill" > "$repo/claude/skills/my-skill/SKILL.md"

    HOME="$fake_home"
    REPO_DIR="$repo"

    do_claude

    [ -d "$fake_home/.claude/skills" ]
    [ -L "$fake_home/.claude/skills/my-skill" ]
}

@test "do_claude is idempotent" {
    local fake_home="$TEST_DIR/home"
    local repo="$TEST_DIR/repo"
    mkdir -p "$fake_home" "$repo/claude/skills/my-skill"
    echo "skill" > "$repo/claude/skills/my-skill/SKILL.md"

    HOME="$fake_home"
    REPO_DIR="$repo"

    do_claude
    run do_claude

    [ "$status" -eq 0 ]
    [[ "$output" == *"LGTM"* ]]
}

# --- dry-run tests ---

@test "dry-run mode prevents _symlink from creating links" {
    local src="$TEST_DIR/source"
    local dest="$TEST_DIR/dest"
    echo "data" > "$src"

    DRY_RUN=true
    run _symlink "$src" "$dest"

    [ "$status" -eq 0 ]
    [[ "$output" == *"DRY-RUN"* ]]
    [ ! -e "$dest" ]
}

@test "dry-run mode prevents _symlink from backing up files" {
    local src="$TEST_DIR/source"
    local dest="$TEST_DIR/dest"
    echo "new" > "$src"
    echo "old" > "$dest"

    DRY_RUN=true
    run _symlink "$src" "$dest"

    [ "$status" -eq 0 ]
    [[ "$output" == *"DRY-RUN"* ]]
    # Original file should be untouched
    [ -f "$dest" ]
    [ "$(cat "$dest")" = "old" ]
}
