# Project Plan: Pill Terminal UI Style Abstraction

## Objective
Abstract the pill terminal UI style (`` / ``) into a shared module in `modules/styles/pills.nix`. Apply the pill abstraction to `tmux`, `starship`, and `nvim` (lualine). Move git indicators (`git_branch`, `git_status`) in `starship` from the cluttered left prompt to `right_format` styled as pill capsules alongside `cmd_duration`, keeping the left prompt clean.

## Master List of Goals
- [x] Create `modules/styles/pills.nix` defining the pill UI abstraction with options and helpers for `tmux`, `starship`, and `lualine`.
- [x] Refactor `modules/programs/tmux.nix` to consume `config.styles.pills` helpers for `status-right`, `status-left`, `window-status-*`, and the battery script.
- [x] Refactor `modules/shell/starship.nix` to move git info to `right_format` and render git branch, git status, and command duration as pills using `config.styles.pills.starship`.
- [x] Refactor `modules/programs/nvim.nix` to source lualine pill separators from `config.styles.pills.lualine` and adjust theme styling for visible pill contrast.
- [x] Verify nix evaluation with `nix eval .#homeConfigurations.hollowheap.activationPackage.drvPath` and `nix flake check --no-build`.
- [x] Verify prompt output with `starship prompt` and `starship prompt --right`.

## Tasks
- [x] Task 1: Create `modules/styles/pills.nix`
  - Defined `styles.pills.enable` and `styles.pills.symbols` (`left = ""`, `right = ""`).
  - Defined `styles.pills.tmux` with `mkPill` and `mkSplitPill`.
  - Defined `styles.pills.starship` with `mkPill` and `mkSplitPill`.
  - Defined `styles.pills.lualine` with `separator`, `leftCap`, and `rightCap`.
- [x] Task 2: Refactor `modules/programs/tmux.nix`
  - Replaced hardcoded pill strings in `status-right`, `status-left`, `window-status-format`, `window-status-current-format`, and `batteryScript` with `config.styles.pills`.
- [x] Task 3: Refactor `modules/shell/starship.nix`
  - Removed `$git_branch` and `$git_status` from `format` on the left.
  - Set `right_format` to include `$cmd_duration$git_branch$git_status`.
  - Formatted `$git_branch`, `$git_status`, and `$cmd_duration` with `config.styles.pills.starship.mkSplitPill`.
- [x] Task 4: Refactor `modules/programs/nvim.nix`
  - Replaced hardcoded `separator` in `statusline.lualine` with `config.styles.pills.lualine.separator`, `leftCap`, and `rightCap`.
  - Ensured `lualine_b` has contrasting background (`colors.base02`) in `_G.update_lualine_theme` so pill caps render visibly.
- [x] Task 5: Testing and Verification
  - Ran `nix eval .#homeConfigurations.hollowheap.activationPackage.drvPath` (passed).
  - Tested starship rendering with `starship prompt` and `starship prompt --right` (clean left prompt, pills on right prompt).
  - Ran `nix flake check --no-build` (passed).
