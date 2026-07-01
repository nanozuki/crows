---
name: agent-settings
description: Configure local agent settings. Use when the user directly calls skill.
---

# Agent Settings

This is a cross-agent and sync-friendly checklist for agent configuration. Set
up user-specific configuration to fit requirements below as much as possible:

- Show these information in status bar, footer, or equivalent area:
  - model name
  - current status, such as `ready` or `working`
  - context window usage percentage
  - current token usage percentage
  - weekly token usage percentage
  - current worktree directory (if we are not in main worktree)
- disable auto-compact / auto-compaction
- show less text for thinking
- show less text for diff

## Principles

Because this is a cross-agent skill, the description and terminology may not
match your documentation perfectly. So, before you start, check the official
documentation and normalize the requested terms to your official terminology.

Perfer native support over script-based customization.

If you cannot find a acurate way to implement a requirement, skip it and report
it in the output. Don't fabricate data or make up a solution.

## Agent Specific

### Pi

- Pi does not provide a native weekly token usage percentage in the footer, use
  `@calesennett/pi-codex-usage` to get usage for codex.

## Output format

After acting, report:

- what you changed
- exact files changed
- which requests were completed
- which requests were unsupported or unverified
- whether restart, reload, or re-login is needed
