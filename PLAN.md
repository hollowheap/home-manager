# Home Manager Plan

## Objective
Configure and maintain a modular, high-performance standalone Home Manager environment. Focus on user-space applications, Wayland desktop compositors (Hyprland, Niri, MangoWC), Neovim (nvf) with AI toolchains, dynamic theme synchronization (Stylix, Noctalia, Matugen), shell optimizations, and user-level secrets management.

## Master List of Goals
- [x] Implement Flake architecture decoupling system and user space
- [x] Configure base Wayland compositors (Hyprland, Niri, MangoWC) and user session routing (UWSM)
- [x] Establish user-space secrets management (sops-nix) and SSH/GPG agent socket handling
- [x] Stabilize Hyprland plugins, keybindings, and dynamic workspace rules
- [x] Finalize web browser, GUI apps, and system user utilities
- [ ] Finalize dynamic theming pipeline, asset deduplication (jdupes), and font standardizations
- [ ] Complete Neovim (nvf) configuration, including pure AI toolchain migration and Avante setup
- [ ] Optimize shell environment (Zsh, starship, fastfetch, bat, yazi) and zero-token SSH Git workflow
- [ ] Integrate user-space runtime secrets injection for AI API fallbacks
- [ ] Establish development shells (`devShells`) for multi-language local work

## Shared Overlaps (Nix & Secrets Management)
- [x] **Flake Architecture & Decoupling:** Decoupled `flake.nix` balancing user-space standalone modules with host flake outputs.
- [x] **Declarative Channel Parity:** Standardizing Home Manager module and package scopes strictly on `nixpkgs-unstable` to eliminate ABI mismatches.
- [x] **User Secrets Management:** Integration of `sops-nix` user space secrets with strict runtime file permissions.
- [x] **Zero-Token Git Workflow:** User-level SSH and GPG agent socket routing with SSH URL auto-substitution (`insteadOf = "https://github.com/"`).
- [ ] **User Store Hygiene:** User-profile garbage collection (`nix.gc.automatic = true`, `delete-older-than 7d`, `auto-optimise-store = true`, weekly `hm expire-generations` timer).

## Tasks

### Environment, Plumbing & Dynamic Theming
- [x] `options` (Core-Apps Refactor): Migrate binary variable definitions from `lib.types.package` to `lib.types.str` for accurate `uwsm app --` scope routing.
- [x] `fonts.packages`: Standardize VictorMono Nerd Font and Noto Sans CJK; disable default standard Linux fonts.
- [x] `stylix.enable`: Configure for cursor, GTK, and Qt; explicitly disable color/target generation in favor of Noctalia.
- [ ] `home.activation` (GTK Deduplication): Implement `jdupes --quiet --link-hard --recurse` post-build script for `~/.config/gtk-3.0` and `~/.config/gtk-4.0` via `lib.hm.dag.entryAfter [ "writeBoundary" ]`.
- [ ] `xdg.enable` / `xdg.userDirs.enable`: Declarative standard directory routing (`Desktop`, `Documents`, `Downloads`, `Music`, `Pictures`, `Videos`) with `templates = null` and `publicShare = null`.
- [ ] `fonts.fontconfig.defaultFonts`: Standardize CJK fallback rendering with `noto-fonts-cjk-sans` and fontconfig preferences.
- [x] `home.sessionVariables`: Explicit Wayland environment flags (`NIXOS_OZONE_WL = "1"`, `ELECTRON_OZONE_PLATFORM_HINT = "wayland"`).

### Desktop Shell & Window Managers
- [x] `wayland.windowManager.hyprland.settings`: Configure Hyprland workspace animations (`slidevert`) and dynamic rules.
- [x] `flake.nix` (Hyprglass): Pin plugin input hash explicitly to match host `hyprland` registry.
- [x] `wayland.windowManager.hyprland.settings.bind`: Map `uwsm app -- cliphist list` and `uwsm app -- loginctl activate-session 2` (TTY escape hatch).
- [x] `programs.noctalia.settings`: Finalize Noctalia configuration options.
- [ ] `options.defaultApps.launcher`: Default launcher to `"noctalia-shell toggle-launcher"`.
- [ ] `wayland.windowManager.niri.settings`: Configure Niri window manager with UWSM session execution, scrollable columns, and keybinding parity with Hyprland (`Mod+Return`, `Mod+Space`, `Mod+B`, `Mod+E`, `Mod+Shift+Q`).
- [ ] `wayland.windowManager.mangowc.settings`: Configure MangoWC window manager options in isolated module for testing.

### Neovim & AI Toolchain (nvf)
- [x] `programs.nvf.settings` (Dynamic Theming): Configure `luaConfigRC` to source Matugen cache (`~/.cache/nvim/matugen-colors.lua`) and catch `SIGUSR1` for hot-reloading.
- [x] AI Migration: Strip plain-text API keys from dotfiles.
- [x] `programs.nvf.settings` (Avante): Stabilize `avante.nvim` integration within nvf with proper backend routing and OAuth authentication mapping.
- [x] `programs.nvf.settings` (Supermaven/Codeium): Deploy lightweight autocomplete daemon via OAuth.
- [x] `programs.nvf.settings.visuals.lualine`: Implement custom Lualine bubbles theme components and dynamic LSP status providers.
- [ ] `home.activation.ensureUserSSHKey`: Declaratively generate user SSH key (`~/.ssh/id_ed25519`) before link targets if absent.
- [ ] `sops-nix` User Environment: Map `sops.age.sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ]` to decrypt `ANTHROPIC_API_KEY`, `OPENAI_API_KEY`, and `GEMINI_API_KEY` into session/UWSM environment, configuring Avante provider fallback chain (Copilot -> Claude -> OpenAI).

### GUI Applications & Browsers
- [x] `programs.vesktop.settings`: Discord / Vesktop client customization.
- [x] `programs.zen-browser.enable`: Configure Zen Browser via program options (hardened privacy, custom spaces/containers).
- [ ] `programs.obs-studio.plugins`: Configure OBS Studio plugins (`obs-vaapi`, `obs-vkcapture`, `obs-pipewire-audio-capture`).
- [ ] `home.packages`: Install `prismlauncher` for Minecraft instance management.

### System Utilities
- [x] `programs.yazi.settings`: Modern terminal file manager config.
- [x] `programs.btop.settings`: Resource monitor config.
- [x] `programs.ghostty.settings`: Fast GPU-accelerated terminal emulator setup.
- [x] `programs.tmux.settings`: Terminal multiplexer keybindings (`C-Space`), `smart-splits.nvim` integration, popup windows (`lazygit`, `yazi`).
- [x] `screenshot` (Satty): Managed via Noctalia's built-in capture pipe (`satty -f - --copy-command wl-copy`).
- [x] `dconf.settings`: Configure `org/gnome/desktop/interface.color-scheme = "prefer-dark"` and Nautilus (`default-folder-viewer = "icon-view"`, `show-delete-permanently = true`).
- [x] `systemd.user.timers` / `services`: Configure parameterized `rclone` sync for `gdrive:` to `~/Drive/<remote>` on a 30-minute timer.

### CLI & Shell Optimization
- [x] `programs.git.extraConfig`: Enforce SSH URL substitution (`insteadOf = "https://github.com/"`).
- [x] `programs.git.delta.options`: Pager diff formatting options.
- [x] `programs.zoxide.enableZshIntegration`: Smart cd integration with Zsh.
- [x] `programs.starship.settings`: Shell prompt customization.
- [x] `programs.fastfetch.settings`: System information fetch tool configuration.
- [x] `home.packages`: uv, agy, pastel, opencode.
- [ ] `programs.fzf.defaultOptions`: Fuzzy finder defaults with `fd` default command and `bat` syntax-highlighted preview.
- [ ] `programs.bat.config`: Syntax-highlighted cat alternative with `base16` theme and `bat-extras`.
- [ ] `programs.ripgrep.arguments`: Fast grep defaults with `--hidden` and `.git` ignore globbing.
- [ ] `programs.tealdeer.settings`: tldr cache with `auto_update = true`.
- [ ] `programs.jq.enable`: Declarative JSON processor package integration.
- [ ] `devShells`: Establish declarative development shells in `flake.nix` for Python (`uv`), Rust (`cargo`), Nix (`nil`), and TypeScript.

## Architecture Topics Breakdown
- [x] **AI Authentication Boundaries (`:Copilot auth` vs. `agy`):** Decoupled IDE-level OAuth credential management from terminal multi-agent workflows.
- [x] **Plumbing Derivations (`lib.types.either lib.types.str lib.types.package`):** Dynamic resolution pattern balancing store guarantees with UWSM systemd scope compliance via conditional evaluation helpers.
- [x] **Dynamic Theme Pipeline (`luaConfigRC` & `SIGUSR1`):** Decoupling build-time Nix closures from runtime imperative cache injections (`~/.cache/nvim/matugen.lua`) with asynchronous main-loop signal routing.
- [x] **Declarative Channel Parity (Unstable vs. Stable):** Standardizing standalone Home Manager and package scopes strictly on `nixpkgs-unstable` to prevent shared C++/Rust ABI and header compilation mismatches for binaries like Hyprland plugins.
- [ ] **User Store Hygiene (`nix.gc` & `auto-optimise-store`):** Pruning user profile generations and maintaining local Nix store health.
