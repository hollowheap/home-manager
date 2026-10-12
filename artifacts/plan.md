# Implementation Plan: Refine Statusline Layout, Icons, Extensions & Inactive Buffer Styling

## Objective
Refine Neovim's statusline (`modules/programs/nvim.nix`) based on user feedback:
1. Replace first pill (`lualine_a`) icon with lambda (`󰘧`).
2. Fix filetype icon using `mini.icons` dynamic resolution instead of a hardcoded icon.
3. Reposition filename to section `z` (with Snacks buffer picker click handler, dynamic file icon, modified/readonly flags).
4. Dedicate section `y` to filetype pill (dynamic icon via `mini.icons`) and section `x` to search count (when active) / LSP status.
5. Disable statusline on dashboard buffers (`snacks_dashboard`, `dashboard`, `alpha`).
6. Fix inactive buffer statusline: move to `z` and use cohesive, high-contrast colors (`base03` muted accent with `base07` body and `base00` text).
7. Create dedicated Avante statusline extension (`Avante`, `AvanteInput`, etc.) styled as split-pills.
8. Update `_G.update_lualine_theme` to preserve `options.disabled_filetypes` and custom extensions on palette reload.

## Proposed Layout
- **Left Side**:
  - `lualine_a`: Mode pill with lambda icon (`󰘧 NORMAL / INSERT / VISUAL / ...`).
  - `lualine_b`: Git branch pill (` branch`).
  - `lualine_c`: Git diff (`+`, `~`, `-`) & diagnostics.
- **Right Side**:
  - `lualine_x`: Search count pill (` current/total`) when active.
  - `lualine_y`: Filetype pill (`[mini.icons] filetype`).
  - `lualine_z`: Filename pill (`[mini.icons] filename [/]`).
- **Inactive Buffers**:
  - `inactive_sections.lualine_z`: Muted filename pill (`[mini.icons] filename`) in `base03`/`base07`.
- **Avante Buffers**:
  - Dedicated extension with split-pill `󱚣 AVANTE` / `AVANTE INPUT` / `CHAT` pills.

## Master List of Goals
- [x] Update `modules/programs/nvim.nix`:
  - [x] Change mode icon in `lualine_a` to lambda `󰘧`.
  - [x] Clean up `lualine_b` to host git branch pill.
  - [x] Configure `lualine_x` for search count pill.
  - [x] Configure `lualine_y` for filetype pill with `mini.icons.get("filetype", ft)`.
  - [x] Configure `lualine_z` for filename pill with `mini.icons.get("file", fname)`, modified/readonly flags, and click handler.
  - [x] Configure `inactive_sections.lualine_z` for inactive filename pill and clear other inactive sections.
  - [x] Add `disabled_filetypes.statusline = [ "snacks_dashboard" "dashboard" "alpha" ]`.
  - [x] Add dedicated Avante extension for `Avante*` filetypes.
  - [x] Update `_G.update_lualine_theme` to merge options safely with `require("lualine").get_config()`.
- [x] Build & Verify:
  - [x] Test headless Neovim on normal file, active search, dashboard, inactive buffer, and Avante buffer.
  - [x] Run `nix eval .#homeConfigurations.hollowheap.activationPackage.drvPath`.
  - [x] Run `nix flake check --no-build`.
