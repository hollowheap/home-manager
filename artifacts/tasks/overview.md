# Project Overview: Goals, Scope & Acceptance

Migrated from the former root `PLAN.md` (retired). Per-area execution checklists live beside this
file in `artifacts/tasks/`.

## Objective
Configure and maintain a modular, high-performance standalone Home Manager environment. Focus on user-space applications, Wayland desktop compositor (Hyprland), Neovim (nvf) with AI toolchains, dynamic theme synchronization (Stylix, Noctalia, Matugen), shell optimizations, and user-level secrets management.

## Scope
### Included
* User-space configuration only: applications, shells, editors, terminal tooling, per-user services, and secrets agents.
* Wayland compositor and session routing at the user level (Hyprland).
* Declarative AI tooling: shared `ai.*` agent/skill/rule definitions rendered to opencode, crush, pi, kiro, antigravity, copilot-cli, codex, and hermes.
* Custom package overlay discovery under `pkgs/` and declarative `devShells`.

### Excluded
* System-level NixOS configuration (kernel, bootloader, display managers, system services) — out of scope for standalone Home Manager.
* Hardware provisioning and partitioning.
* Anything requiring root outside the Home Manager activation boundary.

## Tech Stack
* Languages: Nix, Lua (nvf config), Python (`repomap`), shell (Zsh).
* Frameworks and Libraries: Home Manager (standalone), `nixpkgs-unstable`, nvf, Stylix, Noctalia.
* Tools: Flakes, `rbw`/`gpg-agent`, Hyprland + UWSM, Kiro CLI, Antigravity CLI, `universal-ctags`/`fd` (repomap), `nixfmt`.

## Master List of Goals
- [x] Implement Flake architecture decoupling system and user space with custom package overlay
- [x] Configure base Wayland compositor (Hyprland) and user session routing (UWSM)
- [x] Establish user-space secrets management (RBW / GPG agent socket handling)
- [x] Stabilize Hyprland plugins (hyprglass), keybindings, and dynamic workspace rules
- [x] Finalize web browser (Zen Browser), GUI apps (Vesktop, Thunderbird), and system user utilities
- [x] Establish dynamic theming pipeline (Noctalia + Stylix + Base16 live reloading via SIGUSR1)
- [x] Complete Neovim (nvf) configuration, including pure AI toolchain migration (Avante, Supermaven, blink-cmp)
- [x] Establish a capability-based multi-harness AI config (`ai.*`) rendering enforced agents/skills/rules to all harnesses from one shared schema
- [x] Optimize shell environment (Zsh, Starship, Fastfetch, Bat, Yazi, Delta, Zoxide)
- [x] Establish declarative development shells (`devShells`) for Pico, Python, Rust, Nix, and TypeScript / JavaScript
- [x] Implement user store hygiene automation (`nix.gc` & generation pruner systemd timers)
- [x] Finalize OBS Studio hardware capture plugins (`obs-vaapi`, `obs-vkcapture`, `obs-pipewire-audio-capture`)

## Shared Overlaps (Nix & Secrets Management)
- [x] **Flake Architecture & Decoupling:** Standalone Home Manager module schema with host flake outputs and custom package overlay discovery.
- [x] **Declarative Channel Parity:** Standardizing module and package scopes strictly on `nixpkgs-unstable` to eliminate ABI mismatches.
- [x] **User Secrets & Agent Sockets:** Integration of `rbw` and `gpg-agent` with SSH agent socket routing (`IdentityAgent = "/run/user/%u/rbw/ssh-agent-socket"`).
- [x] **Zero-Token Git Workflow:** User-level SSH and GPG agent socket routing with SSH URL auto-substitution (`insteadOf = "gh:"`, `insteadOf = "gh@"`) and HTTPS→SSH push rewriting (`pushInsteadOf`).
- [x] **Capability-Based Agent Boundaries:** Single harness-neutral `ai.*` schema (`read`/`write`/`execute`/`delegate`/`mcp`) translated per-harness — Kiro enforces boundaries at both tool-visibility and permission-rule layers (deny-overrides), resisting prompt-injection in untrusted content.
- [x] **User Store Hygiene:** Automated user-profile garbage collection (`nix.gc.automatic = true`, `delete-older-than 7d`, weekly `hm expire-generations` timer).

## Tasks
Per-area execution checklists live in `artifacts/tasks/` (one file per area, completed work included):
- Environment, Plumbing & Dynamic Theming → artifacts/tasks/env-theming.md
- Desktop Shell & Window Managers → artifacts/tasks/desktop-wms.md
- Neovim & AI Toolchain → artifacts/tasks/nvim-ai.md
- GUI Applications & Browsers → artifacts/tasks/gui-apps.md
- System Utilities & Services → artifacts/tasks/system-services.md
- CLI & Shell Optimization → artifacts/tasks/cli-shell.md

## Architecture Topics Breakdown
- [x] **Dynamic Theme Pipeline (`luaConfigRC` & `SIGUSR1`):** Decoupling build-time Nix closures from runtime imperative cache injections with asynchronous main-loop signal routing.
- [x] **Plumbing Derivations (`useUWSM` & `launchApp`):** Dynamic resolution pattern balancing store binaries with UWSM systemd scope compliance via conditional evaluation helpers.
- [x] **Declarative Channel Parity (Unstable):** Standardizing standalone Home Manager and package scopes strictly on `nixpkgs-unstable` to prevent shared C++/Rust ABI mismatches.
- [x] **AI Authentication Boundaries (OAuth / RBW vs. Hardcoded Keys):** Decoupled IDE-level OAuth credential management from terminal multi-agent workflows without plain-text keys.
- [x] **User Store Hygiene (`nix.gc` & `auto-optimise-store`):** Pruning user profile generations and maintaining local Nix store health automatically.

## Validation & Acceptance
How each area is verified. A goal is not "done" until its acceptance evidence holds.
- [x] **Evaluation gate:** `nix flake check --no-build` passes on every change.
- [x] **Build gate:** `nix build .#homeConfigurations.<host>.activationPackage` produces a generation without errors before activation.
- [x] **Rendered-artifact review:** Kiro agents (`.kiro/agents/*.json`) inspected to confirm `tools`/`excludedTools`/`permissions.rules` match intended capabilities (read-only agents deny `fs_write`/`shell`/`mcp`).
- [ ] **Activation parity:** `home-manager switch` applies cleanly and live `~/.kiro` / `~/.gemini` artifacts match the built generation.
- [ ] **Harness behaviour:** Confirm Antigravity honours rendered frontmatter tool restrictions (Kiro enforcement is verified; Antigravity is transmitted-only).

## Risks & Rollback
Forward-looking failure modes and how to reverse them (distinct from Known Issues, which are already observed).
- [ ] **nixfmt heredoc mangling:** `nixfmt` reindented a `''` heredoc in `flake.nix` `shellHook`, potentially producing a malformed `.clangd`. Mitigation: keep the reindent uncommitted; revert or use `lib.stripTabs` before landing.
- [ ] **Git-tree/flake desync on renames:** untracked files (e.g. the hyprglass move) break flake eval since flakes only see tracked paths. Mitigation: `git add` new files before building; verify with a full build.
- [ ] **Antigravity token drift:** delegation/MCP tokens are unverified for Antigravity, so orchestrator delegation is not mapped there. Rollback: capability stays Kiro-only until Antigravity's tokens are confirmed.

## Alternatives Considered
- **Per-harness duplicated agent configs** (rejected): abandoned in favour of one shared `ai.*` schema with per-renderer translation, to avoid drift between Antigravity and Kiro.
- **Custom planning agent vs. built-in `/plan`** (deferred): a scoped custom agent can reproduce guidance/tool-scoping but not Kiro's gated phases or task-wave execution; kept the built-in for those, shared skills for guidance.
- **`skill://` vs `file://` for always-needed context** (chosen `file://` where determinism matters): progressive `skill://` loading is model-discretionary; `file://` guarantees load for critical content (e.g. repomap for read-only agents).

## Open Questions & Notes
Unresolved items and assumptions. Never omit.
- [x] Standardized repomap artifact path to `artifacts/repomap.md` (read-only agents consume `file://artifacts/repomap.md`).
- [x] Flake `pico` devShell generates `.clangd` via `shellHook`; `.clangd` can be committed if present.
- [ ] Do any stored SSH keys span multiple GitHub accounts (would require host-alias pinning), or is it a single account?
- Note: several pre-existing WIP edits (`nvim.nix`, `tmux.nix`, `hyprland.nix`, `zen-browser.nix`, `mactahoe-*`) remain uncommitted and are tracked separately from this session's AI-config work.
