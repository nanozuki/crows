# Agent Skills

This directory contains locally maintained and vendored third-party agent
skills. Each subdirectory is installed as a skill by the Home Manager agents
module.

## Third-party skills

| Skill | Upstream source | Revision | License | Local changes |
| --- | --- | --- | --- | --- |
| [`grilling`](grilling/) | [`mattpocock/skills/skills/productivity/grilling`](https://github.com/mattpocock/skills/tree/5b15a47f2d7150f545fbcacbfe381787fc0230dc/skills/productivity/grilling) | [`5b15a47f2d7150f545fbcacbfe381787fc0230dc`](https://github.com/mattpocock/skills/commit/5b15a47f2d7150f545fbcacbfe381787fc0230dc) | [MIT](grilling/UPSTREAM-LICENSE) | None; `UPSTREAM-LICENSE` is copied from the repository root. |
| [`writing-for-agents`](writing-for-agents/) | [`mattpocock/skills/skills/productivity/writing-for-agents`](https://github.com/mattpocock/skills/tree/8b78b531ab965735c5dc74f6f7a219e1e37326df/skills/productivity/writing-for-agents) | [`8b78b531ab965735c5dc74f6f7a219e1e37326df`](https://github.com/mattpocock/skills/commit/8b78b531ab965735c5dc74f6f7a219e1e37326df) | [MIT](writing-for-agents/UPSTREAM-LICENSE) | None; `UPSTREAM-LICENSE` is copied from the repository root. |

When adding or updating a third-party skill, pin it to a commit, preserve its
upstream contents, include its license, and update this table with any local
changes.
