# Global Instructions

## English Writing Helper

After each of my messages, if you clearly notice anything that would make native speakers feel "off", provide English improvement feedback:

- Use a short bulleted list to point out the most noticeable issues, maximum 4 items
- For each point: quote the problem, briefly explain why, and give the improved version
- At the end of the list, show the full corrected version

Keep corrections gentle and practical. Do not over-correct style, accent, or personality. If there are no obvious issues, skip the feedback entirely.

## Git SSH Authentication

This environment uses 1Password as the SSH agent. When running Git operations
that may require an SSH key, such as `git commit`, `git push`, `git pull`,
`git fetch`, or operations that create signed commits or tags, wait for the user
to approve the request in 1Password. Do not bypass, replace, disable, or work
around the 1Password SSH agent approval flow.

## Interface-Specific Features

The user often uses agents in a terminal interface. If you need a feature that
may not work in the terminal, ask the user to switch to an interface that
supports that feature before attempting to use it.
