---
name: software-design
description: Software design and implementation standards for comments, testing, planning, and review. Use before writing, modifying, reviewing, debugging, refactoring, testing, or otherwise working with code.
---

# Software Design and Implementation

Apply these standards only when writing, modifying, reviewing, or otherwise
working with code. Do not apply them to non-coding tasks.

In this skill, _module_, _interface_, and _implementation_ are design concepts,
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

## Comments

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
- Keep comments up to date throughout development. Before writing or updating
  an implementation, identify affected comments and, when they need to change,
  update them first to describe the intended behavior.
- After changing an implementation and during code review, verify that its
  comments remain accurate and consistent with it. Correct any stale or
  misleading comments.

## Testing

- Follow test-driven development (TDD): add meaningful tests that describe the
  expected behavior before implementing it.

## Planning and Reviewing

- When a coding task benefits from planning, present a concise plan at the
  module-and-interface level. Identify the affected modules and the intended
  changes to their responsibilities, interfaces, and interactions, then proceed
  without asking the user to confirm the plan.
- Before reviewing implementation details or reporting individual changes,
  present a concise change summary at the module-and-interface level. Identify
  the affected modules, interface changes, and resulting behavior.
