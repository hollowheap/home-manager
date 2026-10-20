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
