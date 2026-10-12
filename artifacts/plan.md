# Project Plan: Pill Terminal UI Style Abstraction & Alignment

## Objective
Abstract the pill terminal UI style (`` / ``) into a shared module in `modules/styles/pills.nix`. Apply the pill abstraction to `tmux`, `starship`, and `nvim` (lualine). Move git indicators (`git_branch`, `git_status`) in `starship` to `right_format`. Implement abstraction-level inversion logic for starship pills (reversing content/accent for right prompt). Refactor Neovim statusline pills to follow `{leftSeparator}{color1-6}{icon} {colorChange}{content}{rightSeparator}` with inverted fg and bg on separators and theme-driven colors.

## Master List of Goals
- [x] Create `modules/styles/pills.nix` defining the pill UI abstraction with options and helpers for `tmux`, `starship`, and `lualine`.
- [x] Refactor `modules/programs/tmux.nix` to consume `config.styles.pills` helpers.
- [x] Update `modules/styles/pills.nix`:
  - Add `invert` support to `starship.mkSplitPill` and `tmux.mkSplitPill` (reversing segment order, colors, and caps).
  - Add `mkPillFn` to `lualine` providing a Lua helper that formats pills in `{leftSeparator}{color1-6}{icon} {colorChange}{content}{rightSeparator}` with inverted separator colors.
- [x] Update `modules/shell/starship.nix`:
  - Set `invert = true` on `cmd_duration`, `git_branch`, and `git_status`.
  - Set `textBg = "black"` for `git_status` and update status symbols to keep `bg:black` with their respective text colors.
- [x] Update `modules/programs/nvim.nix`:
  - Use `_G.mk_pill` in Lualine sections matching `{leftSeparator}{color1-6}{icon} {colorChange}{content}{rightSeparator}`.
  - Map mode colors to Wallust / base16 color slots: Normal (`base0D` / Blue), Insert (`base0B` / Green), Visual (`base0E` / Magenta), Replace (`base08` / Red), Command (`base0A` / Yellow).
  - Configure filename (`base0C` / Cyan), branch (`base0E` / Magenta), filetype (`base0C` / Cyan, inverted), and location (`base0D` / Blue, inverted).
- [x] Verification & Testing:
  - Run `nix eval .#homeConfigurations.hollowheap.activationPackage.drvPath`.
  - Test starship rendering with `starship prompt` and `starship prompt --right`.
  - Test Neovim headless statusline rendering.
  - Run `nix flake check --no-build`.
