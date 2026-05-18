---
name: handoff
description: Maintains a per-branch handoff note under .handoff/<branch>.md to help future sessions resume work on the same git branch. Use when the user invokes this skill or asks to read, create, or update a handoff note.
---

# Handoff

Per-branch working notes that travel with a git branch inside a worktree. The
goal is to help the next session — usually future you — resume quickly without
re-deriving context from code and git history alone.

## Preconditions

If not inside a git repository, or if the repository is in detached HEAD with no
current branch, explain the reason and stop without creating a note.

## When to act

When invoked, read the current branch's handoff note first if one exists. If it
does not exist, create one immediately using the current session context and any
user instructions. Update it incrementally during a session whenever something
happens that the next session would want to know:

- A decision (chosen approach, rejected alternative + why)
- A change of direction
- A blocker or open question worth carrying over
- A non-obvious finding about the codebase or environment

Do not record routine edits, trivial steps, or anything already obvious from
`git log` or `git diff`. The note is signal, not a journal.

## Location

- Path: `<worktree-root>/.handoff/<branch-name>.md`
- `<worktree-root>` is the output of `git rev-parse --show-toplevel`.
- Branch name is the output of `git branch --show-current`.
- If the branch name contains `/` (e.g. `feat/foo`), keep the slash as a
  subdirectory: `.handoff/feat/foo.md`.
- Create parent directories as needed.

Whether `.handoff/` is committed or gitignored is up to the project — do not
change that on the user's behalf.

## Note structure

Use this template for a new note. Keep sections in this order. Omit a section's
body if empty, but keep the heading so future updates have a place to land.

```markdown
# <branch>

Created: <YYYY-MM-DD HH:MM> Updated: <YYYY-MM-DD HH:MM>

## Goal

What this branch is meant to achieve.

## Context

External pointers: issue / PR links, related discussions, background. Where this
work came from.

## Status

Current state and the immediate next step.

## Key Decisions

Choices made, including options considered and rejected, with brief reasons.

## Open Questions

Unresolved questions or blockers to carry into the next session.
```

## Update rules

- Edit in place; do not append a changelog of edits.
- Set `Created:` when creating a new note.
- Refresh `Updated:` on every write.
- Remove information once it becomes stale or obsolete. The note should
  reflect the present, not accumulate history.
- Keep entries terse. Prefer bullets over paragraphs.

## Orphan notes

Notes for branches that no longer exist are left alone. Do not delete or
archive them automatically. If the user asks to clean up, list the orphan
files and let them decide.
