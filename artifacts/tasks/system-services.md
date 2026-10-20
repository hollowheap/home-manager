# Task: System Utilities & Services (from overview.md)

- [x] `programs.yazi`: Modern terminal file manager configuration.
- [x] `programs.btop.settings`: Resource monitor config with `btop-cuda` and Noctalia theme.
- [x] `programs.ghostty.settings`: Fast GPU-accelerated terminal emulator setup.
- [x] `programs.tmux.settings`: `C-Space` prefix, `smart-splits.nvim` integration, popup windows (`lazygit`, `yazi`).
- [x] `dconf.settings`: Gnome interface prefer-dark and Nautilus preferences (`default-folder-viewer = "icon-view"`, `show-delete-permanently = true`).
- [x] `services.rcloneSync`: Parameterized `rclone` sync for `gdrive:` to `~/Drive/<remote>` on a 30-minute systemd user timer.
- [x] `services.gpg-agent`: Configured with `pinentry-gnome3` and SSH support.
- [x] `modules/services/store-hygiene.nix`: User store hygiene automation (`nix.gc.automatic = true`, `--delete-older-than 7d`, and weekly `hm expire-generations` timer).
- [x] `services.sops`: Setup `sops-nix` boilerplate with `.sops.yaml` (following `nixos-config`), `secrets.yaml`, and age key configuration for encrypted secret tracking in Git.
