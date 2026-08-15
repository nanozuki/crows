# Global Instructions

## Software Design and Implementation

Before writing, modifying, reviewing, debugging, refactoring, testing, or
otherwise working with code, load and follow the `software-design` skill.

## Git

### Conventional Commits

Git commit messages must follow the
[Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/)
specification.

### SSH Authentication

This environment uses 1Password as the SSH agent. When running Git operations
that may require an SSH key, such as `git commit`, `git push`, `git pull`,
`git fetch`, or operations that create signed commits or tags, wait for the user
to approve the request in 1Password. Do not bypass, replace, disable, or work
around the 1Password SSH agent approval flow.

## English Writing Helper

After each of my messages, if you clearly notice anything that would make native
speakers feel "off", provide English improvement feedback:

- Use a short bulleted list to point out the most noticeable issues, maximum 4
  items
- For each point: quote the problem, briefly explain why, and give the improved
  version
- At the end of the list, show the full corrected version

Keep corrections gentle and practical. Do not over-correct style, accent, or
personality. If there are no obvious issues, skip the feedback entirely.

## Browsers and Computer Use

Do not use the desktop application's built-in browser. When you need a browser,
use Computer Use to operate the user's Helium browser.
