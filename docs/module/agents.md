# Agents Home Manager Module

`public/modules/home/agents.nix` provides declarative agent setup and shared
skill installation through `crows.agents`. Each enabled agent integration owns
its package, environment, instruction files, agent-specific files, and skill
destination. Every enabled integration receives the same explicitly selected
skill set.

## Configuration interface

Declare remote skill repositories as non-flake inputs:

```nix
inputs.matt-skills = {
  url = "github:mattpocock/skills";
  flake = false;
};
```

Pass the input path and select skills in Home Manager:

```nix
{ config, inputs, ... }:
{
  crows.agents = {
    claude = true;
    codex = true;
    pi = true;

    skillSources = {
      matt = "${inputs.matt-skills.outPath}/skills/productivity";
      local = ./agents/skills;
    };

    skills = {
      grilling = "matt";
      local-skill = "local";
    };
  };
}
```

The three agent options are boolean enablement switches. `skillSources` maps
source names to skill repository roots. `skills` maps skill names to source
names.

## Agent integrations

Each integration defines the complete Home Manager configuration for one
supported agent:

| Option | Package | Configuration directory | Instruction file | Skill directory |
| --- | --- | --- | --- | --- |
| `claude` | `claude-code` | `${config.xdg.configHome}/claude` | `CLAUDE.md` | `skills` |
| `codex` | `codex` | `${config.xdg.configHome}/codex` | `AGENTS.md` | `skills` |
| `pi` | `pi-coding-agent` | `${config.xdg.configHome}/pi/agent` | `AGENTS.md` | `skills` |

Claude exports `CLAUDE_CONFIG_DIR`, Codex exports `CODEX_HOME`, and pi exports
`PI_CODING_AGENT_DIR`. The instruction files use
`public/configs/agents/AGENTS.md` as their source. The pi integration also owns
`keybindings.json` from `public/configs/agents/pi_keybindings.json`.

Agent enablement activates the package, environment variables, instruction
files, agent-specific files, and selected skill links as one integration.

## Skill sources

`crows.agents.skillSources` has type `attrsOf path`. Each value identifies the
directory whose immediate named entries are available for selection.

The module contributes the `crows` source, rooted at
`public/configs/agents/skills`. Configurations use it through the same selection
interface as every configured source:

```nix
crows.agents.skills.software-design = "crows";
```

Flake inputs supply immutable store paths directly. A non-flake input supports
repositories with any internal Nix layout, while `flake.lock` records its
revision and content hash. Updates use the standard flake commands:

```console
nix flake update matt-skills
```

Local Nix paths provide repository-local sources:

```nix
crows.agents.skillSources.local = ./agents/skills;
```

## Skill selection and resolution

`crows.agents.skills` has type `attrsOf string` and defaults to `{ }`. Each
attribute forms one complete selection:

```nix
skills.<name> = "<source>";
```

The attribute name serves as the skill identifier, the directory name within
the source, and the installed directory name. The value names an entry in
`skillSources`. The module resolves the selection to:

```text
<skillSources.<source>>/<name>
```

Configurations enumerate the complete skill set required by their workflows.
Every enabled agent receives that complete set.

Resolution runs when at least one agent integration is enabled. For every
selection, evaluation resolves the named source and confirms that the resulting
path is a directory. Directory validation diagnostics carry both the source and
skill names. The source directory remains an opaque, immutable skill unit
throughout installation.

## Installation

The module generates the Cartesian product of enabled agents and selected
skills. Each pair becomes a `home.file` declaration:

```text
<agent-skill-directory>/<name> -> <skillSources.<source>>/<name>
```

The declaration links the complete skill directory. Home Manager provides file
ownership, activation, generation rollback, and conflict reporting. Flake input
locks and Home Manager generations together carry the complete version state.

Generated `home.file` keys combine the agent and skill names, giving each pair a
deterministic declaration identity. Attribute-set keys establish one selected
source for each skill name, and each agent integration contributes one skill
destination.

## Module structure

The implementation follows five operations:

1. Build the source map from the module-provided `crows` source and configured
   `skillSources`.
2. Collect the enabled agent integrations and their package, configuration, and
   destination definitions.
3. Resolve each selected skill from its source when the enabled integration set
   is populated.
4. Validate every resolved skill directory and produce contextual diagnostics.
5. Generate the skill-and-agent product as `home.file` declarations and merge
   it with each integration's package and configuration declarations.

Source locking belongs to the flake layer. The Home Manager module consumes the
resulting immutable paths and performs deterministic evaluation and
installation.

## Verification

Home Manager-native evaluation tests use
`home-manager.lib.homeManagerConfiguration` so the module runs against the real
`home.file`, package, and session-variable interfaces. Flake checks cover:

- the module-provided `crows` source;
- configured path sources;
- explicit skill selection and path resolution;
- identical skill installation across multiple enabled agents;
- an empty skill selection;
- a configuration with zero enabled agent integrations;
- existing agent packages, environment variables, instruction files, and
  agent-specific files; and
- source-reference and skill-directory diagnostics.

The checks are exposed through the flake `checks` output and run with:

```console
nix flake check
```

Affected host builds provide integration verification for machine
configurations that adopt the interface.
