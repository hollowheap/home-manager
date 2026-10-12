# Implementation Plan: Align Neovim Statusline with tmux status-right

## Objective
Update `modules/programs/nvim.nix` so that its statusline components (`lualine`) mirror the exact two-tone split-pill visual structure of tmux's `status-right` (`#[fg=accent]#[fg=black,bg=accent]icon #[fg=black,bg=white] text #[fg=white]`).

## Master List of Goals
- [x] Define `_G.mk_pill` in `modules/programs/nvim.nix` (`luaConfigRC.startupTime`):
  - Left rounded cap `` in `accent` color on bar background (`base00`).
  - Icon segment with black foreground on `accent` background (`icon .. " "`).
  - Content segment with black foreground on bright white (`base07`) background (`" " .. content .. " "`).
  - Right rounded cap `` in bright white (`base07`) on bar background (`base00`).
- [x] Configure `statusline.lualine.setupOpts.sections` in `modules/programs/nvim.nix`:
  - `lualine_a`: Mode pill using mode-driven Wallust/base16 accent colors (`base0D` Normal, `base0B` Insert, `base0E` Visual, `base08` Replace, `base0A` Command).
  - `lualine_b`: Filename pill in `base0C` (Cyan) and Git branch pill in `base0E` (Magenta), keeping Snacks buffer & branch picker click actions.
  - `lualine_c`: Diff & diagnostics.
  - `lualine_x`: Filetype pill in `base0C` (Cyan).
  - `lualine_y`: Search count pill in `base0A` (Yellow).
  - `lualine_z`: Position & progress pill in `base0D` (Blue).
  - `inactive_sections.lualine_a`: Subdued inactive filename pill in `base03`/`base01`.
- [x] Configure `_G.update_lualine_theme`:
  - Pure black bar background (`base00`) across all modes and sections.
  - Empty `section_separators` and `component_separators`.
- [x] Verify:
  - Run headless Neovim to print `lualine.statusline(1)` and check rendered highlights.
  - Test `nix eval .#homeConfigurations.hollowheap.activationPackage.drvPath`.
  - Test `nix build .#homeConfigurations.hollowheap.config.programs.nvf.finalPackage --no-link`.
  - Run `nix flake check --no-build`.
