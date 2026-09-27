# Home Manager Plan

## Objective
Configure and maintain a modular, high-performance standalone Home Manager environment. Focus on user-space applications, Wayland desktop compositors (Hyprland, Niri, MangoWC), Neovim (nvf) with AI toolchains, dynamic theme synchronization (Stylix, Noctalia, Matugen), shell optimizations, and user-level secrets management.

## Scope
### Included
* User-space configuration only: applications, shells, editors, terminal tooling, per-user services, and secrets agents.
* Wayland compositors and session routing at the user level (Hyprland now; Niri, MangoWC planned).
* Declarative AI tooling: shared `ai.*` agent/skill definitions rendered to Antigravity and Kiro.
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
- [x] Establish a capability-based multi-harness AI config (`ai.*`) rendering enforced agents/skills to Antigravity and Kiro from one shared schema
- [x] Optimize shell environment (Zsh, Starship, Fastfetch, Bat, Yazi, Delta, Zoxide)
- [x] Establish declarative development shells (`devShells`) for Pico, Python, Rust, and Nix
- [ ] Implement user store hygiene automation (`nix.gc` & generation pruner systemd timers)
- [ ] Configure alternative Wayland compositors (Niri, MangoWC) with UWSM parity
- [ ] Finalize OBS Studio hardware capture plugins (`obs-vaapi`, `obs-vkcapture`, `obs-pipewire-audio-capture`)
- [ ] Add TypeScript / Web development shell in `flake.nix`

## Shared Overlaps (Nix & Secrets Management)
- [x] **Flake Architecture & Decoupling:** Standalone Home Manager module schema with host flake outputs and custom package overlay discovery.
- [x] **Declarative Channel Parity:** Standardizing module and package scopes strictly on `nixpkgs-unstable` to eliminate ABI mismatches.
- [x] **User Secrets & Agent Sockets:** Integration of `rbw` and `gpg-agent` with SSH agent socket routing (`IdentityAgent = "/run/user/%u/rbw/ssh-agent-socket"`).
- [x] **Zero-Token Git Workflow:** User-level SSH and GPG agent socket routing with SSH URL auto-substitution (`insteadOf = "gh:"`, `insteadOf = "gh@"`) and HTTPS→SSH push rewriting (`pushInsteadOf`).
- [x] **Capability-Based Agent Boundaries:** Single harness-neutral `ai.*` schema (`read`/`write`/`execute`/`delegate`/`mcp`) translated per-harness — Kiro enforces boundaries at both tool-visibility and permission-rule layers (deny-overrides), resisting prompt-injection in untrusted content.
- [ ] **User Store Hygiene:** Automated user-profile garbage collection (`nix.gc.automatic = true`, `delete-older-than 7d`, weekly `hm expire-generations` timer).

## Tasks

### Environment, Plumbing & Dynamic Theming
- [x] `options` (Core-Apps Refactor): Binary variable definitions migrated from packages to string commands for accurate `uwsm app --` scope routing.
- [x] `fonts.packages`: Standardized VictorMono Nerd Font and Noto Sans CJK with fontconfig fallback rendering.
- [x] `stylix.enable`: Configured for cursor (`Bibata-Modern-Classic`), GTK, and Qt; explicitly disable color generation in favor of Noctalia.
- [x] `xdg.enable` / `xdg.userDirs.enable`: Declarative standard directory routing (`Desktop`, `Documents`, `Downloads`, `Music`, `Pictures`, `Videos`) with `templates = null` and `publicShare = null`.
- [x] `home.sessionVariables`: Explicit Wayland and Nvidia environment flags (`LIBVA_DRIVER_NAME`, `GBM_BACKEND`, `NIXOS_OZONE_WL`, `ELECTRON_OZONE_PLATFORM_HINT`).
- [x] `pkgs.mactahoe-gtk-theme` / `mactahoe-icon-theme`: Custom package derivations with `jdupes` hardlinking during build.
- [ ] `home.activation` (GTK Deduplication): Implement `jdupes --quiet --link-hard --recurse` post-build script for `~/.config/gtk-3.0` and `~/.config/gtk-4.0` via `lib.hm.dag.entryAfter [ "writeBoundary" ]`.

### Desktop Shell & Window Managers
- [x] `wayland.windowManager.hyprland.settings`: Hyprland workspace animations (`slidevert`), scrolling layout (`scrolling.column_width = 0.67`), multi-monitor positioning (`DP-1`, `HDMI-A-1`, `eDP-1`), and dynamic window/layer rules.
- [x] `pkgs.hyprlandPlugins.hyprglass`: Packaged and pinned Hyprglass shader plugin (nested under `pkgs/hyprland-plugins/`) for glass/blur effects.
- [x] `programs.noctalia.settings`: Finalized Noctalia shell configuration (status bar capsule groups, DDCutil brightness control, widgets, Satty screenshot pipeline).
- [ ] `options.defaultApps.launcher`: Default launcher option reconciliation (`noctalia msg panel-toggle launcher` vs `vicinae`).
- [ ] `wayland.windowManager.niri.settings`: Configure Niri window manager with UWSM session execution, scrollable columns, and keybinding parity with Hyprland.
- [ ] `wayland.windowManager.mangowc.settings`: Configure MangoWC window manager options in an isolated module for testing.

### Neovim & AI Toolchain (nvf & Antigravity)
- [x] `programs.nvf.settings` (Dynamic Theming): Configured `luaConfigRC` with Base16 and Noctalia templates, catching `SIGUSR1` for real-time live palette reloads.
- [x] AI Assistant Integration: Deployed Avante (`avante-nvim`) and Supermaven (`supermaven-nvim`) with `blink-cmp` source providers.
- [x] `programs.nvf.settings.visuals.lualine`: Implemented custom Lualine bubbles theme components and dynamic LSP status providers.
- [x] `programs.nvf.settings.utility.snacks-nvim`: Configured dashboard with custom ANSI colorscript art (`hollowheap-colorscript`), explorer, pickers, and diagnostics.
- [x] `programs.antigravity-cli`: Declarative agent definitions (`orchestrator`, `ask-only`, `code-reviewer`, `test-runner`, `refactorer`, `docs-generator`, `security-scanner`, `git-automator`) and skill configurations, rendered from shared `ai.*` options.
- [x] `ai.*` (Capability-Based Multi-Harness Config): Harness-neutral agent/skill schema with abstract `read`/`write`/`execute`/`delegate`/`mcp` capabilities, translated per-harness (Antigravity tool vocab; Kiro V3 JSON with enforced `tools`/`excludedTools`/`permissions.rules`).
- [x] `ai.agents.orchestrator`: Delegation-only coordinator (read + subagent, no write/shell/mcp) gating spawnable sub-agents via `availableAgents`/`trustedAgents`.
- [x] `programs.kiro-cli`: Integrated Kiro CLI with Zsh hooks; renders skills to `.kiro/steering/`, agents to enforced `.kiro/agents/*.json`, and a `repomap` `SessionStart` hook feeding read-only agents a `file://.kiro/repomap.md` resource.

### GUI Applications & Browsers
- [x] `programs.vesktop.settings`: Discord / Vesktop client customization with Vencord and Noctalia theme styling.
- [x] `programs.zen-browser`: Hardened privacy policies, DNS-over-HTTPS, Startpage search routing, and multi-space container routing (`Personal`, `School`, `Entertainment`, `Social`).
- [x] `programs.thunderbird`: Thunderbird email client profile integration.
- [ ] `programs.obs-studio.plugins`: Configure OBS Studio plugins (`obs-vaapi`, `obs-vkcapture`, `obs-pipewire-audio-capture`).
- [ ] `home.packages`: Install `prismlauncher` for Minecraft instance management.

### System Utilities & Services
- [x] `programs.yazi`: Modern terminal file manager configuration.
- [x] `programs.btop.settings`: Resource monitor config with `btop-cuda` and Noctalia theme.
- [x] `programs.ghostty.settings`: Fast GPU-accelerated terminal emulator setup.
- [x] `programs.tmux.settings`: `C-Space` prefix, `smart-splits.nvim` integration, popup windows (`lazygit`, `yazi`).
- [x] `dconf.settings`: Gnome interface prefer-dark and Nautilus preferences (`default-folder-viewer = "icon-view"`, `show-delete-permanently = true`).
- [x] `services.rcloneSync`: Parameterized `rclone` sync for `gdrive:` to `~/Drive/<remote>` on a 30-minute systemd user timer.
- [x] `services.gpg-agent`: Configured with `pinentry-gnome3` and SSH support.

### CLI & Shell Optimization
- [x] `programs.git`: Signed commits, comprehensive alias suite, SSH URL substitutions (`gh:`, `gh@`), and HTTPS→SSH push rewriting (`pushInsteadOf = "https://github.com/"`).
- [x] `programs.lazygit`: Delta diff renderer integration.
- [x] `programs.zsh`: Vi-mode, `fzf-tab`, compinit caching, and global aliases.
- [x] `programs.starship`: Shell prompt customization with pills and duration indicators.
- [x] `programs.fastfetch`: Custom bordered card layout with hardware modules.
- [x] `programs.bat`: Syntax-highlighted cat with `bat-extras` (batdiff, batman, batgrep, batpipe).
- [x] `programs.tealdeer`: TLDR cache client with `updates.auto_update = true`.
- [x] `programs.direnv`: `nix-direnv` and Zsh integration.
- [x] `programs.zoxide`: Smart cd integration (`--cmd cd`) with Zsh.
- [x] `programs.utilities`: Declaratively enabled `eza`, `ripgrep`, `fd`, `fzf`, and `delta`.
- [x] `devShells`: Declarative development shells in `flake.nix` for Pico (`pico-sdk`), Python (`uv`), Rust (`cargo`), and Nix (`nil`).
- [ ] `devShells.ts`: Add TypeScript / Node development shell.

## Architecture Topics Breakdown
- [x] **Dynamic Theme Pipeline (`luaConfigRC` & `SIGUSR1`):** Decoupling build-time Nix closures from runtime imperative cache injections with asynchronous main-loop signal routing.
- [x] **Plumbing Derivations (`useUWSM` & `launchApp`):** Dynamic resolution pattern balancing store binaries with UWSM systemd scope compliance via conditional evaluation helpers.
- [x] **Declarative Channel Parity (Unstable):** Standardizing standalone Home Manager and package scopes strictly on `nixpkgs-unstable` to prevent shared C++/Rust ABI mismatches.
- [x] **AI Authentication Boundaries (OAuth / RBW vs. Hardcoded Keys):** Decoupled IDE-level OAuth credential management from terminal multi-agent workflows without plain-text keys.
- [ ] **User Store Hygiene (`nix.gc` & `auto-optimise-store`):** Pruning user profile generations and maintaining local Nix store health automatically.


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
- [ ] Should `.kiro/repomap.md` be git-ignored (generated artifact) or committed as a seed for first-session availability?
- [ ] Should the flake.nix heredoc reindent be reverted or fixed with `lib.stripTabs`?
- [ ] Do any stored SSH keys span multiple GitHub accounts (would require host-alias pinning), or is it a single account?
- Note: several pre-existing WIP edits (`nvim.nix`, `tmux.nix`, `hyprland.nix`, `zen-browser.nix`, `fl-studio.nix`, `mactahoe-*`) remain uncommitted and are tracked separately from this session's AI-config work.
