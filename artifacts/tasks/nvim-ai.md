# Task: Neovim & AI Toolchain, nvf to Multi-Harness (from overview.md)

- [x] `programs.nvf.settings` (Dynamic Theming): Configured `luaConfigRC` with Base16 and Noctalia templates, catching `SIGUSR1` for real-time live palette reloads.
- [x] AI Assistant Integration: Deployed Avante (`avante-nvim`) and Supermaven (`supermaven-nvim`) with `blink-cmp` source providers.
- [x] `programs.nvf.settings.visuals.lualine`: Implemented custom Lualine bubbles theme components and dynamic LSP status providers.
- [x] `programs.nvf.settings.utility.snacks-nvim`: Configured dashboard with custom ANSI colorscript art (`hollowheap-colorscript`), explorer, pickers, and diagnostics.
- [x] `programs.antigravity-cli`: Declarative agent definitions (`orchestrator`, `ask-only`, `code-reviewer`, `test-runner`, `refactorer`, `docs-generator`, `security-scanner`, `git-automator`) and skill configurations, rendered from shared `ai.*` options.
- [x] `ai.*` (Capability-Based Multi-Harness Config): Harness-neutral agent/skill schema with abstract `read`/`write`/`execute`/`delegate`/`mcp` capabilities, translated per-harness (Antigravity tool vocab; Kiro V3 JSON with enforced `tools`/`excludedTools`/`permissions.rules`).
- [x] `ai.agents.orchestrator`: Delegation-only coordinator (read + subagent, no write/shell/mcp) gating spawnable sub-agents via `availableAgents`/`trustedAgents`.
- [x] `programs.kiro-cli`: Integrated Kiro CLI with Zsh hooks; renders skills to `.kiro/steering/`, agents to enforced `.kiro/agents/*.json`, and a `repomap` `SessionStart` hook feeding read-only agents a `file://artifacts/repomap.md` resource.
