# Capability / Rule / Harness Matrix

Single source: `config.ai.*`. Regenerate any row with `nix eval` before trusting it.

## Agents

| Agent | Mode | Model / Effort | Caps | Skills | Matched rules (9/6/3/3/1/0) |
|---|---|---|---|---|---|
| engineer | primary | flash / high | R W X web | plan question nav-repomap | hunks shell commits tests logs clean-hands no-destroy no-secrets record |
| architect | all | pro / xhigh | R W web | plan question nav-repomap | hunks clean-hands record |
| orchestrator | primary | pro / high | R delegate | plan question nav-repomap | delegate |
| research | subagent | flash / low | R web | nav-repomap question | (none) |
| code-reviewer | subagent | pro / high | R X | nav-repomap question | shell commits tests logs no-destroy no-secrets |
| writer | subagent | flash / medium | R W | question nav-repomap | hunks clean-hands record |

R = read, W = write, X = execute. Plan.md is owned by engineer; all contribute roadmaps via the plan skill.

## Rules (`modules/ai/rules.nix`)

| Rule | Requires | Lands on |
|---|---|---|
| hunks | write | engineer architect writer |
| shell | execute | engineer code-reviewer |
| commits | execute | engineer code-reviewer |
| tests | execute | engineer code-reviewer |
| logs | execute | engineer code-reviewer |
| clean-hands | write | engineer architect writer |
| no-destroy | execute | engineer code-reviewer |
| no-secrets | execute | engineer code-reviewer |
| record | write | engineer architect writer |
| delegate | delegate | orchestrator |

Match = agent holds every required cap. Writer has no tests rule (no execute); its reproducer line lives in its instructions instead.

## Harness surfaces

| Harness | Agent surface (brief + matched rules) | Global surface | Drops |
|---|---|---|---|
| opencode | native agents | context = disciplines | unslop concise/no-restate/dense |
| pi | agents/*.md | context = disciplines | (none) |
| codex | .codex/agents/*.toml | AGENTS.md = disciplines | (none) |
| kiro | agents/*.json (web stripped for subagents) | steering = disciplines | (none) |
| copilot | agent prompts | context = disciplines | (none) |
| antigravity | agent.md files | rules = disciplines | (none) |
| crush | none (single file below) | AGENTS.md = briefs + rules union + disciplines | complete whole, skills load/obey, unslop ×3 |
| hermes | none | skills external_dirs only | n/a |

Question tool exists on opencode (`question`) and antigravity (`ask_question`) only; the question skill flags the other six harnesses.

## Skills (`modules/ai/skills.nix`)

plan, question, nav-repomap, shared-tree, upstream-recon, overlap-check. Bodies load on demand everywhere except kiro `skill://` resources (possibly always-loaded; bounded at ~30–40 lines each).
