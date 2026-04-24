---
name: copilot-pr-review
description: Request a GitHub Copilot code review on the current branch's pull request, wait for Copilot to post the review, then report the issues it found and offer to fix them. Use this skill whenever the user wants a Copilot review of their PR — phrases like "get a copilot review", "have copilot review this", "ask copilot to look at the PR", "request copilot review", "run copilot on this branch", or anything else that implies they want Copilot's automated feedback on an open PR. Trigger even if the user doesn't say the word "skill".
---

# Copilot PR Review

Request a Copilot review on the current branch's PR, wait for it to land, then surface what Copilot flagged and offer to fix it.

## Flow

1. Identify the PR for the current branch.
2. Record a baseline so you can tell when the new review arrives.
3. Request the Copilot review.
4. Wait 2 minutes (reviews essentially never finish faster — polling earlier just wastes API calls and adds noise).
5. Poll every 15 seconds for up to 3 more minutes (5 minutes total).
6. Fetch the review, summary + inline comments, and report.
7. Offer to fix the issues.

## Step 1 — Identify the PR

```
PR_NUMBER=$(gh pr view --json number --jq .number)
REPO=$(gh repo view --json nameWithOwner --jq .nameWithOwner)
```

If `gh pr view` fails (no open PR for the branch), stop and tell the user — they need to open a PR first. Don't try to guess which PR they meant.

## Step 2 — Capture the baseline

Copilot may have reviewed this PR before. Record the most recent Copilot review timestamp so later you can recognise *the new one*:

```
BASELINE=$(gh api "repos/$REPO/pulls/$PR_NUMBER/reviews" \
  --jq '[.[] | select(.user.login == "Copilot" or .user.login == "copilot-pull-request-reviewer[bot]")] | max_by(.submitted_at) | .submitted_at // ""')
```

The bot login has shown up as both `Copilot` and `copilot-pull-request-reviewer[bot]` in different contexts — match either. `BASELINE` will be empty if Copilot has never reviewed this PR.

## Step 3 — Request the review

Use the `mcp__github-audited__request_copilot_review` tool with the PR's owner, repo, and number. That dispatches the review asynchronously — it returns immediately.

## Step 4 — Initial wait

```
sleep 120
```

Two minutes. This isn't arbitrary — Copilot reviews basically never land in under a minute, and polling immediately clutters the transcript and burns API budget for no reason.

## Step 5 — Poll

```
END=$(( $(date +%s) + 180 ))
FOUND=""
while [ $(date +%s) -lt $END ]; do
  LATEST=$(gh api "repos/$REPO/pulls/$PR_NUMBER/reviews" \
    --jq '[.[] | select(.user.login == "Copilot" or .user.login == "copilot-pull-request-reviewer[bot]")] | max_by(.submitted_at)')
  LATEST_TS=$(echo "$LATEST" | jq -r '.submitted_at // ""')
  if [ -n "$LATEST_TS" ] && [ "$LATEST_TS" != "$BASELINE" ]; then
    FOUND="$LATEST"
    break
  fi
  sleep 15
done
```

If the loop exits without finding a new review, tell the user it timed out after 5 minutes and suggest re-running the skill shortly. Don't spin forever — Copilot can silently no-op (e.g. on draft PRs or huge diffs) and you don't want to trap the user.

## Step 6 — Fetch and report

From the review found above, extract the `id` and `body` (Copilot's top-level summary). Then pull the inline comments for that review:

```
REVIEW_ID=$(echo "$FOUND" | jq -r .id)
gh api "repos/$REPO/pulls/$PR_NUMBER/reviews/$REVIEW_ID/comments"
```

Present a compact report in this shape:

```
## Copilot review

<summary — the review body, trimmed of boilerplate>

## Issues (<count>)

### path/to/file.ts
- L42: <comment body, one or two lines>
- L57: <…>

### path/to/other.py
- L10: <…>
```

If Copilot left no inline comments, say so plainly — "Copilot reviewed the PR and didn't flag anything." That's a real, useful result. Don't pad it with filler.

## Step 7 — Offer to fix

End the report with a single-line ask, e.g.: *"Want me to address any of these? Pick which ones or say 'all'."*

Do **not** start editing files before the user confirms. The point of this skill is to surface feedback, not to silently rewrite the branch.

## Notes

- If a Copilot review is already pending (visible in `requested_reviewers` on the PR), skip Step 3 and go straight to waiting — re-requesting serves no purpose and may reset the clock.
- The MCP tool name assumes the standard GitHub MCP server is configured. If `mcp__github-audited__request_copilot_review` isn't available, fall back to `gh api -X POST "repos/$REPO/pulls/$PR_NUMBER/requested_reviewers" -f 'reviewers[]=copilot-pull-request-reviewer'` and note the fallback to the user.
- Timestamps from the API are ISO 8601 strings — compare as strings, not by parsing.
