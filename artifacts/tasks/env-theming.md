# Task: Environment, Plumbing & Dynamic Theming (from PLAN.md)

- [x] `options` (Core-Apps Refactor): Binary variable definitions migrated from packages to string commands for accurate `uwsm app --` scope routing.
- [x] `fonts.packages`: Standardized VictorMono Nerd Font and Noto Sans CJK with fontconfig fallback rendering.
- [x] `stylix.enable`: Configured for cursor (`Bibata-Modern-Classic`), GTK, and Qt; explicitly disable color generation in favor of Noctalia.
- [x] `qt.platformTheme`: Switched `qt.platformTheme.name = "gtk3"` to bridge Qt apps to `MacTahoe-Dark` via `libqgtk3.so` without relying on missing `qt6ct.conf`.
- [x] `dconf.settings`: Synchronized non-Stylix keys (`gtk-theme = "MacTahoe-Dark"`, `icon-theme = "mactahoe-icon-theme-latest-dark"`, `migrated-gtk-settings = true`, and persistent `org/gtk/settings/file-chooser` preferences) while retaining Stylix authority over fonts, cursor size (`20`), and cursor theme.
- [x] `xdg.enable` / `xdg.userDirs.enable`: Declarative standard directory routing (`Desktop`, `Documents`, `Downloads`, `Music`, `Pictures`, `Videos`) with `templates = null` and `publicShare = null`.
- [x] `home.sessionVariables`: Explicit Wayland and Nvidia environment flags (`LIBVA_DRIVER_NAME`, `GBM_BACKEND`, `NIXOS_OZONE_WL`, `ELECTRON_OZONE_PLATFORM_HINT`).
- [x] `pkgs.mactahoe-gtk-theme` / `mactahoe-icon-theme`: Custom package derivations with `jdupes` hardlinking during build.
- [x] `home.activation` (GTK Deduplication): Implement `jdupes --quiet --link-hard --recurse` post-build script for `~/.config/gtk-3.0` and `~/.config/gtk-4.0` via `lib.hm.dag.entryAfter [ "writeBoundary" ]`.
- [ ] `pkgs.mactahoe-gtk-theme` / Noctalia Dynamic Theme Sync: Inject `@define-color accent_color {{ colors.primary.default.hex }};` into `~/.config/gtk-3.0/gtk.css` and `~/.config/gtk-4.0/gtk.css` via Noctalia template to dynamically adapt MacTahoe (default `#0088FF`) to active wallpaper scheme (`#c58462` copper / `#808aeb` lavender).
