# Implementation Plan: Starship No-Runtimes Preset & Bubble-Pill Styling

## Objective
Customize Starship prompt in `modules/shell/starship.nix`:
1. **Character Module**:
   - `format = "$symbol "`
   - `success_symbol = "[◎](bold italic bright-yellow)"`
   - `error_symbol = "[○](italic purple)"`
   - `vimcmd_symbol = "[■](italic dimmed green)"`
2. **Inspiration from `https://starship.rs/presets/no-runtimes`**:
   - Strip runtime version numbers across all language/runtime modules (54 modules: bun, c, cpp, rust, python, nodejs, golang, etc.).
3. **Unified Bubble-Pill Format**:
   - Apply the rounded split-pill / bubble format used by `git_branch`:
     - `directory`: `[]($style)[󰉋 ](bg:prev_fg fg:black)[ $path](bg:bright-white fg:black)[$read_only](bg:bright-white fg:bright-red)[](prev_bg) `
     - `git_branch`: `on [](cyan)[$symbol](bg:prev_fg fg:black)[ $branch](bg:bright-white fg:black)[](prev_bg) `
     - `git_status`: `([](bright-yellow)[󱈸 ](bg:prev_fg fg:black)[ $all_status$ahead_behind](bg:bright-white fg:black)[](prev_bg) )`
     - `cmd_duration`: `took [](bright-blue)[󱑂 ](bg:prev_fg fg:black)[ $duration](bg:bright-white fg:black)[](prev_bg) `
     - `nix_shell`: `via [](blue)[$symbol](bg:prev_fg fg:black)[ $state](bg:bright-white fg:black)[](prev_bg) `
     - Language runtimes: `via []($style)[$symbol](bg:prev_fg fg:black)[](prev_bg) `

## Tasks
- [x] Edit `modules/shell/starship.nix`.
- [x] Test with `starship prompt` and `starship prompt --right`.
- [x] Nix build and evaluate activation package.
- [x] Commit changes.

---



## Objective
Enforce the consistent color architecture across all Wallust templates and Neovim:
1. **Base16 Neutrals (`base00`–`base07`)**:
   - Pinned monochrome ramp from `#000000` to `#ffffff` without dynamic/ANSI color leakage into selection, comments, or dark foregrounds.
2. **Bright ANSI Accents (`base08`–`base0F`)**:
   - Map syntax/accent slots to high-contrast bright ANSI variants:
     - `base08`: `{{color9}}` (Bright Red: Variables, XML Tags, Errors)
     - `base09`: `{{color1}}` (Normal Red / Warm tone: Constants, Numbers)
     - `base0A`: `{{color11}}` (Bright Yellow: Classes, Types, Search)
     - `base0B`: `{{color10}}` (Bright Green: Strings, Diff Inserted)
     - `base0C`: `{{color14}}` (Bright Cyan: Regex, Escape Characters)
     - `base0D`: `{{color12}}` (Bright Blue: Functions, Methods)
     - `base0E`: `{{color13}}` (Bright Magenta: Keywords, Storage)
     - `base0F`: `{{color5}}` (Normal Magenta / Violet: Embedded Tags)
3. **Propagate Bright Variants Across Templates**:
   - `assets/wallust-templates/bat.tmTheme`: Upgrade remaining normal ANSI accents to bright variants (Keywords `color13`, Operators `color14`, Strings `color10`, Functions `color12`, Types `color11`, Tags `color9`).
   - `assets/wallust-templates/lazygit.yml`: Use bright variants (`color12`, `color11`, `color14`, `color13`, `color9`).
   - `assets/wallust-templates/btop.theme`: Use bright variants for title (`color12`), hi_fg (`color14`), proc_misc (`color13`), and gradient endpoints (`color9`, `color10`, `color11`, `color12`, `color13`, `color14`).
   - `assets/wallust-templates/flavor.toml`: Use bright variants (`color12`, `color11`, `color10`, `color9`, `color13`, `color14`).
   - `modules/programs/nvim.nix`: Align fallback base16 palette with identical monochromatic ramp and bright accents.

## Tasks
- [x] Update `assets/wallust-templates/nvim-colors.lua`.
- [x] Update `assets/wallust-templates/bat.tmTheme`.
- [x] Update `assets/wallust-templates/lazygit.yml`.
- [x] Update `assets/wallust-templates/btop.theme`.
- [x] Update `assets/wallust-templates/flavor.toml`.
- [x] Update fallback palette in `modules/programs/nvim.nix`.
- [x] Build & Verify:
  - [x] Nix build nvf package.
  - [x] Run headless Neovim test script with updated `nvim-colors.lua`.
  - [x] Nix eval activationPackage and nix flake check --no-build.
- [x] Commit changes.

---



## Objective
Refine Neovim statusline and Wallust configuration according to user requirements:
1. **Statusline Section Positioning**: Keep section positioning consistent between active and inactive windows. Move filename back to `lualine_b` (accompanied by git branch). Set inactive filename in `inactive_sections.lualine_b` with muted colors (`base03`/`base01`/`base04`). Set `lualine_z` to filetype pill. Clear `lualine_y`.
2. **Avante Extension Styling**:
   - For `AvanteInput`: Single pill with keyboard icon `󰌌` and label `"Input"`.
   - For `AvanteSelectedCode`: Single pill with code icon `` and label `"Code"`.
   - For `Avante` (chat log): Single pill with chat icon `󰭹` and label `"Chat"`.
   - Clear `lualine_b` in the Avante extension to eliminate the redundant second bubble.
   - Provide corresponding muted single pill in `inactive_sections`.
3. **Wallust Saturation Configuration**:
   - Set `saturation = 35;` in `modules/environment/wallust.nix` under `programs.wallust.settings`.
4. **Template Neutral Pins**:
   - Ensure `fg`, `bg`, `cursor`, color 7, and color 8 are pinned in Wallust templates (already complete).

## Tasks
- [x] Edit `modules/programs/nvim.nix`:
  - [x] Update `lualine_b` to include filename pill and git branch pill.
  - [x] Update `lualine_z` to filetype pill; empty `lualine_y`.
  - [x] Update `inactive_sections.lualine_b` to filename pill with muted colors (`base03`/`base01`/`base04`); clear other inactive sections.
  - [x] Update Avante extension to single pill (`Chat`, `Input` with `󰌌`, `Code`), clear `lualine_b`.
  - [x] Refine `_G.mk_pill` hl_id generation to include all color components for collision-free highlights.
- [x] Build & Test:
  - [x] Nix build nvf package.
  - [x] Headless Neovim test for split window active/inactive statuslines and Avante buffers.
  - [x] Nix flake check --no-build and nix eval activationPackage.
- [x] Commit changes.

---



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

---

# Implementation Plan: Agent Triggers, Contracts, Gaps, Renderer all-Mode

## Objective
Apply approved agent ratings: (1) trigger-style descriptions, (2) renderer-side `all`-mode support in `modules/programs/opencode.nix` (other harnesses already pass capabilities through or ignore mode), (4) return contracts, (5) skill gaps, (6) orchestrator fan-out scope. Effort mapping (3) deferred.

## Tasks
- [x] Rewrite 6 agent descriptions in `modules/ai/agents.nix` (What + When + trigger).
- [x] Fix `mkAgent` mode mapping in `modules/programs/opencode.nix` (`both→all`).
- [x] Add return contracts (research/reviewer/writer) + orchestrator fan-out line.
- [x] Close skill gaps: writer+=tdd, reviewer+=rules-git/question, research+=question, architect+=artifact-shell.
- [x] Verify: `nix eval` agent attrs, `nix flake check --no-build`.

---

# Implementation Plan: Disciplines as Addressable Rules + Harness Overrides

## Objective
Restructure `ai.disciplines` from monolithic `content` strings to named `rules` attrsets so each line is addressable. Harness renderers gain a drop-list override removing lines their built-in prompts already cover (verified: opencode + crush cover generic conciseness; pi/kiro/antigravity/copilot unverified → no drops).

## Tasks
- [x] Schema: `options/ai.nix` discipline `content` → `rules = attrsOf (nullOr lines)`.
- [x] Base: `modules/ai/disciplines.nix` rewritten as named rules, all lines kept.
- [x] Overrides: 6 renderers filter nulls + per-harness drop lists (opencode/crush drop `unslop.{concise,no-restate,dense}`).
- [x] Verify: eval opencode context (trimmed) vs pi context (full), `nix flake check --no-build`.

---

# Implementation Plan: Commit Restructure, Tool-Only Questions, Report Formula, Kiro Strip, Codex + Hermes

## Objective
Resolve harness conflicts structurally (never command what built-ins forbid): rules-git shapes but never orders commits, milestones move to artifacts discipline. Question skill goes tool-only (drop CLI fallback + script); wire opencode `question` tool. New `report` output formula with unslop carve-out. Kiro strips `web` for subagents. New codex + hermes renderers (schemas verified against docs/nixpkgs).

## Tasks
- [x] rules-git de-commanded; artifacts += milestones; architect/engineer/tdd lines aligned.
- [x] Question skill tool-only, script removed; opencode `question` tool mapped from skills.
- [x] `report` discipline added; unslop no-restate carved out.
- [x] Kiro `web` stripped for subagent-only agents.
- [x] `modules/programs/codex.nix` + `modules/programs/hermes.nix` renderers.
- [x] Verify: eval all surfaces, `nix flake check --no-build`.
