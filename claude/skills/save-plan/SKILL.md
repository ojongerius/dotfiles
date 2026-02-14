---
name: save-plan
description: Save the current plan to ~/.claude/plans/
disable-model-invocation: true
user-invocable: true
---

# Save Plan

Save the plan from the current session to `~/.claude/plans/`, organized by repo and branch.

## Directory structure

```
~/.claude/plans/<repo-name>/<branch-name>/
  YYYY-MM-DD-HHMMSS.md
```

- `<repo-name>`: basename of the git repo root (e.g. `dotfiles`)
- `<branch-name>`: current git branch or worktree branch (e.g. `add/auth-middleware`)

Example: `~/.claude/plans/dotfiles/add/auth-middleware/2026-02-14-143022.md`

## Steps

1. Detect the git repo name (`git rev-parse --show-toplevel | xargs basename`) and current branch (`git branch --show-current`).
2. Create `~/.claude/plans/<repo>/<branch>/` if it doesn't exist.
3. Write the plan as a markdown file named `YYYY-MM-DD-HHMMSS.md` (timestamp at time of save).
4. Include a YAML frontmatter block at the top with:
   - `date`: full ISO 8601 timestamp
   - `repo`: repo name
   - `branch`: branch name
5. Then include the full plan content as markdown.
6. Confirm the file path to the user.
