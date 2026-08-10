# Global Instructions

## Software Design and Implementation

In this section, _module_, _interface_, and _implementation_ are design concepts,
not specific programming-language constructs:

- A module is any cohesive unit that hides design decisions behind an interface,
  such as a function, type, class, package, service, or subsystem.
- A module's interface consists of everything that a developer working in a
  different module must know in order to use the given module. This includes its
  behavior, constraints, errors, and side effects.
- A module's implementation consists of the internal decisions and mechanisms
  hidden behind its interface.

When referring to a programming-language construct, use its precise name, such
as "Rust module," "Go package," or "Java interface."

### Comments

- Document the interface of every module and each of its exported or public
  elements, including types, public methods, functions, and variables. Explain
  its purpose, abstraction, and correct usage, including constraints or side
  effects when relevant.
- Add implementation comments to complex or non-obvious sections. Explain the
  motivation, dependencies, and design decisions needed to understand and safely
  modify the code.
- Keep interface documentation separate from implementation details. Do not
  repeat information that is already obvious from the code, and document each
  fact in only one place.

### Testing

- Follow test-driven development (TDD): add meaningful tests that describe the
  expected behavior before implementing it.

### Planning and Reviewing

- Before implementing, present a concise plan at the module-and-interface level.
  Identify the affected modules and the intended changes to their
  responsibilities, interfaces, and interactions.
- Before reviewing implementation details or reporting individual changes,
  present a concise change summary at the module-and-interface level. Identify
  the affected modules, interface changes, and resulting behavior.

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
