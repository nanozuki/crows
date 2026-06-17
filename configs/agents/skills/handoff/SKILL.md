---
name: handoff
description: Maintains an Obsidian-backed per-branch handoff note to help future sessions resume work on the same git branch across checkouts and worktrees. Use when the user invokes this skill or asks to read, create, or update a handoff note.
---

# Handoff

Per-branch working notes that persist in Obsidian outside a worktree. The goal
is to help the next session — usually future you — resume quickly without re-deriving
context from code and git history alone.

## Preconditions

If not inside a git repository, or if the repository is in detached HEAD with no
current branch, explain the reason and stop without creating a note.

If the handoff path helper cannot determine the first Obsidian vault path, or if
the repository has no `origin` remote URL, explain the reason and stop without
creating a note.

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

Prefer resolving the note path with the helper beside this skill:

```sh
nix run nixpkgs#nodejs -- <path-to-this-skill>/handoff-path.ts
```

The helper prints the absolute handoff note path for the current repository and
branch. Run it from the target repository worktree so Git commands resolve the
current repository and branch. If the helper fails, explain the error and stop
without creating a note.

Treat the printed path as a single filesystem path. Quote it when passing it to
shell commands because vault paths may contain spaces.

- Path:
  `<first-obsidian-vault>/Logbook/<encoded-remote-key>/<encoded-branch-name>.md`
- First Obsidian vault path comes from local Obsidian configuration. On macOS,
  the helper reads `~/Library/Application Support/obsidian/obsidian.json`.
  Use the first configured vault, then store notes under that vault's `Logbook`
  directory.
- Remote URL is the output of `git remote get-url origin`.
- Branch name is the output of `git branch --show-current`.
- Remote key is derived from the remote URL by trimming leading `git@`, trimming
  leading `https://`, trimming trailing `.git`, and replacing `:` with `/`.
- Encode the remote key and branch name as URL percent-encoded UTF-8 bytes for
  separate filesystem path components.
- Create parent directories as needed.

Example: `git@github.com:nanozuki/kiniro.git` becomes
`<first-obsidian-vault>/Logbook/github.com%2Fnanozuki%2Fkiniro/<encoded-branch-name>.md`.

Use the remote key, not the worktree root or local Git directory. Linked
worktrees, reclones, and checkouts on different machines should resolve to the
same handoff note when they use the same `origin` remote and branch name.

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

Notes for branch keys that no longer resolve from the current local repository
are left alone. Do not delete or archive them automatically. If the user asks
to clean up, list the orphan files and let them decide.
