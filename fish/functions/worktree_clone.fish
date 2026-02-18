function worktree_clone --description "Clone a repo as a bare worktree setup"
    if test (count $argv) -lt 1
        echo "Usage: worktree_clone <repo-url> [directory]"
        return 1
    end

    set -l repo_url $argv[1]

    # Derive project name from URL (strip .git suffix and path)
    if test (count $argv) -ge 2
        set -l dir_name $argv[2]
    else
        set -l dir_name (string replace -r '\.git$' '' (basename $repo_url))
    end

    if test -d $dir_name
        echo "Error: directory '$dir_name' already exists"
        return 1
    end

    mkdir -p $dir_name
    echo "Cloning $repo_url into $dir_name/.bare ..."
    git clone --bare $repo_url $dir_name/.bare; or begin
        rm -rf $dir_name
        return 1
    end

    # Point .git to the bare repo
    echo "gitdir: ./.bare" >$dir_name/.git

    # Detect the default branch from the remote
    set -l default_branch (git -C $dir_name/.bare symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | string replace 'refs/remotes/origin/' '')
    if test -z "$default_branch"
        set default_branch main
        echo "Warning: could not detect default branch, falling back to 'main'"
    end

    # Configure remote fetch so all branches are visible
    git -C $dir_name/.bare config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"

    # Create the worktree for the default branch
    git -C $dir_name worktree add $default_branch $default_branch

    echo "Done! cd $dir_name/$default_branch to get started."
end
