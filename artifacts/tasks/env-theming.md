# Task: Environment, Plumbing & Dynamic Theming (from PLAN.md)

- [x] `options` (Core-Apps Refactor): Binary variable definitions migrated from packages to string commands for accurate `uwsm app --` scope routing.
- [x] `fonts.packages`: Standardized VictorMono Nerd Font and Noto Sans CJK with fontconfig fallback rendering.
- [x] `stylix.enable`: Configured for cursor (`Bibata-Modern-Classic`), GTK, and Qt; explicitly disable color generation in favor of Noctalia.
- [x] `xdg.enable` / `xdg.userDirs.enable`: Declarative standard directory routing (`Desktop`, `Documents`, `Downloads`, `Music`, `Pictures`, `Videos`) with `templates = null` and `publicShare = null`.
- [x] `home.sessionVariables`: Explicit Wayland and Nvidia environment flags (`LIBVA_DRIVER_NAME`, `GBM_BACKEND`, `NIXOS_OZONE_WL`, `ELECTRON_OZONE_PLATFORM_HINT`).
- [x] `pkgs.mactahoe-gtk-theme` / `mactahoe-icon-theme`: Custom package derivations with `jdupes` hardlinking during build.
- [x] `home.activation` (GTK Deduplication): Implement `jdupes --quiet --link-hard --recurse` post-build script for `~/.config/gtk-3.0` and `~/.config/gtk-4.0` via `lib.hm.dag.entryAfter [ "writeBoundary" ]`.
