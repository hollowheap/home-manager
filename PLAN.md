# Project Plan

## Objective
Configure and complete a modular Home Manager and NixOS environment utilizing standalone Nix modules for desktop, CLI, utility applications, and secure self-hosted infrastructure.

## Master List of Goals
- [ ] Establish persistent NixOS architecture (Disko, LUKS, BTRFS)
- [ ] Configure Secure Boot (sbctl) and native GRUB (Minegrub)
- [x] Implement Flake architecture decoupling system and user space
- [ ] Configure base Wayland compositors (Hyprland, Niri, MangoWC) and Session Management (UWSM, Greetd)
- [ ] Establish system secrets management (sops-nix) and dynamic DNS (ddclient)
- [x] Finalize dynamic theming pipeline, asset deduplication, and font standardizations
- [x] Stabilize Hyprland plugins, hardware suspend states, and core shortcuts
- [x] Finalize web browser, GUI apps, and system utilities
- [x] Complete Neovim (nvf) configuration, including pure AI toolchain migration and Avante setup
- [x] Optimize shell environment and zero-token SSH Git workflow
- [ ] Deploy sovereign Vaultwarden mesh network (Headscale) and WebAuthn PAM
- [ ] Establish development shells (`devShells`) for multi-language local work

## Tasks

### System Foundation & Core Architecture
- [ ] **System Foundation:** Disko LUKS/BTRFS partitioning, ephemeral root abandoned.
- [ ] **Bootloader:** Declarative GRUB (Minegrub theme), manual `sbctl` Secure Boot.
- [x] **Architecture:** Decoupled `flake.nix` (System vs. Home Manager).
- [ ] **Networking:** NetworkManager link management, `ddclient` DuckDNS sync.
- [ ] **Secrets:** `sops-nix` deployment with strict permissions.
- [x] **Shell:** Declarative Zsh, pure plugins, `fzf-tab`, `zsh-vi-mode`, `batpipe`.
- [x] **Session Management:** `xdg-desktop-portal`, Noctalia Polkit/Greeter, `uwsm` Wayland routing.
- [x] **Neovim Base:** NVF framework, strict jumps (`hardtime`), decoupled themes.

### Environment, Theming, and Plumbing
- [x] `options` (Core-Apps Refactor): Migrate binary variable definitions from `lib.types.package` to `lib.types.str` for accurate `uwsm app --` scope routing.
- [ ] `home.activation` (GTK Deduplication): Implement `jdupes --linkhard` post-build script for Mactahoe SVG caching.
- [x] `fonts.packages`: Standardize VictorMono Nerd Font and Noto Sans CJK; disable default standard Linux fonts.
- [x] `stylix.enable`: Configure for cursor, GTK, and Qt; explicitly disable color/target generation in favor of Noctalia.
- [ ] `xdg.enable` / `xdg.userDirs.enable`: Declarative standard directory routing.
- [x] `home.sessionVariables`: Explicit Wayland environment flags (`NIXOS_OZONE_WL = "1"`).

### Desktop Shell and Window Managers
- [x] `wayland.windowManager.hyprland.settings`: Configure Hyprland workspace animations (`slidevert`) and dynamic rules.
- [x] `flake.nix` (Hyprglass): Pin plugin input hash explicitly to match host `hyprland` registry.
- [ ] `boot.kernelParams` (Nvidia): Append `"nvidia.NVreg_PreserveVideoMemoryAllocations=1"` to fix ACPI suspend freeze.
- [x] `wayland.windowManager.hyprland.settings.bind`: Map `uwsm app -- cliphist list` and `uwsm app -- loginctl activate-session 2` (TTY escape hatch).
- [x] `programs.noctalia.settings`: Finalize Noctalia configuration options.
- [ ] `programs.niri.settings`: Configure Niri window manager options.
- [ ] `wayland.windowManager.mangowc.settings`: Configure MangoWC window manager options.

### Neovim & AI Toolchain (nvf)
- [x] `programs.nvf.settings` (Dynamic Theming): Configure `luaConfigRC` to source Matugen cache (`~/.cache/nvim/matugen-colors.lua`) and catch `SIGUSR1` for hot-reloading.
- [x] AI Migration: Strip plain-text API keys from dotfiles.
- [x] `programs.nvf.settings` (Avante): Stabilize `avante.nvim` integration within nvf with proper backend routing and OAuth authentication mapping.
- [x] `programs.nvf.settings` (Supermaven/Codeium): Deploy lightweight autocomplete daemon via OAuth.
- [x] `programs.nvf.settings.visuals.lualine`: Implement custom Lualine bubbles theme components and dynamic LSP status providers.
- [ ] `sops-nix` / Environment: Inject necessary fallback AI API keys securely at runtime.

### GUI Applications & Browsers
- [x] `programs.zen-browser.enable`: Configure Zen Browser via program options.
- [x] `home.packages`: pear-desktop, prismlauncher (Modrinth fallback).
- [x] `programs.obs-studio.settings`
- [x] `programs.vesktop.settings`

### System Utilities
- [x] `programs.yazi.settings`
- [ ] `dconf.settings`: Nautilus and core GNOME apps.
- [x] `programs.btop.settings`
- [x] `programs.ghostty.settings`
- [ ] `xdg.configFile."satty/config.toml"`
- [ ] `systemd.user.timers` / `services`: Configure `rclone` for Google Drive/OneDrive sync.

### CLI and Shell Optimization
- [x] `programs.git.extraConfig`: Enforce SSH URL substitution (`insteadOf = "https://github.com/"`).
- [x] `programs.git.delta.options`
- [x] `programs.fzf.defaultOptions`
- [x] `programs.zoxide.enableZshIntegration`
- [x] `programs.tealdeer.settings`
- [x] `programs.starship.settings`
- [x] `programs.fastfetch.settings`
- [x] `programs.jq.enable`
- [x] `programs.bat.config`
- [x] `programs.lazygit.settings`
- [x] `programs.fd.extraOptions`
- [x] `programs.ripgrep.arguments`
- [x] `home.packages`: uv, agy, pastel, opencode.
- [ ] `devShells`: Establish declarative development shells for local project languages and tooling.

### Sovereign Networking & Secrets Management
- [ ] `services.headscale.enable`: Deploy control plane for mesh network; enable MagicDNS for immutable internal hostnames.
- [ ] `services.vaultwarden.enable`: Deploy native container/service; inject `ADMIN_TOKEN` via `sops-nix`.
- [ ] `services.caddy.enable`: Intercept incoming DuckDNS traffic; terminate Let's Encrypt SSL; proxy to `localhost:8080`.
- [ ] `security.pam.services`: Route KeePassXC/Vaultwarden WebAuthn challenges to local `hyprpolkitagent` (fprintd/sudo).
- [x] `services.ssh-agent.enable` / `programs.gnupg.agent.enable`: Native systemd agent socket handling for zero-token Git architecture.
- [ ] Home Manager Secret Management: Integrate user-space secret handling patterns.

## Architecture Topics Breakdown
- [x] **AI Authentication Boundaries (`:Copilot auth` vs. `agy`):** Decoupled IDE-level OAuth credential management from terminal multi-agent workflows.
- [x] **Plumbing Derivations (`lib.types.either lib.types.str lib.types.package`):** Dynamic resolution pattern balancing store guarantees with UWSM systemd scope compliance via conditional evaluation helpers.
- [x] **Dynamic Theme Pipeline (`luaConfigRC` & `SIGUSR1`):** Decoupling build-time Nix closures from runtime imperative cache injections (`~/.cache/nvim/matugen.lua`) with asynchronous main-loop signal routing.
- [x] **Declarative Channel Parity (Unstable vs. Stable):** Standardizing standalone Home Manager and package scopes strictly on `nixpkgs-unstable` to prevent shared C++/Rust ABI and header compilation mismatches for binaries like Hyprland plugins.
- [ ] **Automated Store Hygiene (`nix.gc` & `auto-optimise-store`):** Hybrid GC infrastructure lifecycle management ensuring user and system profiles are pruned alongside automatic block-level deduplication.
