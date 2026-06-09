---
name: review-github-pr
description: Use this skill when the user asks to review a GitHub pull request, check a PR before merge, read or respond to existing PR review feedback, or submit an approval or change request directly on GitHub. The skill reads the PR description, existing discussion, and branch handoff context, reviews the code locally when possible, and submits the final GitHub review as either APPROVE or REQUEST_CHANGES.
argument-hint: "[PR URL or number]"
---

# Review GitHub PR

Review a GitHub pull request carefully and submit the final review directly to
GitHub instead of posting the full review in chat.

## Inputs

Accept either:

- A pull request URL
- A pull request number

If the input is ambiguous, ask the user to clarify.

## Review outcomes

The final submitted review must be exactly one of:

- `APPROVE`
- `REQUEST_CHANGES`

Do not submit a final `COMMENT` review.

Rules:

- If no findings are found, submit APPROVE.
- If findings are non-blocking, submit `APPROVE` with comments.
- If findings are blocking, submit `REQUEST_CHANGES`.
- If a finding requires human judgment, depends on team preference, involves
  unclear tradeoffs, or would benefit from user guidance before choosing between
  approval and change request, pause and ask the user before submitting
  anything.

## Required review context

Before reviewing code, gather the relevant PR context:

1. PR title
2. PR description / body
3. Existing review summaries
4. Existing line comments
5. Review threads and replies
6. Issue-style comments on the PR conversation
7. Bot comments, including GitHub Copilot or similar automated reviews
8. The current branch handoff context, by invoking the `handoff` skill after the
   PR branch is checked out

Use this context to avoid repeating points that were already raised, resolved,
or convincingly answered.

Only add a new comment when it adds value beyond the existing discussion. Only
submit a review conclusion after considering both the code and the existing PR
conversation.

## Branch and local checkout workflow

Prefer reviewing against the local checked-out code.

After resolving the PR metadata, determine the PR head branch and compare it
with the current local branch.

### If already on the PR head branch

Continue with the review.

### If not on the PR head branch

First check whether the current worktree is dirty.

- If the worktree is clean, check out the PR branch locally.
- If the worktree is dirty, pause and ask the user whether to continue before
  switching branches.
- Do not auto-stash, auto-reset, or clean the worktree.

## Handoff integration

Before reviewing code on the PR branch, invoke the `handoff` skill for the
current branch and read the handoff note it provides. Use that handoff context
as part of the review input.

If there is no handoff note, do not create it unless the user explicitly asks
for that. If there is an existing handoff note, update it following the
`handoff` skill instructions.

## Review method

Review the code using the local repository and the PR diff together.

Check the changed files in context, not only the GitHub patch view. Use
repository tools as needed to inspect nearby code, related files, tests, and
likely impact.

Focus on high-signal review findings such as:

- correctness issues
- regressions
- unsafe assumptions
- missing edge cases
- broken or missing tests
- API misuse
- maintainability issues that materially affect the change
- design choices that introduce avoidable complexity, duplication, coupling, or
  cognitive load, including in control flow, abstraction, state, or
  dependencies
- shortcuts, workarounds, or patch-style fixes that solve the immediate problem
  but leave avoidable technical debt

Review maintainability proactively, not only correctness. Prefer solutions that
reduce unnecessary complexity. Consider whether the change makes the code
harder to understand, extend, test, or safely modify.

If the implementation relies on a shortcut, workaround, or narrow fix, call it
out clearly and recommend a more robust approach when appropriate.

Avoid low-value comments that do not help the author improve the PR.

## Review content format

All review content submitted to GitHub must be in English.

Structure the submitted review as follows:

### Review summary

Include a concise overall assessment explaining:

- the general quality or readiness of the change
- the reason for approval or requested changes
- any important non-blocking follow-ups, if applicable

### Line comments

Prefer line-specific comments whenever possible.

Attach comments directly to the most relevant lines instead of placing
everything in the overall summary.

### Suggested changes

When a fix is concrete and small enough to suggest directly, use GitHub
suggested changes.

Prefer suggestions when they make the author’s next step clearer.

## Submission behavior

Submit the completed review directly to GitHub.

Do not dump the full review into chat unless the user asks for it.

After submission, send a brief chat conclusion that includes:

- the final outcome
- a one-sentence reason

For example:

- `Approved PR #123. Only non-blocking issues were found.`
- `Requested changes on PR #123. The change introduces a blocking correctness issue in the retry flow.`

If the process pauses for user judgment, explain the decision point briefly and
do not submit the review yet.

## Safety and duplication rules

- Do not repeat comments that are already present unless adding a materially new
  point.
- If an existing comment already captures the issue and the discussion is
  settled, avoid posting the same feedback again.
- If you disagree with an existing comment or bot suggestion and that
  disagreement matters to the review outcome, explain that clearly.
- Prefer precise, actionable comments over broad criticism.
- When raising maintainability or design concerns, explain the concrete cost
  and suggest a better approach when possible.
- Keep the review professional, direct, and concise.

## Operational notes

Submit the review on GitHub with:

- a review summary
- line comments
- suggested changes when appropriate
- a final approval or change request state
