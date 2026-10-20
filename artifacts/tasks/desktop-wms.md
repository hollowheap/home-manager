# Task: Desktop Shell & Window Managers (from overview.md)

- [x] `wayland.windowManager.hyprland.settings`: Hyprland workspace animations (`slidevert`), scrolling layout (`scrolling.column_width = 0.67`), multi-monitor positioning (`DP-1`, `HDMI-A-1`, `eDP-1`), and dynamic window/layer rules.
- [x] `pkgs.hyprlandPlugins.hyprglass`: Packaged and pinned Hyprglass shader plugin (nested under `pkgs/hyprland-plugins/`) for glass/blur effects.
- [x] `programs.noctalia.settings`: Finalized Noctalia shell configuration (status bar capsule groups, DDCutil brightness control, widgets, Satty screenshot pipeline).
- [x] `options.defaultApps.launcher`: Default launcher option reconciliation (`noctalia msg panel-toggle launcher`).
- [x] `wayland.windowManager.hyprland.bind`: Special workspace window minimize (`SUPER + I` movetoworkspacesilent to `special:minimized`) and toggle (`SUPER + SHIFT + I` togglespecialworkspace).

