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
    [ -f "${dest}.orig" ]
    [ "$(cat "${dest}.orig")" = "old" ]
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
    [ -L "${dest}.orig" ]
    [ "$(readlink "${dest}.orig")" = "$wrong" ]
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

@test "backup via _symlink renames file with .orig suffix" {
    local dest="$TEST_DIR/myfile"
    local src="$TEST_DIR/newsrc"
    echo "content" > "$dest"
    echo "new" > "$src"

    _symlink "$src" "$dest"

    [ -L "$dest" ]
    [ -f "${dest}.orig" ]
    [ "$(cat "${dest}.orig")" = "content" ]
}
