# Renderer Author Matrices & Surface References

## Harness Surface Mapping

| Harness | Agent Surface (Brief + Matched Rules) | Global Surface | Drop Policy |
|---|---|---|---|
| `opencode` | Native agents (`~/.config/opencode/agents/*.md`) | `context` = `""` (Disciplines rendered into agents) | Unslop concise/no-restate/dense |
| `pi` | `agents/*.md` | `appendSystem` = Disciplines, `context` = Roster | None |
| `codex` | `.codex/agents/*.toml` | `programs.codex.context` = Disciplines | None |
| `kiro` | `.kiro/agents/*.json` (Web stripped for subagents) | `.kiro/steering/*.md` = Disciplines | None |
| `copilot` | `~/.config/github-copilot/agents/*.md` | `programs.github-copilot-cli.context` | None |
| `antigravity` | `~/.gemini/antigravity-cli/agents/${name}/agent.md` | `~/.gemini/config/rules/${name}.md` | None |
| `crush` | None (Single file union in `~/.config/crush/AGENTS.md`) | `AGENTS.md` = Briefs + Rules Union + Disciplines | None |
| `hermes` | None | Skills `external_dirs` only | None |

## Built-In Prompt Overlap Table

| Harness | Vendor Default Coverage | Dropped Rules |
|---|---|---|
| `opencode` | Concise output, file reference format | `unslop.concise`, `unslop.no-restate`, `unslop.dense` |
| `crush` | Ultra-terse style | None |
| `pi` | Unverified | None |
| `codex` | Closed base prompt | None |
| `kiro` | Closed base prompt | None |
| `copilot` | Closed base prompt | None |
| `antigravity` | Closed base prompt | None |
| `hermes` | Closed base prompt | None |

## Capability & Rules Matrix

| Rule | Requires | Target Agents |
|---|---|---|
| `investigate` | `read` | `ask`, `architect`, `engineer` |
| `research` | `read` | `ask`, `architect`, `engineer` |
| `security` | `read` | `ask`, `architect`, `engineer` |
| `communicate` | `write` | `architect`, `engineer` |
| `style` | `write` | `architect`, `engineer` |
| `verify` | `write`, `execute` | `engineer` |
| `delegate` | `delegate` | `ask`, `architect`, `engineer` |

## Skills Surface Mapping

| Harness | Discovery Target / Configuration | Rendering Helper |
|---|---|---|
| `opencode` | `programs.opencode.settings.skills` (`~/.config/opencode/skills/<name>/`) | `aiRender.mkSkillDir { prefix = "opencode"; }` |
| `antigravity` | `programs.antigravity.settings.skills` (`~/.gemini/antigravity-cli/skills/<name>/`) | `aiRender.mkSkillDir { prefix = "antigravity"; }` |
| `crush` | `programs.crush.settings.skills` (`~/.config/crush/skills/<name>/`) | `aiRender.mkSkillDir { prefix = "crush"; }` |
| `codex` | `programs.codex.settings.skills` (`~/.codex/skills/<name>/`) | `aiRender.mkSkillDir { prefix = "codex"; }` |
| `hermes` | `skills.external_dirs` in `~/.hermes/config.yaml` | `aiRender.mkSkillDir { prefix = "hermes"; }` |
| `pi` | `~/.pi/agent/skills/<name>/` | `aiRender.mkSkillDir { prefix = "pi"; }` |
| `kiro` | `~/.kiro/skills/<name>/` | `aiRender.mkSkillDir { prefix = "kiro"; }` |
| `copilot` | `~/.config/github-copilot/skills/<name>/` | `aiRender.mkSkillDir { prefix = "copilot"; }` |

## Skill Authoring Standard & Anatomy

1. **Trigger Gating**: `description` must define explicit positive and negative activation bounds (*"Load ONLY when... Do NOT load for..."*).
2. **Standard Section Headers**:
   - `## Workflow`: Numbered sequential actions (`1., 2., 3.`) starting with active imperative verbs (`Confirm`, `Inspect`, `Write`, `Implement`, `Stage`). No `X: Y.` category labels.
   - `## Rules`: Bulleted invariant constraints (`- ...`) starting with direct active imperatives (`Never`, `Keep`, `Test`). No buzzword labels (`Iron Law`, `Rule of...`). Final rule is always `- Verify: <exit condition>`.
3. **Artifact Isolation**:
   - `references."<file>.md"`: Static tables, schemas, or templates.
   - `references."examples.md"`: `## Bad` and `## Good` contrast pairs.
   - `scripts."<name>.sh"`: Executable shell tools wrapped by `mkSkillDir`.
