# AI Config Program Plan

## Objectives
High-level and stable; distilled from the project overview (artifacts/tasks/overview.md) for the ai.* system.
- [x] Capability-based multi-harness schema rendering agents, skills, and rules from one source.
- [x] Conflict-free layering: shared base plus per-harness overrides, no built-in duplication.
- [x] Capability-gated rules: procedures render only where the tools exist.
- [x] Question tooling mapped on opencode, antigravity, and crush; conversational fallback on remaining kept harnesses.

## Tasks
Per-initiative execution checklists below. Append new work; closed initiatives move to artifacts/tasks/.

## Open Follow-ups
- [x] Decide harness cull: Dropped per user preference; keeping all harnesses as-is.
- [ ] Hermes config.yaml merge strategy: managed file clobbers outside user keys.
- [x] Confirm codex skills discovery: Verified on live run (`codex debug prompt-input` proves `r0 = ~/.codex/skills`).
- [x] Scope crush union delegate rule: Retained clean single-prompt agent union per user preference.
- [ ] Revisit codex/hermes discipline drops once base prompts are observed.

---

# Implementation Plan: Powerline Pill Colors & Icons for Pi Statusline

## Objective
Apply colors and two-tone powerline pill formatting to `modules/programs/pi-coding-agent.nix` in `home-manager`:
1. **Pill Formatting & Accent Palette**:
   - `a` (Mode): `accent: "bright-yellow"`, `icon: "󰘧"`, `idleText: "IDLE"`, `workingText: "WORKING"`, `bold: true`
   - `b` (Branch): `accent: "bright-cyan"`, `icon: ""`
   - `c` (Diff): `accent: "bright-yellow"`, `icon: "󱈸"`, `addedIcon: "+"`, `modifiedIcon: "~"`, `removedIcon: "-"`, `untrackedIcon: "?"`
   - `d` (CWD): `accent: "bright-blue"`, `icon: ""`, `depth: 3`, `homeAsTilde: true`
   - `w` (Model): `accent: "bright-purple"`, `icon: "󰚩"`, `shorten: true`
   - `x` (Tokens): `accent: "bright-blue"`, `icon: "󰕲"`, `showInput: true`, `showOutput: true`
   - `y` (Context): `accent: "bright-green"`, `icon: "󰍛"`
   - `z` (Clock): `accent: "bright-magenta"`, `icon: "󱑂"`, `format: "HH:mm"`
2. **Separators**:
   - `componentSeparator: " "`
   - `sectionSeparator: "  "`
   - `gitIntervalMs: 5000`

## Tasks
- [x] Update `statuslineContent` in `modules/programs/pi-coding-agent.nix`.
- [x] Verify `nix eval` and `nix flake check --no-build`.
- [x] Commit changes cleanly.

---

# Implementation Plan: Mode & Budget Extension Components for Pi Statusline

## Objective
Update the Pi statusline configuration in `modules/programs/pi-coding-agent.nix` to integrate the `mode-guard` and `budgets` extensions exposed by `pi-mode-guard` without altering `my-pi-agent`:
1. **Extension Declaration**:
   - Add `extensions = [ "mode-guard" "budgets" ];` to the root of `statuslineContent`.
2. **Component Configuration**:
   - `a` (Mode): Replace built-in `"mode"` with `"mode-guard"`, setting `accent = "bright-yellow"`, `fg = "bright-yellow"`, `icon = "󰘧"`, and `bold = true`.
   - `v` (Budgets): Add a new section `v` preceding model/tokens with `type = "budgets"`, `accent = "bright-yellow"`, `fg = "bright-yellow"`, and `icon = "󰄩"`.
3. **Pill & Palette Consistency**:
   - Preserve existing two-tone pill formatting and color harmony.

## Tasks
- [x] Update `statuslineContent` in `modules/programs/pi-coding-agent.nix`.
- [x] Evaluate `statusline.json` generation and run `nix flake check --no-build`.
- [x] Commit changes cleanly following git conventions.

---

# Implementation Plan: Synthesize Two-Tone Pill for Mode Extension in Pi Statusline

## Objective
Enable full two-tone powerline pill rendering for `mode-guard` strictly via JSON configuration in `modules/programs/pi-coding-agent.nix` without modifying `my-pi-agent`:
1. **Pill Synthesis in Section `a`**:
   - Set `componentSeparator = ""` in `options` so multi-part components within a section join seamlessly without gaps.
   - Compose section `a` using:
     - Left cap `` (`fg: "bright-yellow"`)
     - Icon block `󰘧 ` (`fg: "black"`, `bg: "bright-yellow"`, `bold: true`)
     - Leading space ` ` (`fg: "black"`, `bg: "bright-white"`, `bold: true`)
     - Extension component `mode-guard` (`fg: "black"`, `bg: "bright-white"`, `bold: true`)
     - Trailing space ` ` (`fg: "black"`, `bg: "bright-white"`, `bold: true`)
     - Right cap `` (`fg: "bright-white"`)
2. **Preserve Isolation for Other Sections**:
   - Other sections remain single-component, separated by `sectionSeparator = "  "`.
   - `budgets` in section `v` retains `fg = "bright-yellow"` and `bold = true` so it collapses cleanly when empty.

## Tasks
- [x] Update `statuslineContent` in `modules/programs/pi-coding-agent.nix`.
- [x] Evaluate `statusline.json` and run `nix flake check --no-build`.
- [x] Commit changes cleanly.

---

# Implementation Plan: Separate Colorscripts into Packages (hollowheap & hollowpi)

## Objective
Extract inline colorscripts into dedicated Nix packages under `pkgs/` and add the new `hollowpi-colorscript`:
1. **Package Creation**:
   - `pkgs/hollowheap-colorscript.nix`: Package for `hollowheap-colorscript` displaying the 8-line hollowheap ASCII art with blue-to-purple gradient.
   - `pkgs/hollowpi-colorscript.nix`: Package for `hollowpi-colorscript` displaying the 6-line hollow-pi ASCII art with smooth 6-step gradient.
2. **Package Registration & Discovery**:
   - Both packages are auto-discovered by `pkgs/default.nix` into `pkgs.hollowheap-colorscript` and `pkgs.hollowpi-colorscript`.
   - Add both packages to `modules/core/packages.nix` for global availability.
3. **Module Integration**:
   - `modules/programs/nvim.nix`: Remove inline `hollowHeapColorscript` script derivation; reference `pkgs.hollowheap-colorscript`.
   - `modules/programs/pi-coding-agent.nix`: Remove inline `hollowHeapColorscript` script derivation; reference `pkgs.hollowpi-colorscript` in dashboard.json.

## Tasks
- [x] Create `pkgs/hollowheap-colorscript.nix`.
- [x] Create `pkgs/hollowpi-colorscript.nix`.
- [x] Add packages to `modules/core/packages.nix`.
- [x] Update `modules/programs/nvim.nix` to use `pkgs.hollowheap-colorscript`.
- [x] Update `modules/programs/pi-coding-agent.nix` to use `pkgs.hollowpi-colorscript`.
- [x] Stage new files by name (`skills/nix-flake-eval`), evaluate, build both derivations, and verify `nix flake check --no-build`.
- [x] Commit changes cleanly following git conventions.

---

# Implementation Plan: Align dashboard.json to pi-dashboard Schema

## Objective
Fix `dashboard.json` generation in `modules/programs/pi-coding-agent.nix` to match `pi-dashboard`'s schema instead of Snacks-nvim's schema:
1. **Schema Correction**:
   - `pi-dashboard` schema accepts `{ width: number, source: { command: string, args: string[] } }` or `{ source: { ascii: string[] } }`.
   - Replace `{ enabled = true; sections = [ ... ]; }` with:
     ```nix
     {
       width = 80;
       source = {
         command = "${pkgs.hollowpi-colorscript}/bin/hollowpi-colorscript";
         args = [ ];
       };
     }
     ```
2. **Verification**:
   - Verify `dashboard.json` matches `normalizeConfig` in `packages/pi-dashboard`.
   - Run `nix flake check --no-build` and `activationPackage` evaluation.

## Tasks
- [x] Update `dashboardFile` in `modules/programs/pi-coding-agent.nix`.
- [x] Verify `nix eval` on `dashboard.json` and run `nix flake check --no-build`.
- [x] Commit changes cleanly.

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

---

# Implementation Plan: Discipline-Led Hygiene, Skills, Completeness, Memory

## Objective
New always-on disciplines (hygiene, skills, complete, memory) with renderer drops where native; rules-git trimmed to shaping-only; question gains ask-last + tries; per-agent skill coherence (no capability without its skills, no skills without its capability).

## Tasks
- [x] Add hygiene/skills/complete/memory disciplines + opencode/crush drops.
- [x] Trim rules-git safety lines; question workflow ask-last + tries rule.
- [x] Architect -= artifact-shell; reviewer -= rules-git.
- [x] Verify: eval rendered contexts, `nix flake check --no-build`.

---

# Implementation Plan: Capability-Gated Rules Engine (ai.rules)

## Objective
New `modules/ai/rules.nix`: rules carry a required capability intersection and render into an agent's instructions only on match. Migrate capability-bound procedures out of skills (hunks/shell/commits/tests/logs) + hygiene/memory disciplines (clean-hands/no-destroy/no-secrets/record) + orchestrator fan-out. Skills keep discovery workflows (plan/question/nav-repomap); disciplines keep universal-only.

## Tasks
- [x] Schema `ai.rules` in options/ai.nix; `modules/ai/rules.nix` with 10 rules.
- [x] Delete migrated skills + hygiene/memory disciplines; update agent skill lists and instruction refs.
- [x] 6 renderers append matched rules per-agent; crush renders union.
- [x] Verify: engineer/research/reviewer matrices, `nix flake check --no-build`.

---

# Implementation Plan: Session-Learned Skills (Workspace + Global)

## Objective
Distill this session into skills: workspace-local SKILL.md files (nix-flake-eval, renderer-author) + AGENTS.md pointer; global ai.skills additions (shared-tree, upstream-recon, overlap-check). Terse format throughout.

## Tasks
- [x] Write skills/nix-flake-eval/SKILL.md + skills/renderer-author/SKILL.md.
- [x] Reformat AGENTS.md with workspace skills index.
- [x] Append 3 skills to modules/ai/skills.nix.
- [x] Stage new files; `nix flake check --no-build`.

---

# Implementation Plan: Finalize AI Capability Matrix & Prompt Roster Refactor

## Objective
Finalize and land the staged and pending AI refactor:
1. Document the capability matrix, rules, and surface mapping in `artifacts/matrix.md`.
2. Extract per-area task checklists from the root PLAN.md (since retired) into `artifacts/tasks/`.
3. Clarify `plan.md` ownership (engineer maintains; architects/orchestrators contribute via plan skill) across `modules/ai/agents.nix`, `modules/ai/disciplines.nix`, and `modules/ai/skills.nix`.
4. Eliminate agent prompt duplication in single-surface harnesses (`modules/programs/codex.nix`, `modules/programs/crush.nix`, `modules/programs/opencode.nix`).
5. Reference `artifacts/matrix.md` in `skills/renderer-author/SKILL.md`.

## Tasks
- [x] Stage all AI matrix and roster refactor files by explicit path.
- [x] Verify `nix flake check --no-build` and `activationPackage` evaluation.
- [x] Commit cleanly as a milestone following conventional commits (`0cfb688`).

---

# Implementation Plan: User Store Hygiene Automation (nix.gc & generation pruner systemd timers)

## Objective
Implement automated user store hygiene and generation expiration in Home Manager to satisfy the project overview Objective 34:
1. Declaratively configure `nix.gc` to run weekly with `--delete-older-than 7d`.
2. Configure a weekly systemd user service and timer to expire Home Manager generations older than 7 days using `home-manager expire-generations "-7 days"`.
3. Verify evaluation of systemd services/timers and ensure no unmanaged runtime store leakage.
4. Update the user store hygiene checkboxes.

## Tasks
- [x] Test failing condition / evaluate current absent state for store hygiene timers.
- [x] Implement `modules/services/store-hygiene.nix` with `nix.gc` and `systemd.user.services.home-manager-expire-generations`.
- [x] Verify `nix eval` on generated systemd units and `nix flake check --no-build`.
- [x] Update the project overview status.
- [x] Commit cleanly with conventional commit message.

---

# Implementation Plan: TypeScript / Web Development Shell

## Objective
Finalize the declarative `devShells.ts` in `flake.nix` providing Node.js, TypeScript language server, `pnpm`, `bun`, `deno`, `typescript`, and `biome`, with aliases `typescript` and `js`:
1. Verify `devShells.ts` builds and tools execute cleanly.
2. Verify `nix flake check --no-build` and `activationPackage` evaluation.
3. Commit cleanly following conventional commits.

## Tasks
- [x] Test `ts-dev` shell commands (`node`, `tsc`, `bun`, `pnpm`).
- [x] Stage `flake.nix` and `flake.lock`.
- [x] Commit cleanly with conventional commit message.


---

# Implementation Plan: GTK Theme Deduplication Activation Hook

## Objective
Implement `home.activation.deduplicateGtk` in `modules/theme/stylix.nix` (or dedicated module) using `jdupes --quiet --link-hard --recurse` across `~/.config/gtk-3.0` and `~/.config/gtk-4.0` via `lib.hm.dag.entryAfter [ "writeBoundary" ]`:
1. Add `home.activation.deduplicateGtk` DAG hook.
2. Verify evaluation of `activationPackage` and `nix flake check --no-build`.
3. Check off task in `artifacts/tasks/env-theming.md`.
4. Commit cleanly following conventional commits.

## Tasks
- [x] Implement `deduplicateGtk` activation DAG entry in `modules/theme/stylix.nix`.
- [x] Verify `activationPackage` evaluation and `nix flake check --no-build`.
- [x] Update `artifacts/tasks/env-theming.md`.
- [x] Commit cleanly with conventional commit message.

---

# Implementation Plan: Declarative GTK3 Theme Bridge on Qt & Prism Launcher

## Objective
Configure declarative Qt theming to use the native GTK3 platform theme bridge, matching the active MacTahoe GTK theme across Qt applications (including Prism Launcher):
1. Configure `qt.platformTheme.name = "gtk3"` in `modules/theme/stylix.nix`.
2. Remove hardcoded imperative `QT_QPA_PLATFORMTHEME = "qt6ct"` from `modules/core/env.nix` in favor of declarative module options.
3. Add `prismlauncher` to `home.packages` in `modules/core/packages.nix`.
4. Update `artifacts/tasks/gui-apps.md`.
5. Verify `nix eval` on `config.qt.platformTheme` and run `nix flake check --no-build`.

## Tasks
- [x] Update `modules/theme/stylix.nix` with `qt.platformTheme.name = "gtk3"`.
- [x] Remove `QT_QPA_PLATFORMTHEME` from `modules/core/env.nix`.
- [x] Add `prismlauncher` to `modules/core/packages.nix`.
- [x] Verify `nix eval` and `nix flake check --no-build`.
- [x] Update `artifacts/tasks/gui-apps.md`.
- [x] Commit cleanly with conventional commit message.

---

# Implementation Plan: Harness Path Alignments (Antigravity to ~/.gemini/antigravity-cli, Pi to APPEND_SYSTEM.md)

## Objective
1. Consolidate all Antigravity CLI files under `~/.gemini/antigravity-cli/` instead of `~/.gemini/config/`:
   - Agents in `~/.gemini/antigravity-cli/agents/${name}/agent.md`.
   - Rules in `~/.gemini/antigravity-cli/rules/${name}.md`.
   - Skills remain under `~/.gemini/antigravity-cli/skills/${name}` managed by `programs.antigravity-cli.skills`.
2. Move Pi coding agent shared disciplines from `context` (`AGENTS.md`) into `appendSystem` (`APPEND_SYSTEM.md`):
   - Preserves Pi's default system prompt while cleanly adding disciplines to `<addendum>`.
   - Leaves agent roster in `context` (`AGENTS.md`).
3. Keep Codex (`~/.codex/AGENTS.md`), Copilot (`copilot-instructions.md`), and Hermes (TODO) as requested.
4. Update `artifacts/matrix.md` to reflect the updated harness surfaces.
5. Verify evaluation with `nix eval` and `nix flake check --no-build`.

## Tasks
- [x] Migrate Antigravity agent and rule file targets to `.gemini/antigravity-cli/` in `modules/programs/antigravity.nix`.
- [x] Move disciplines to `appendSystem` in `modules/programs/pi-coding-agent.nix`.
- [x] Verify `homeConfigurations.hollowheap.config` evaluation.

---

# Implementation Plan: Desktop Apps, Zen Hardening & WebHID, Qt Dark Theme & Dconf Reconciliation

## Objective
Address desktop integration, Zen browser fixes, hardening categorization, Qt dark theme, and dconf state:
1. **Default Desktop Apps**: Declaratively wire `xdg.mimeApps` default applications for web (`zen-twilight.desktop`) and mail/calendar (`thunderbird.desktop`). Update `defaultApps.mail` in `modules/options/apps.nix`.
2. **Zen Browser WebHID & Space Routing**: Enable `dom.webhid.enabled = true;`, resolve pin position collisions, set `spaceRouting.force = true;`, and explain the `.parentlock` active session behavior.
3. **Browser Hardening**: Categorize existing preferences into organized blocks (Network Shunts, Telemetry & Tracking, Fingerprinting, Media/WebRTC) and add WebRTC IP leak protection (`media.peerconnection.ice.default_address_only = true;`).
4. **Qt Dark Theme Analysis**: Diagnose the live session `QT_QPA_PLATFORMTHEME=qt6ct` vs built `gtk3` state, and configure declarative fallbacks.
5. **Dconf Review**: Present comparison between live `dconf dump /` and `modules/core/dconf.nix`.
6. **Accounts.* & MacTahoe Color Architecture Research**: Document `accounts.email` Thunderbird integration and dynamic Noctalia CSS color injection in `artifacts/`.

## Tasks
- [x] Enable WebHID and fix space routing / pin positions in `modules/programs/zen-browser.nix`.
- [x] Configure `xdg.mimeApps` in `modules/programs/zen-browser.nix` (or `modules/programs/default-apps.nix`) and update `modules/options/apps.nix`.
- [x] Organize and expand browser hardening in `modules/programs/zen-browser.nix`.
- [x] Document live dconf diff, `accounts.*` research, and MacTahoe Noctalia theme pipeline.
- [x] Verify `nix eval` and `nix flake check --no-build`.

---

# Implementation Plan: Zen Browser Sane Hardening, Cleanup, Mods & Extensions

## Objective
Analyze `modules/programs/zen-browser.nix` against `brainfucksec.github.io/firefox-hardening-guide`, BetterZen, and Zen Browser upstream defaults. Identify breakage culprits, remove config bloat/redundancies, introduce sane hardening additions, evaluate extensions (culling obsolete ones like LocalCDN), and recommend top Zen mods.

## Analysis & Findings
1. **Critical Breakage in Current Config**:
   - `privacy.firstparty.isolate = true`: Deprecated Tor Uplink FPI; severely breaks cross-domain OAuth (Google/Microsoft SSO, university portals), breaks embedded content, and conflicts with Total Cookie Protection & Zen Containers/Spaces. Must be removed.
   - `privacy.resistFingerprinting = true`: Forces UTC timezone on JS `Date()` (breaks calendars, LMS deadlines), breaks dark theme (`prefers-color-scheme: light`), enforces letterboxing, and breaks canvas. Replace with modern Fingerprinting Protection (`privacy.fingerprintingProtection = true`) and keep Zen's canvas siphash randomization.
   - `breakpad.reportURL = false`: Boolean instead of string `""`, redundant with `policies.DisableTelemetry = true`.
   - `browser.safebrowsing.provider.* = ""`: Disables all local phishing/malware blocklist updates. Recommend switching to `browser.safebrowsing.downloads.remote.enabled = false` (stops telemetry upload of downloads to Google, while preserving local malware list updates).
2. **Sane Hardening Additions**:
   - `network.http.referer.XOriginTrimmingPolicy = 2` (trim cross-origin referrers to scheme+host+port).
   - `network.dns.disablePrefetchFromHTTPS = true` & `network.predictor.enabled = false`.
   - Native cookie banner rejection: `cookiebanners.service.mode = 1` and `.privateBrowsing = 1`.
   - CRLite enforcing mode: `security.pki.crlite_mode = 2` & `security.remote_settings.crlite_filters.enabled = true`.
   - SSD wear reduction: `browser.sessionstore.interval = 60000`.
   - External file hygiene: `browser.helperApps.deleteTempFileOnExit = true`.
   - Subresource auth phishing protection: `network.auth.subresource-http-auth-allow = 1`.
3. **Extensions Review**:
   - Remove `localcdn-fork-of-decentraleyes`: Obsolete in modern browsers due to Total Cookie Protection cache partitioning; increases fingerprint surface and breaks modern site assets.
   - Optional additions: `skip-redirect` (bypasses redirect trackers).
4. **Zen Mods Recommendations**:
   - Better Find Bar (`a6335949-4465-4b71-926c-4a52d34bc9c0`)
   - SuperPins (`ad97bb70-0066-4e42-9b5f-173a5e42c6fc`)
   - Zen Context Menu (`81fcd6b3-f014-4796-988f-6c3cb3874db8`)
   - Extensions List (`181e41d4-dfd3-410d-9a73-561381a2f77d`)
   - Pimp your PiP (`599a1599-e6ab-4749-ab22-de533860de2c`)

## Tasks
- [x] Present comprehensive analysis and recommendations to user.
- [x] Apply approved sane changes and cleanups to `modules/programs/zen-browser.nix`.
- [x] Verify evaluation with `nix eval` / `nix flake check --no-build`.

---

# Implementation Plan: Search Engine Aliases & Space Routing

## Objective
1. Configure `policies.SearchEngines.Add`:
   - `@nix` on MyNixOS (`https://mynixos.com/search?q={searchTerms}`)
   - `@yt` on YouTube (`https://www.youtube.com/results?search_query={searchTerms}`)
   - `@gh` on GitHub (`https://github.com/search?q={searchTerms}`)
2. Add hygiene policies:
   - `OverrideFirstRunPage = "";` and `OverridePostUpdatePage = "";`
   - `UserMessaging` (disable marketing and recommendation popups)
   - `PDFjs` (safe PDF permissions)
3. Ensure Space Routing coverage:
   - Route `youtube.com` and `youtu.be` to `Entertainment` space alongside `www.youtube.com`.
4. Verify with `nix eval` and `nix flake check --no-build`.

## Tasks
- [x] Add SearchEngine aliases and policies in `modules/programs/zen-browser.nix`.
- [x] Update Space Routing rules for Entertainment (`youtube.com`, `youtu.be`).
- [x] Verify evaluation with `nix eval` and `nix flake check --no-build`.

---

# Implementation Plan: URL Bar Suggestions (Hybrid Configuration)

## Objective
Configure URL bar suggestions in `modules/programs/zen-browser.nix` with the user's chosen Hybrid approach:
1. **Local Suggestions First**:
   - `browser.urlbar.suggest.history = true`
   - `browser.urlbar.suggest.bookmark = true`
   - `browser.urlbar.suggest.openpage = true`
   - `browser.urlbar.showSearchSuggestionsFirst = false` (prioritize local matches above search engine terms)
2. **Live Search Completions**:
   - `browser.search.suggest.enabled = true`
   - `browser.urlbar.suggest.searches = true`
3. **No Sponsored / Telemetry / Top Sites Distractions**:
   - `browser.urlbar.suggest.topsites = false`
   - `browser.urlbar.suggest.quicksuggest.sponsored = false`
   - `browser.urlbar.suggest.quicksuggest.nonsponsored = false`
   - `browser.urlbar.trending.featureGate = false`
   - `browser.urlbar.addons.featureGate = false`
   - `browser.urlbar.mdn.featureGate = false`
   - `browser.urlbar.pocket.featureGate = false`
   - `browser.urlbar.weather.featureGate = false`
   - `browser.urlbar.yelp.featureGate = false`
4. Verify with `nix eval` and `nix flake check --no-build`.

## Tasks
- [x] Add URL bar suggestion preferences in `modules/programs/zen-browser.nix`.
- [x] Verify evaluation with `nix eval` and `nix flake check --no-build`.

---

# Implementation Plan: Zen Mods Update & Culling

## Objective
Update the `profiles.default.mods` list in `modules/programs/zen-browser.nix`:
1. **Swap Container Mods**:
   - Remove: Container Halo (`cb5efa80-f1e1-43ce-8c0b-fece8462d225`)
   - Add: Colored container tab (`3ff55ba7-4690-4f74-96a8-9e4416685e4e`)
2. **Add New Requested Mods**:
   - Private Mode Highlighting (`58649066-2b6f-4a5b-af6d-c3d21d16fc00`)
   - Left close button (`6f11c932-b992-433e-8c80-56a613cc511e`)
3. **Remove Redundant / Unmaintained Mods**:
   - Remove: Zen Context Menu (`81fcd6b3-f014-4796-988f-6c3cb3874db8` - covered by Lean)
   - Remove: Load Bar (`ae7868dc-1fa1-469e-8b89-a5edf7ab1f24` - unmaintained, designed for single toolbar while user uses dual toolbar)
   - Remove: Tab Preview Enhanced (`87196c08-8ca1-4848-b13b-7ea41ee830e7` - unmaintained, superseded by native Zen tab hover preview)
4. Verify with `nix eval` and `nix flake check --no-build`.

## Tasks
- [x] Update `profiles.default.mods` in `modules/programs/zen-browser.nix`.
- [x] Verify evaluation with `nix eval` and `nix flake check --no-build`.

---

# Implementation Plan: Theming, Wallust Bugfix, Vesktop, Fonts, Hyprland Minimize & Shared LSP

## Objective
1. **Wallust Empty Line Bugfix**:
   - Strip trailing newline from `assets/wallust-templates/sequences`.
   - Sanitize hook in `modules/environment/wallust.nix` with `tr -d '\r\n'` to prevent newline injection into `/dev/pts/*`.
2. **Stylix Font Sizes**:
   - Reduce font sizes by 1 in `modules/theme/stylix.nix`: `applications = 11; desktop = 9; popups = 9; terminal = 11;`.
3. **Noctalia Scheme**:
   - Update `wallpaper_scheme = "faithful";` in `modules/environment/noctalia.nix`.
4. **Vesktop Noctalia Colors**:
   - Disable `stylix.targets.vesktop.enable = false;` in `modules/theme/stylix.nix` so `noctalia.theme.css` applies without Stylix collision.
5. **MacTahoe Dynamic Theming**:
   - Add Noctalia template for GTK CSS (`assets/noctalia-templates/gtk-accent.css`) and configure `gtk3` and `gtk4` user templates in `modules/environment/noctalia.nix`.
6. **Hyprland Window Minimize via Special Workspaces**:
   - Add `SUPER + I` (minimize to `special:minimized`) and `SUPER + SHIFT + I` (toggle `minimized` workspace) in `modules/environment/hyprland.nix`.
7. **Declarative LSP Architecture**:
   - Present options for unifying language servers across `nvf` and AI harnesses.

## Tasks
- [x] Fix Wallust sequences template and `/dev/pts/*` hook.
- [x] Update Stylix font sizes and disable Vesktop target in `modules/theme/stylix.nix`.
- [x] Set Noctalia `wallpaper_scheme = "faithful"` and add GTK accent templates in `modules/environment/noctalia.nix`.
- [x] Add Hyprland window minimize & restore bindings in `modules/environment/hyprland.nix`.
- [x] Verify evaluation with `nix eval` and `nix flake check --no-build`.

---

# Implementation Plan: Pico SDK 2.3.1 Override & Option B Declarative LSP Toolchains

## Objective
1. **Pico SDK 2.3.1 Override**:
   - Create `pkgs/pico-sdk.nix` overriding nixpkgs `pico-sdk` to version `2.3.1` (with submodules hash `sha256-ZWGJNQwbkGlgZnEoOoMishX4ANZAqqkMeck8uZlewVk=` and non-submodules hash `sha256-UWWrZT7Mg2yei/LlDxgei3yXWaP9ETMlgiVOFFAEMZ8=`).
   - Reference `pkgs.pico-sdk` in `flake.nix` `devShells.pico`.
2. **Option B: Flake Toolchain Export to DevShells & Home Manager**:
   - Define canonical `toolchains` attribute set in `flake.nix` covering:
     - `nix`: `nil`, `nixfmt`
     - `ts`: `nodejs`, `pnpm`, `bun`, `deno`, `typescript`, `typescript-language-server`, `biome`
     - `rust`: `cargo`, `rustc`, `rustfmt`, `clippy`, `rust-analyzer`
     - `python`: `python3`, `uv`, `basedpyright`, `ruff`
     - `c`: `clang-tools`, `cmake`, `gnumake`, `gdb`, `gcc`
     - `pico`: `cmake`, `gnumake`, `gcc-arm-embedded`, `pico-sdk`, `python3`
   - Wire `devShells` from `toolchains`.
   - Pass `toolchains` into `extraSpecialArgs` for Home Manager so modules can reference shared packages without duplication.
   - Configure `nvim.nix` / `direnv` integration.
3. **Verification**:
   - Verify `nix eval` on `pkgs.pico-sdk.version` returns `"2.3.1"`.
   - Verify `devShells` build and `nix flake check --no-build` passes.

## Tasks
- [x] Create `pkgs/pico-sdk.nix` with version 2.3.1.
- [x] Refactor `flake.nix` to define canonical `toolchains` and update `devShells`.
- [x] Pass `toolchains` to `extraSpecialArgs` in `flake.nix`.
- [x] Stage new files by name (`skills/nix-flake-eval`), evaluate, and test all devShells.
- [x] Run `nix flake check --no-build`.

---

# Implementation Plan: Tone Down Pill Contrast to Black Bodies (tmux, nvim, starship)

## Objective
Replace bright-white pill bodies with black backgrounds across tmux, nvim,
and starship. Icons stay wrapped in accent pills; text renders on black.

## Tasks
- [x] Simplify `modules/programs/tmux.nix` pills (battery, status-left/right,
  window formats) to icon pill + black-body text.
- [x] Simplify `modules/programs/nvim.nix` `_G.mk_pill` + call sites to icon
  pill + black-body text.
- [x] Simplify `modules/shell/starship.nix` pills (directory, git_branch,
  git_status, cmd_duration, nix_shell) to icon pill + black-body text.
- [x] Verify `nix eval` on edited surfaces and `nix flake check --no-build`.

---

# Implementation Plan: Closed Icon Pills, Darker Accents, White Glyphs (everywhere)

## Objective
Close each icon pill with its own `` separator, darken icon pill
backgrounds to non-bright accents, and render icon glyphs in white.
Applies to starship, tmux, and nvim alike.

## Tasks
- [x] Render-test new pill ANSI with live starship binary.
- [x] Update `modules/shell/starship.nix`: closer after every icon block,
  `bright-blue→blue`, `bright-yellow→yellow`, icon `fg:black→fg:white`.
- [x] Update `modules/programs/tmux.nix`: same treatment (`bright-*→*`,
  white glyphs, icon closers).
- [x] Update `modules/programs/nvim.nix`: `mk_pill` gains shaded icon pill +
  closer, white glyphs.
- [x] Verify `nix eval` on edited surfaces and `nix flake check --no-build`.

---

# Implementation Plan: Extract tmux-battery into pkgs/tmux-battery.nix

## Objective
Move the inline tmux battery script out of `modules/programs/tmux.nix`
into an auto-discovered `pkgs/tmux-battery.nix` package (repomap wrapper
idiom), and reference `${pkgs.tmux-battery}/bin/tmux-battery` from status-left.

## Tasks
- [x] Create `pkgs/tmux-battery.nix` and stage it by name.
- [x] Rewire `modules/programs/tmux.nix` to the package; drop inline script.
- [x] Verify: build package, execute it (exit 0), `nix flake check --no-build`.

---

# Implementation Plan: Nvim keymap remap (r-namespace, motions, leader LSP)

## Objective
Apply the approved keymap table to `modules/programs/nvim.nix`: `r`
becomes a replace-namespace prefix (`rr`/`rR`/`r~`/`ru`/`rU`/`r?`/`rw`/
`rq`/`rp` + line variants), motions `H`/`L`/`gH`/`gL` cover `n v o`,
`J`/`K` scroll without recenter, new `<leader>l*` LSP maps (replacing the
snacks `<leader>lr`), and Nop-clears for all displaced defaults.

## Tasks
- [x] Register: drop `gO`/`+Toggle` groups, add `r` group.
- [x] Disable batches: nvo clears + vo text-objects + n/i singles.
- [x] Motions: `H`/`L`/`gH`/`gL` to nvo, `J`/`K` plain scroll in nv, add `Y`.
- [x] `r`-namespace: prefix Nop, family maps, drop old `r`/`R`.
- [x] Leader LSP: `lh`/`lj`/`ln`/`la`/`lr`/`li`/`lt`/`lo`/`lf`.
- [x] Verify: lua syntax check + keymap eval + flake check.

---

# Implementation Plan: Full nvim spec (plugins, options, autocmds)

## Objective
Apply the approved plugin/option spec to `modules/programs/nvim.nix`:
mini set (bracketed/visits/operators/jump2d/comment/hipatterns/ai),
DAP presets (clang-lldb, python-debugpy) + dap-ui manual start with float
keys, nvim-lint for yaml/zsh, blink ghost off + supermaven ghost on,
avante claude-code without autosuggestions, git-conflict, lualine
quickfix extension, snacks notifier/zen/dim/bigfile/quickfile/rename +
indent scope + recent_files, fidget without notify override, cmdheight 0,
mouse a, ui2, undofile, UserAutocmds augroup (cursor restore, LSP
highlight), fd + ripgrep packages.

## Tasks
- [x] Wire all plugin/option/autocmd changes.
- [x] Verify: lua syntax check + keymap eval + flake check.

---

# Implementation Plan: Dedup supermaven-nvim start/opt double install

## Objective
Resolve `mnw` warning (`supermaven-nvim` in both `startAttrs` and
`optAttrs`): drop the Nix-level dependency from the
`blink-cmp-supermaven` overlay package, keeping the single nvf-managed
copy (eager lz.n spec, ghost text on, keymaps off).

## Tasks
- [x] Remove `supermaven-nvim` from overlay dependencies.
- [x] Verify: warning gone, `nix flake check --no-build`.

---

# Implementation Plan: Fix tiny-cmdline loading and setup

## Objective
`tiny-cmdline.nvim` never floated: its lazy spec had a key-less `keys`
trigger (plugin never loaded) and no `setupModule` (setup never ran).
Load it eagerly with `setupModule = "tiny-cmdline"`.

## Tasks
- [x] Set `lazy = false`, drop bogus keys, add setupModule/setupOpts.
- [x] Verify: eval spec + `nix flake check --no-build`.

---

# Implementation Plan: Harden Noctalia icon-accent pipeline

## Objective
The icon pipeline trusted an undocumented `{{ mode }}` template variable:
garbage output produced nonexistent theme names and poisoned
`icon-theme.cache` forever. Hardcode `dark` (mode is mkForce'd dark) and
sanitize the mode in the hook so any junk self-heals.

## Tasks
- [x] Hardcode dark in `icon-accent.txt`; sanitize mode in post_hook.
- [x] Verify: run rendered hook (valid/garbage/empty/bad-hex/idempotent),
  `nix flake check --no-build`.

---

# Implementation Plan: libadwaita via @import plus scoped gtk dedup

## Objective
libadwaita ignores `gtk-theme-name`, and the theme's own gtk-4.0 support
files were lost to the Nix build sandbox, so libadwaita apps rendered
stock Adwaita. Import the packaged MacTahoe GTK4 stylesheet from
Noctalia's gtk.css via a stable HM symlink (separate gtk4 template so
GTK3 output stays clean), and drop the `deduplicateGtk` hook whose only
effect was hardlinking Noctalia's outputs together.

## Tasks
- [x] Add `gtk4-accent.css` template with `@import`; wire gtk4 input to it.
- [x] Link `gtk-4.0/theme-gtk.css` into the theme package; remove hook.
- [x] Split the live hardlinked gtk.css pair into independent inodes.
- [x] Verify: symlink target exists + `nix flake check --no-build`.

---

# Implementation Plan: Dynamic GTK4 accent via post_hook recolor

## Objective
MacTahoe bakes `#0088FF` into 149 stylesheet refs, so `@define-color`
overrides can't move the visible accent. Recolor the blue family to the
wallpaper accent (hue-matched, depth-preserving) in the gtk4 template
post_hook, writing Noctalia-owned `theme-gtk.css`; drop the HM symlink to
avoid activation collisions.

## Tasks
- [x] Add recolor post_hook to gtk4 template; remove HM theme symlink.
- [x] Verify: hook tests (peach/gray/missing, band census) + flake check.

---

# Implementation Plan: Source-compile MacTahoe accent in gtk hook

## Objective
Replace output-side hex recolor with the defined solution: patch
`$theme_color_default` in the theme source and recompile both GTK
stylesheets with sassc in the post_hook (0.2s), writing self-contained
user css files. Covers GTK3 too via same-selector override.

## Tasks
- [x] Shared `gtkHook` on gtk3+gtk4 templates; static asset symlinks.
- [x] Verify: byte-exact reproduction at default accent, accent shift,
  skip gate, missing inputs, flake check.

---

# Implementation Plan: Wallust-driven GTK accent

## Objective
Take the compile accent from wallust (`color12`, the setup's accent
slot) instead of Noctalia's primary: the hook runs wallust itself
(fresh palette, skip-gated per image, replacing the dummy template
runner), keeping fg from Noctalia's defines.

## Tasks
- [x] Wallust-run + color12 parse in shared hook; drop dummy template.
- [x] Verify: stubbed wallust runs once, accent proven wallust-sourced,
  rerun skips, missing inputs exit 0, flake check.

---

# Implementation Plan: Editor toolchain maps in toolchains.nix

## Objective
Add filetype-keyed `lsp`/`linters`/`formatters`/`debuggers` maps in a new
top-level `toolchains.nix` (flake untouched), mirroring nvf language
defaults, and derive nvim-lint `linters_by_ft` dynamically for the
filetypes language modules don't cover (`yaml`, `zsh`).

## Tasks
- [x] Write `toolchains.nix` and stage it by name.
- [x] Wire dynamic `linters_by_ft` in `modules/programs/nvim.nix`.
- [x] Verify: eval merge + `nix flake check --no-build`.

---

# Implementation Plan: Starship accent-colored text on black

## Objective
Fix the all-black prompt by rendering module text in its pill accent
(`blue`/`cyan`) on the black body, keeping closed icon pills, white
glyphs and darker accents untouched.

## Tasks
- [x] Color directory/branch/duration/state text with accent fg.
- [x] Verify: eval formats + `nix flake check --no-build`.

---

# Implementation Plan: Data-only tmux-battery, pill composed in tmux

## Objective
Stop hardcoding tmux pill escapes in `pkgs/tmux-battery.nix`. The script
emits data only (`color`/`icon`/`pct` modes, `ICON PCT%` by default);
`modules/programs/tmux.nix` status-left composes the icon pill + black
body from those modes and hides the segment when no battery exists.

## Tasks
- [x] Switch package output to data modes without tmux escapes.
- [x] Compose battery pill in tmux status-left via `#()` modes.
- [x] Verify: build, run all modes, render-test nested formats in a live
  tmux server, `nix flake check --no-build`.

---

# Implementation Plan: Dynamic Icon Accent Resolution, Sequences Bugfix & Freeing Ghostty Symlinks

## Objective
1. **Dynamic Icon Pack Accent Resolution & Caching**:
   - In `pkgs/mactahoe-icon-theme.nix`, install all 8 color variants (`bash install.sh -t all -d $out/share/icons`) with `dontFixup = true;` to avoid Nixpkgs fixup hangs.
   - In `modules/environment/noctalia.nix`, add an `icon_accent` template and hook resolving wallpaper accent hex to the nearest MacTahoe color variant (`blue`, `green`, `grey`, `nord`, `orange`, `purple`, `red`, `yellow`) using perceptual hue distance with grey threshold.
   - Cache resolved mapping in `~/.cache/noctalia/icon-theme.cache` so subsequent evaluations skip computation and dconf updates if the accent hasn't changed.
   - Dynamically apply the resolved icon theme via `dconf` and `gsettings`.
2. **Fix Sequences Empty Line Bug**:
   - In `assets/wallust-templates/sequences`, use standard `\007` (BEL) OSC terminator without trailing newline characters.
   - In `modules/environment/wallust.nix`, remove the `sequences` `/dev/pts/*` blast hook. Ghostty natively reloads colors via its `reload-config` action; writing raw OSC to `/dev/pts/*` triggers `.color_change` warnings and causes shells to redraw an empty prompt line.
   - In `modules/shell/zsh.nix`, ensure `~/.cache/wallust/sequences` sourcing strips any whitespace/newlines before terminal output.
3. **Free Ghostty Config from Home Manager Store Symlinks**:
   - In `modules/theme/stylix.nix`, disable `stylix.targets.ghostty.enable = false;` to prevent Stylix from generating an immutable `~/.config/ghostty/config` symlink.
   - In `modules/programs/ghostty.nix`, remove `programs.ghostty.settings` and add an activation script `home.activation.ghosttyConfig` ensuring `~/.config/ghostty/config` is a writable regular file initialized with defaults if missing.
   - In `modules/environment/noctalia.nix`, add `builtin_ids = [ "ghostty" ];` so Noctalia can write to `~/.config/ghostty/themes/noctalia` and update `theme = noctalia` in Ghostty's writable config without permission errors.

## Tasks
- [x] Update `pkgs/mactahoe-icon-theme.nix` with `-t all`, `dontFixup = true;`, and broken symlink pruning.
- [x] Add icon theme accent resolution hook and cache template in `modules/environment/noctalia.nix`.
- [x] Clean `assets/wallust-templates/sequences` and remove `/dev/pts/*` blast hook in `modules/environment/wallust.nix`.
- [x] Free `~/.config/ghostty/config` in `modules/theme/stylix.nix` and `modules/programs/ghostty.nix`.
- [x] Enable `builtin_ids = [ "ghostty" ];` in `modules/environment/noctalia.nix`.
- [x] Verify flake evaluation and build with `nix eval` and `nix flake check --no-build`.

---

# Implementation Plan: Custom Maple Mono Font with Frozen OpenType Features

## Objective
Package and install `maple-mono-custom` freezing OpenType ligature and stylistic features (`calt,cv03,cv09,cv10,cv41,cv42,cv43,cv62,cv65,cv98,cv99,ss03,ss05,ss07,ss08,ss09,ss10,ss11,zero`):
1. Create `pkgs/maple-mono-custom.nix` deriving from `pkgs.maple-mono.truetype` and running `pyftfeatfreeze` on all TTF font files to produce the unified `Maple Mono` font family.
2. Auto-expose via `pkgs/default.nix` into `pkgs.maple-mono-custom`.
3. Add `maple-mono-custom` to `home.packages` and configure `fonts.fontconfig` in `modules/core/fonts.nix`.
4. Apply `maple-mono-custom` (`Maple Mono`) across `stylix.fonts` (`monospace`, `sansSerif`, `serif`) in `modules/theme/stylix.nix` and `modules/programs/ghostty.nix`.
5. Verify package builds and flake checks cleanly.

## Tasks
- [x] Create `pkgs/maple-mono-custom.nix` with `baseFont = maple-mono.truetype` and stage by name.
- [x] Integrate `maple-mono-custom` into `modules/core/fonts.nix`.
- [x] Apply `Maple Mono` in `modules/theme/stylix.nix` and `modules/programs/ghostty.nix`.
- [x] Verify font package build and flake check.

---

# Implementation Plan: Sensible Tmux Keybinds, Passthrough & Split Ergonomics

## Objective
Configure refined keybindings in `modules/programs/tmux.nix`:
1. **Passthrough & Literal Fallbacks**:
   - `bind C-Space send-prefix`: Send literal `Ctrl+Space` on double tap.
   - `bind C-h send-keys C-h`, `bind C-j send-keys C-j`, `bind C-k send-keys C-k`, `bind C-l send-keys C-l`: Fallback to send literal control keys when prefixed with `C-Space` while un-prefixed keys drive `smart-splits`.
   - `set -g allow-passthrough on`: Enable terminal escape sequence passthrough.
2. **Window Navigation**:
   - `bind c new-window -c "#{pane_current_path}"`: Retain current working directory on new window.
   - `bind Tab last-window`: Quick-toggle to last window.
   - `bind -r C-p previous-window`, `bind -r p previous-window`: Previous window navigation.
   - `bind -r C-n next-window`, `bind -r n next-window`: Next window navigation.
   - `bind X kill-window`: Kill current window (capital `X`).
   - `bind b break-pane`: Break active pane into its own window.
   - `bind -n M-1` through `M-9`: Direct window switching 1-9 via `Alt + 1..9` (conflict-free).
3. **Splits & Layout Equalizers (Shift Symmetry)**:
   - Split columns: `bind \\ split-window -h -c "#{pane_current_path}"`
   - Equalize columns: `bind | select-layout even-horizontal` (Shift + `\`)
   - Split rows: `bind - split-window -v -c "#{pane_current_path}"`
   - Equalize rows: `bind _ select-layout even-vertical` (Shift + `-`)
   - Equalize grid: `bind = select-layout tiled`
4. **Popups & Clipboard**:
   - `bind C-t`: Floating scratch shell popup.
   - `bind C-b`: Floating btop monitor popup.
   - `bind -T copy-mode-vi y send -X copy-pipe-and-cancel "wl-copy"`: Wayland clipboard integration.

## Tasks
- [x] Update `modules/programs/tmux.nix` with the new keybinds, layouts, and passthrough.
- [x] Right-align icons in `status-right` (date with calendar icon on right, time with clock icon on right).
- [x] Verify evaluation with `nix eval` and `nix flake check --no-build`.

---

# Implementation Plan: Centralize Font Settings, Reuse Everywhere & Drop Stylix

## Objective
1. **Centralize Font Configuration (`theme.fonts`)**:
   - In `modules/options/theme.nix`, define `theme.fonts` options and defaults:
     - `monospace`: `package` (default: `pkgs.maple-mono-custom`), `name` (default: `"Maple Mono"`).
     - `sansSerif`: `package` (default: `pkgs.google-fonts.override { fonts = [ "Sora" ]; }`), `name` (default: `"Sora"`).
     - `serif`: `package` (default: `pkgs.google-fonts.override { fonts = [ "Literata" ]; }`), `name` (default: `"Literata"`).
     - `emoji`: `package` (default: `pkgs.noto-fonts-color-emoji`), `name` (default: `"Noto Color Emoji"`).
     - `sizes`: `applications` (10), `desktop` (8), `popups` (8), `terminal` (10).
2. **Reuse Centralized Fonts Across Modules**:
   - `modules/core/fonts.nix`: Install font packages from `config.theme.fonts.*.package` plus `pkgs.noto-fonts`, and configure native Home Manager `fonts.fontconfig.defaultFonts` with `monospace`, `sansSerif`, `serif`, `emoji` matching `config.theme.fonts.*.name`.
   - `modules/programs/ghostty.nix`: Dynamic interpolation of `config.theme.fonts.monospace.name`, `config.theme.fonts.emoji.name`, and `config.theme.fonts.sizes.terminal` in the template and live migration script.
   - `modules/core/dconf.nix`: Set GNOME interface font values (`font-name`, `document-font-name`, `monospace-font-name`, `cursor-theme`, `cursor-size`) dynamically referencing `config.theme.fonts` and `config.home.pointerCursor`.
3. **Drop Stylix & Migrate Remaining Theming**:
   - Replace `modules/theme/stylix.nix` with `modules/theme/theme.nix`:
     - Native `gtk` module for theme (`MacTahoe-Dark`), icons (`mactahoe-icon-theme-latest-dark`), and font (`config.theme.fonts.sansSerif.name`, `config.theme.fonts.sizes.applications`).
     - Native `home.pointerCursor` (`Bibata-Modern-Classic`, size 20, with GTK, X11, Hyprcursor enabled).
     - Native `qt.platformTheme.name = "gtk3"`.
     - Retain `home.activation.deduplicateGtk`.
   - In `flake.nix`: Remove `inputs.stylix` and `stylix.homeModules.stylix`.
4. **Verification**:
   - Re-evaluate with `nix eval` and `nix flake check --no-build`.
   - Verify fontconfig alias generation and ghostty config rendering.

## Tasks
- [x] Add `theme.fonts` options in `modules/options/theme.nix`.
- [x] Wire `theme.fonts` in `modules/core/fonts.nix` and `modules/programs/ghostty.nix`.
- [x] Wire font and cursor settings in `modules/core/dconf.nix`.
- [x] Replace `modules/theme/stylix.nix` with native `modules/theme/theme.nix`.
- [x] Remove `stylix` from `flake.nix`.
- [x] Verify evaluation and flake check cleanly.

---

# Implementation Plan: WebHID & Zen Hardening, mimeApps Defaults, Ghostty Keybinds, CLI Freeing & Starship Base16

## Objective
1. **Disable Ghostty Keybinds**:
   - Add `keybind = clear` to `defaultConfig` template in `modules/programs/ghostty.nix` and `~/.config/ghostty/config`.
   - Prevent Ghostty from intercepting shortcuts like `Ctrl+h`, `Ctrl+j`, `Alt+1..9`, allowing clean passthrough to tmux/neovim/zsh.
2. **Zen Browser WebHID & Preference Organization**:
   - In `modules/programs/zen-browser.nix`, enable `"dom.webhid.enabled" = true;`.
   - Structure `policies.Preferences` into clear, cleanly commented categories (Hardware APIs, WebRTC IP Protection, Telemetry, Content Blocking, Cookie Banners, Anti-Fingerprinting).
3. **Comprehensive `xdg.mimeApps` Defaults**:
   - In `modules/programs/default-apps.nix`, associate default applications matching everything installed:
     - Web & PDFs: `zen-twilight.desktop`
     - Mail & Calendar: `thunderbird.desktop`
     - File Manager: `org.gnome.Nautilus.desktop`
     - Terminal: `com.mitchellh.ghostty.desktop`
     - Documents & Office: LibreOffice (`writer.desktop`, `calc.desktop`, `impress.desktop`)
     - Images: `satty.desktop`
     - Media / Audio: `com.github.th-ch.youtube-music.desktop`
     - Messaging: `org.telegram.desktop.desktop`, `vesktop.desktop`, `Zoom.desktop`
     - Gaming: `steam.desktop`
4. **Crush Union Rules**:
   - Resolve follow-up in `artifacts/plan.md`: keep union model across agents.
5. **CLI/TUI App Freeing & Starship Base16 Alignment**:
   - Free `btop` (`~/.config/btop/btop.conf`) from read-only symlinks in `modules/programs/btop.nix` with an activation template.
   - In `modules/shell/starship.nix`:
     - Replace invalid ANSI colors (`purple` -> `magenta`, `bright-purple` -> `bright-magenta`).
     - Fix pill transitions with proper powerline background styling.

## Tasks
- [x] Add `keybind = clear` to `modules/programs/ghostty.nix` and `~/.config/ghostty/config`.
- [x] Enable `dom.webhid.enabled` and organize preferences in `modules/programs/zen-browser.nix`.
- [x] Populate comprehensive `xdg.mimeApps` in `modules/programs/default-apps.nix`.
- [x] Close Crush union follow-up in `artifacts/plan.md`.
- [x] Free `btop` config into writable template in `modules/programs/btop.nix`.
- [x] Align Starship with Base16 ANSI colors and smooth pill dividers in `modules/shell/starship.nix`.
- [x] Verify `nix eval` and `nix flake check --no-build`.

---

# Implementation Plan: Starship Divider Syntax Fix for Base16 Dynamic Colors

## Objective
Fix Starship prompt divider syntax error introduced during Base16 two-tone pill formatting:
1. **Diagnosis**:
   - `[](fg:prev_fg bg:black)` is invalid Starship style syntax. Starship style parser drops the foreground, causing the divider to inherit white foreground and render a white curve against the black body.
   - The correct Starship style syntax is `[](prev_bg bg:black)` (taking previous badge background as divider foreground) and `[](prev_bg)` for pill closing caps.
2. **Execution**:
   - Update `directory`, `git_branch`, `git_status`, `cmd_duration`, and `nix_shell` in `modules/shell/starship.nix`.
   - Verify prompt output with `starship prompt` and `starship prompt --right`.
   - Run `nix eval` and `nix flake check --no-build`.

## Tasks
- [x] Fix divider and cap style strings in `modules/shell/starship.nix`.
- [x] Verify escape sequences with `starship prompt` and `starship prompt --right`.
- [x] Verify `nix eval` and `nix flake check --no-build`.
- [x] Run `home-manager switch --flake ".#hollowheap"`.

---

# Implementation Plan: Starship White Text on Black Body & Ghostty Single Reload

## Objective
1. **Starship Pill Text Contrast**:
   - In `modules/shell/starship.nix`, update text segments in `directory`, `git_branch`, `cmd_duration`, and `nix_shell` to use `fg:white` on `bg:black` instead of dark accent colors (`fg:blue`, `fg:cyan`) so text is clearly readable on black bodies.
2. **Ghostty Double Reload Fix**:
   - In `modules/environment/wallust.nix`, remove redundant `hooks.ghostty` since Noctalia already manages `builtin_ids = [ "ghostty" ]` and reloads Ghostty's config directly.

## Tasks
- [x] Remove `hooks.ghostty` from `modules/environment/wallust.nix`.
- [x] Set text foreground to `fg:white` in `modules/shell/starship.nix`.
- [x] Verify `nix flake check --no-build` and `home-manager switch`.

---

# Implementation Plan: Wallust-Owned Ghostty Theming & Clean Separation from Noctalia

## Objective
1. **Noctalia Separation**:
   - In `modules/environment/noctalia.nix`, empty `templates.builtin_ids = [ ];` so Noctalia does not generate Ghostty themes or trigger DBus reloads.
2. **Wallust Ghostty Ownership**:
   - In `modules/environment/wallust.nix`, restore `hooks.ghostty` so Wallust triggers `reload-config` whenever it updates `~/.config/ghostty/themes/wallust`.
   - In `modules/programs/ghostty.nix`, configure `theme = wallust` in template and activation script.
3. **Verify**:
   - `nix flake check --no-build` and switch.

## Tasks
- [x] Remove `ghostty` from Noctalia `builtin_ids`.
- [x] Restore `hooks.ghostty` in `wallust.nix`.
- [x] Set `theme = wallust` in `ghostty.nix`.
- [x] Verify `nix flake check --no-build` and `home-manager switch`.

---

# Implementation Plan: Switch to Maple Mono NF for Full Nerd Font & Powerline Glyphs

## Objective
Fix missing Starship prompt icons and Powerline pill curves by deriving `maple-mono-custom` from `maple-mono.NF` instead of `maple-mono.truetype`:
1. **Package**:
   - In `pkgs/maple-mono-custom.nix`, switch `baseFont` to `maple-mono.NF` (`Maple Mono NF`).
   - Patch `opentype_feature_freezer` runtime call to monkeypatch `fontTools` so TTX table processing succeeds on Nerd Font tables.
2. **Font Configuration**:
   - In `modules/options/theme.nix`, update `theme.fonts.monospace.name` to `"Maple Mono NF"`.
   - Update Ghostty config template and active config to `font-family = Maple Mono NF`.
3. **Verify**:
   - `nix flake check --no-build` and switch.

## Tasks
- [x] Build `maple-mono-custom` from `maple-mono.NF`.
- [x] Update font name to `Maple Mono NF` in `theme.nix` and `ghostty.nix`.
- [x] Remove `sed` mutations from `ghostty.nix` and rely purely on DBus reload.
- [x] Verify `nix flake check --no-build` and switch.

---

# Implementation Plan: Pure Ghostty Reload Strategy & Zero Config Emission

## Objective
Cease all Ghostty configuration emissions from Home Manager and adopt Noctalia's native `reload.sh` logic exclusively for Ghostty lifecycle signals:
1. **Packaging**:
   - Create `pkgs/ghostty-reload.nix` replicating Noctalia's multi-tier primary PID resolution (systemd service -> DBus `GetConnectionUnixProcessID` -> GTK `reload-config` -> safe `SIGUSR2` fallback on non-primary pids).
2. **Ghostty Module**:
   - In `modules/programs/ghostty.nix`, completely remove `defaultConfig` and config file emission. Ghostty is configured purely by the user / themes outside Nix HM clobbering.
   - Replace activation block with pure `ghostty-reload`.
3. **Wallust Hook**:
   - In `modules/environment/wallust.nix`, update `hooks.ghostty` to call `ghostty-reload`.
4. **Verification**:
   - Evaluate flake with `nix flake check --no-build`.
   - Verify `ghostty-reload` execution.
   - Deploy via `home-manager switch --flake ".#hollowheap"`.

## Tasks
- [x] Create `pkgs/ghostty-reload.nix`.
- [x] Update `modules/programs/ghostty.nix` to drop all config emission and call `ghostty-reload`.
- [x] Update `modules/environment/wallust.nix` `hooks.ghostty`.
- [x] Verify `nix flake check --no-build` and `home-manager switch`.

---

# Implementation Plan: Zero Config Emissions Across All Wallust Hooks and App Modules

## Objective
Audit and enforce zero configuration file emissions across all apps integrated with Wallust templates and hooks:
1. **Btop Module**:
   - In `modules/programs/btop.nix`, completely remove `home.activation.btopConfig` and `defaultConfig`. Btop configuration remains unmanaged by Nix scripts; Wallust purely targets `~/.config/btop/themes/wallust.theme` and reloads via `pkill -SIGUSR2 -x btop`.
2. **Wallust Templates & Hooks Audit**:
   - Ensure all Wallust templates strictly output to isolated theme files (`wallust.lua`, `wallust.theme`, `flavor.toml`, `theme.yml`, `wallust.tmTheme`, `wallust`, `sequences`) without any mutating wrappers, `sed`, or config file rewriting in hooks.
3. **Verification**:
   - Run `nix flake check --no-build`.
   - Run `home-manager switch --flake ".#hollowheap"`.

## Tasks
- [x] Remove `home.activation.btopConfig` from `modules/programs/btop.nix`.
- [x] Verify `nix flake check --no-build` and `home-manager switch`.

---

# Implementation Plan: Temporarily Revert Starship to Upstream Defaults

## Objective
Temporarily revert Starship configuration in `modules/shell/starship.nix` to upstream defaults without custom pill formatting or module overrides:
1. **Module**:
   - In `modules/shell/starship.nix`, retain `programs.starship = { enable = true; enableZshIntegration = true; };` without custom `settings`.
2. **Verification**:
   - Run `nix flake check --no-build`.
   - Deploy via `home-manager switch --flake ".#hollowheap"`.

## Tasks
- [x] Revert `modules/shell/starship.nix` to default settings.
- [x] Verify `nix flake check --no-build` and `home-manager switch`.

---

# Implementation Plan: Restore Working Bubble-Pill Starship Configuration

## Objective
Restore the authentic working bubble-pill Starship configuration, eliminating the broken intermediate `` delimiters and rendering high-contrast white text on a visible charcoal container (`bg:bright-black`, `#2e2e2e`) with matching closing caps (`[](bright-black)`):
1. **Module**:
   - In `modules/shell/starship.nix`, configure left prompt (`$username$directory$character`) and right prompt (`$git_branch$git_status$nix_shell$cmd_duration$all`).
   - Every pill uses a two-tone single bubble: accent left cap `[]($accent)` with black icon on accent bg `[󰉋 ](bg:prev_fg fg:black)`, followed by crisp white text on charcoal `[ $text](bg:bright-black fg:white)` and charcoal closing cap `[](bright-black)`.
   - Ensure ANSI 16 compliance (`purple` -> `magenta`, `bright-purple` -> `bright-magenta`).
2. **Verification**:
   - Evaluated with `nix flake check --no-build`.
   - Verified escape codes with `cat -v` on `starship prompt` and `starship prompt --right`.
   - Deployed generation 109 via `home-manager switch --flake ".#hollowheap"`.

## Tasks
- [x] Restore working bubble-pill configuration in `modules/shell/starship.nix` with charcoal (`bg:bright-black`) containers and white text.
- [x] Verify `nix flake check --no-build` and `home-manager switch`.

---

# Implementation Plan: Base16 Numeric ANSI Slots (0–15) Alignment for Starship Prompt & Ghostty Font Resolution

## Objective
1. **Starship Numeric ANSI Base16 Palette Alignment**:
   - Align all style strings in `modules/shell/starship.nix` to explicit numeric ANSI color slots (0–15):
     - `fg:0` (pure black `#000000`) for high-contrast icons on bright accent badges (`bg:prev_fg`).
     - `bg:8` (charcoal `#2e2e2e`) for pill body surface and closing cap `[](8)`.
     - `fg:15` (pure white `#ffffff`) for crisp pill body labels and text.
     - `fg:1`..`fg:6` for git status badges and status flags.
     - `fg:11` (bright yellow) for the `◎` prompt success character.
2. **Ghostty Font Mapping Diagnosis & Resolution**:
   - Ghostty daemon `app-com.mitchellh.ghostty.service` (PID 1905) runs with `X-SwitchMethod=keep-old`, preserving stale in-memory font handles (`MapleMono-Regular.ttf` without Nerd Font glyphs) from hours ago and throwing `warning(generic_renderer): error building row ... err=error.CannotOpenResource`.
   - Ghostty configuration already specifies `font-family = Maple Mono NF`, and fresh Ghostty processes discover `Maple Mono NF` with all 16 weights.
   - Advise / restart `app-com.mitchellh.ghostty.service` to reload Fontconfig and bind `Maple Mono NF`.

## Tasks
- [x] Convert `modules/shell/starship.nix` styles to explicit numeric ANSI slots (0–15).
- [x] Evaluate with `nix flake check --no-build` and build home-manager generation.
- [x] Deploy generation via `home-manager switch --flake ".#hollowheap"`.
- [x] Verify raw escape codes via `starship prompt` and `starship prompt --right`.
- [x] Diagnose Ghostty daemon font memory mapping and provide clear resolution.

---

# Implementation Plan: Fix "Nothing Renders" in ~/repos/home-manager (Ghostty Fontconfig Stale Cache & Native Glyph Alignment)

## Root Cause
When CWD is `~/repos/home-manager`:
1. The repository is ahead of origin (`ahead 3`).
2. Starship outputs `⇡3` using `ahead = "[⇡$count]"` (dashed arrow U+21E1).
3. `Maple Mono NF` does not contain `⇡` (U+21E1), prompting Ghostty to query Fontconfig for a fallback font.
4. Fontconfig user cache (`~/.cache/fontconfig/9f8a4a8eb1a7834830bfa607b600bfe1-x86_64.cache-12`) contained a stale path pointing to `/home/hollowheap/.nix-profile/share/fonts/truetype/DejaVuSansMono.ttf` (which no longer exists on disk).
5. Ghostty attempted `openat` on that path, received `ENOENT`, threw `error.CannotOpenResource`, and dropped rendering for the entire row (`warning(generic_renderer): error building row ... err=error.CannotOpenResource`). As a result, the entire prompt row vanished.

## Resolution
1. **Rebuild Fontconfig User Cache**:
   - Cleared corrupted `~/.cache/fontconfig` cache files and re-indexed with `fc-cache -fv`.
   - Verified that `ghostty +show-face --cp=0x21e1` now resolves `DejaVu Sans Mono` cleanly at its valid Nix store location.
2. **Native Glyph Alignment in Starship**:
   - Switched `ahead`, `behind`, and `diverged` in `modules/shell/starship.nix` from dashed arrows (`⇡`, `⇣`, `⇕`) to native arrows (`↑` U+2191, `↓` U+2193, `↕` U+2195) present natively in `Maple Mono NF`.
   - Added trailing breathing space inside the `git_status` pill before the closing cap.
3. **Verification**:
   - `nix flake check --no-build` passed.
   - Deployed generation via `home-manager switch --flake ".#hollowheap"`.
   - Verified that `starship prompt` and `starship prompt --right` render cleanly in `~/repos/home-manager`.

## Tasks
- [x] Identify decisive `ENOENT` on `DejaVuSansMono.ttf` via `strace` on `ghostty +show-face --cp=0x21e1`.
- [x] Flush `~/.cache/fontconfig` and rebuild with `fc-cache -fv`.
- [x] Update `git_status` in `modules/shell/starship.nix` to native `Maple Mono NF` arrows (`↑`, `↓`, `↕`).
- [x] Deploy generation via `home-manager switch --flake ".#hollowheap"` and verify prompt.

---

# Implementation Plan: Bright Color Variants for Starship Git Status

## Objective
Convert all git status indicators and badge in `modules/shell/starship.nix` to their corresponding bright ANSI variants (slots 9–14) for maximum readability and vibrant contrast against the charcoal (`bg:8`) pill container:
- Badge cap: `[](11)` (bright yellow)
- `staged`: `[+](bg:8 fg:10)` (bright green)
- `modified`: `[!](bg:8 fg:11)` (bright yellow)
- `renamed`: `[»](bg:8 fg:12)` (bright blue)
- `deleted`: `[-](bg:8 fg:9)` (bright red)
- `untracked`: `[?](bg:8 fg:9)` (bright red)
- `stashed`: `[≡](bg:8 fg:13)` (bright magenta)
- `conflicted`: `[✖](bg:8 fg:9 bold)` (bright red bold)
- `ahead`: `[↑$count](bg:8 fg:14)` (bright cyan)
- `behind`: `[↓$count](bg:8 fg:9)` (bright red)
- `diverged`: `[↕ ↑$ahead_count ↓$behind_count](bg:8 fg:13)` (bright magenta)

## Tasks
- [x] Update `git_status` in `modules/shell/starship.nix` with bright ANSI color slots 9–14.
- [x] Run `nix flake check --no-build` and deploy via `home-manager switch`.
- [x] Verify escape codes and visual prompt output.

---

# Implementation Plan: Universal Pill Style Abstraction (`modules/styles/pills.nix`)

## Objective
Implement a centralized, declarative pill style abstraction under `modules/styles/pills.nix` that exposes charcoal pill geometry and contrast detection across programs (Tmux, Neovim/Lualine, Starship).

### Architecture & Boundaries
1. **Three Pill Types**:
   - `mode`: Solid background pill with mode color, identical cap color on both sides, auto-detected contrast text, no icons.
   - `left`: Accent icon badge on left + charcoal (`#2e2e2e`) body on right.
   - `right`: Charcoal (`#2e2e2e`) body on left + accent icon badge on right.
2. **Attrset Structure**:
   - Abstraction returns an attrset with attributes `mode`, `icon`, `content`:
     - `mode`: `{ bg, fg, cap, content }`
     - `icon`: `{ bg, fg, cap, icon }`
     - `content`: `{ bg = charcoal, fg = white, cap = charcoal, content }`
3. **Contrast Detection**:
   - Luminance threshold ($\ge 0.55 \rightarrow$ black `#000000`, else white `#ffffff`) for hex colors in both Nix and Lua.
   - ANSI slots: bright colors (yellow, cyan, green, bright variants) $\rightarrow$ black; dark colors $\rightarrow$ white.
4. **Consumer Integration**:
   - `modules/programs/tmux.nix`: Consumes `config.styles.pills.tmux` for `status-left`, `status-right`, and window pills.
   - `modules/programs/nvim.nix`: Consumes `config.styles.pills.lualine` (injects runtime pill functions, sections use `_G.pills.mode()`, `_G.pills.left()`, `_G.pills.right()`).

## Tasks
- [x] Create `modules/styles/pills.nix` with auto-contrast logic, `{ mode, icon, content }` descriptors, and `tmux`/`lualine` builders.
- [x] Stage `modules/styles/pills.nix` and verify flake evaluation with `nix flake check --no-build`.
- [x] Refactor `modules/programs/tmux.nix` status bar to use `config.styles.pills.tmux`.
- [x] Refactor `modules/programs/nvim.nix` lualine to use `config.styles.pills.lualine` with `mode`, `left`, and right-side icon `right` pills.
- [x] Verify evaluation and deploy via `home-manager switch --flake ".#hollowheap"`.

---

# Implementation Plan: Centralize Styling Architecture under `modules/styles`

## Objective
Following the removal of Stylix, unify all styling options and program-level font applications under `modules/styles/`. Program modules (like `modules/programs/ghostty.nix`) should not care about what font to use; font styling is applied to them directly by the styling module (`modules/styles/fonts.nix`).

### Architecture & Boundaries
1. **Directory Consolidation**:
   - `modules/styles/fonts.nix`:
     - Declares `options.styles.fonts` (features, monospace, sansSerif, serif, emoji, sizes).
     - Provides backwards-compatible alias: `options.theme.fonts = config.styles.fonts`.
     - Applies font styles across programs:
       - Configures `programs.ghostty.settings` (`font-family`, `font-size`, `font-feature`).
       - Configures font packages and `fonts.fontconfig` (subsuming `modules/core/fonts.nix`).
       - Configures `dconf.settings."org/gnome/desktop/interface"` font bindings.
   - `modules/styles/dims.nix`:
     - Declares `options.styles.dims` (`border`, `borderSmall`, `margin`, `barHeight`).
     - Provides backwards-compatible alias: `options.theme.dims = config.styles.dims`.
   - `modules/styles/theme.nix`:
     - GTK styling, pointer cursor, Qt platform theme (migrated from `modules/theme/theme.nix`).
   - Remove obsolete `modules/options/theme.nix`, `modules/theme/theme.nix`, and `modules/core/fonts.nix`.
2. **Program Module Decoupling (`modules/programs/ghostty.nix`)**:
   - `ghostty.nix` defines ghostty behavior/theme settings (`theme = "wallust"`, `background-opacity = 1.0`, `keybind = "clear"`), but has zero font configuration.
   - Ghostty font configuration is merged via `modules/styles/fonts.nix`.

## Tasks
- [x] Create `modules/styles/fonts.nix` with options declarations, fontconfig, and target applications (`ghostty`, `dconf`).
- [x] Create `modules/styles/dims.nix` with dimensions options (`border`, `borderSmall`, `margin`, `barHeight`).
- [x] Migrate `modules/theme/theme.nix` to `modules/styles/theme.nix`.
- [x] Remove obsolete files: `modules/options/theme.nix`, `modules/theme/theme.nix`, `modules/core/fonts.nix`.
- [x] Configure `modules/programs/ghostty.nix` non-font settings (`theme`, `background-opacity`, `keybind`) leaving font concerns to `modules/styles/fonts.nix`.
- [x] Update `hyprland.nix`, `noctalia.nix`, and other consumers to reference `config.styles` while ensuring alias compatibility.
- [x] Stage all modified and new files (`nix-flake-eval` workflow) and verify with `nix flake check --no-build`.
- [x] Deploy generation via `home-manager switch --flake ".#hollowheap"` and verify Ghostty, Tmux, and Neovim.

---

# Implementation Plan: Tmux Charcoal Pills & Tmux-Aware FZF Widgets

## Objective
1. **Tmux Charcoal Surface Fix**:
   - Ensure the charcoal body in Tmux pills uses ANSI slot 8 (`brightblack` / `colour8`), identical to Starship's `bg:8` and Ghostty's Wallust palette slot 8 (`#2e2e2e`).
   - Give inactive window pills a distinct dark badge (`accent = "black"`, `iconFg = "brightwhite"`) so the charcoal body (`brightblack`) remains distinct rather than collapsing into a single solid color.
   - Configure session pill with `white` badge on charcoal body when normal, turning `yellow` on prefix.
   - Add Home Manager activation hook `tmuxReload` so `home-manager switch` immediately reloads `tmux.conf` on any running tmux server.
2. **Tmux-Aware FZF & Customizable Widgets (Up Key)**:
   - Configure native `fzf` `--tmux=center,75%,65%` in `programs.fzf.defaultOptions` so *any* invocation of fzf (including `fzf-history-widget`, `fzf-file-widget`, custom scripts) automatically floats in a tmux popup.
   - Set Home Manager's native `historyWidgetOptions`, `fileWidgetOptions`, and `changeDirWidgetOptions` with consistent rounded borders and reverse layout.
   - Provide a customizable ZLE history search widget (`fzf-history-search`) in `modules/shell/zsh.nix`:
     - Bound to Up arrow (`^[[A` and `^[OA`) in `viins`.
     - Initializes with `--query="$BUFFER"` (history search for current typed command prefix).
     - Accepts custom options from `$FZF_HISTORY_OPTS` and `$FZF_CTRL_R_OPTS`.
     - Natively floats in tmux popup.

## Tasks
- [x] Update `modules/styles/pills.nix` Tmux helpers to use `brightblack` / `brightwhite` by default for charcoal body.
- [x] Update `modules/programs/tmux.nix` window status formatting and session pill accent, plus add `tmuxReload` activation hook.
- [x] Update `modules/shell/utilities.nix` with native `programs.fzf` options (`defaultOptions = [ "--tmux=center,75%,65%" ... ]`, `historyWidget.options`, etc.).
- [x] Update `modules/shell/zsh.nix` with `fzf-history-search` widget supporting Up arrow search and argument overrides.
- [x] Evaluate with `nix flake check --no-build` and deploy with `home-manager switch --flake ".#hollowheap"`.
- [x] Verify Tmux pills and FZF popup behavior.

---

# Implementation Plan: Shared Renderer Helpers and Option Normalization

## Objective
Collapse duplicated renderer utilities and stranded helpers into one place, co-locate
`launchApp` with `useUWSM`, and normalize `types.*` references to `let ... inherit (...) ...; in`
across the workspace. Behavior must stay byte-identical for every rendered harness artifact.

## Tasks
- [x] Capture baseline rendered outputs (crush/codex/copilot/opencode/antigravity/kiro/pi).
- [x] Normalize `types.*` to `inherit (lib.types)` in `styles/dims.nix`, `styles/fonts.nix`,
      `options/ai.nix`, `styles/pills.nix`.
- [x] Add read-only `launchApp` option beside `useUWSM`; consume it from `environment/hyprland.nix`.
- [x] Create `lib/ai-render.nix` exporting `rulesText`, `renderDiscipline`, `mkSkillDir`,
      `zenModelFor`.
- [x] Refactor the 8 harness renderers onto the shared helpers.
- [x] Update `AGENTS.md` and `skills/renderer-author/SKILL.md`.
- [x] Verify: rendered outputs diff clean vs baseline; `nix flake check --no-build` passes.

## Verification
Exact commands: `nix eval --raw .#homeConfigurations.hollowheap.config.<attr>` diffed against
`/tmp/refactor-baseline/`, then `nix flake check --no-build`.

---

# Implementation Plan: Hyprland Plugin ABI Fix and Window Rules

## Objective
Make `hypr-dynamic-cursors` actually load on the pinned Hyprland (0.56.2), and enlarge the
Noctalia Settings window via a Hyprland window rule.

Context: nixpkgs ships `hypr-dynamic-cursors` at upstream rev `f5ba36c` (2026-07-21), which
upstream pins to Hyprland v0.56.0/v0.56.1. On Hyprland 0.56.2 it loads then throws:
`plugin crashed/threw in main: std::exception`. Upstream pins v0.56.2 to rev `5a22428`
(2026-08-06). Fix: override the package locally.

## Tasks
- [x] Add `pkgs/hyprland-plugins/hypr-dynamic-cursors.nix` overriding nixpkgs to rev
      `5a224284872208b5324759d535d65061043725de`.
- [x] Verify build: `nix build .#homeConfigurations.hollowheap.pkgs.hyprlandPlugins.hypr-dynamic-cursors`.
- [x] Verify load: `hyprctl plugin load <out>/lib/libhypr-dynamic-cursors.so` succeeds.
- [x] Add `size`/`center` to the `noctalia-settings` window rule in `modules/environment/hyprland.nix`.
- [x] Verify rendered `~/.config/hypr/hyprland.lua` and `nix flake check --no-build`.
- [x] Enable `plugin.dynamic_cursors.hyprcursor` with `nearest = 0` and `resolution = 96` to
      stop the magnified cursor from pixelating.

---

# Implementation Plan: Wallust-driven Crush/opencode Themes and Mactahoe Hook Repair

## Objective
Give Crush and opencode declarative base16 themes generated from the wallust palette, and fix
the mactahoe GTK/icon hooks so they compile the theme and move both accents to wallust `color12`.

Verified upstream shapes (upstream-recon):
- Crush: config `options.tui.active_theme`; theme file `~/.config/crush/themes/<name>.json`
  shaped `{"base": "<builtin>", ...PaletteFields}`; `charmtone-panther` is a valid base.
- opencode: config `programs.opencode.tui.theme`; theme file
  `~/.config/opencode/themes/<name>.json` shaped `{"$schema", "defs", "theme"}`.
- wallust: `{{colorN}}` includes `#`; `set_seq` runs before templates before hooks; `-s`
  skips `colors.sequences()` entirely (no OSC to live terminals); templates create target dirs.

## Tasks
- [x] Add `assets/wallust-templates/crush.json` (Crush ThemeFile from base16).
- [x] Add `assets/wallust-templates/opencode.json` (opencode theme from base16).
- [x] Wire both templates in `modules/environment/wallust.nix`.
- [x] Set `programs.crush.settings.options.tui.active_theme = "wallust"`.
- [x] Set `programs.opencode.tui.theme = "wallust"`.
- [x] Icon hook: derive accent from wallust `sequences` instead of noctalia `icon-accent.txt`.
- [x] Remove `icon-theme` from `modules/core/dconf.nix` so activation stops resetting it.
- [x] Verify: template render, `nix eval`, `nix flake check --no-build`.

## Corrections (do not repeat these mistakes)
- The gtkHook `-temp` copies are REQUIRED: `_variables.scss` and `_colors.scss` import
  `theme-options-temp` and `gtk-base-temp`, so removing the copies makes sassc fail and the
  hook bails, leaving `gtk.css` as the ~750-byte noctalia template (not the compiled theme).
- `-s` on the hook's wallust run is deliberate: without it wallust's `set_seq` overwrites the
  pinned neutrals (color0/color7/color8/color15) in open terminals.
- The gtk3/gtk4 templates re-render `gtk.css` after the other hook may have compiled it, so the
  early-exit must verify the compiled output is still installed. The hook now stamps
  `/* mactahoe-accent: <accent> */` into the compiled CSS and greps for it, instead of trusting
  only the marker file.
- Live terminals are updated by the wallust `sequences` hook writing the pinned file to
  `/dev/pts/*`; new shells are covered by `modules/shell/zsh.nix`.

## Verification
Exact commands: render templates via wallust into a temp dir; `nix eval --raw` on the rendered
configs; `nix flake check --no-build`.

---

# Implementation Plan: GTK/Icon Rebuild from Noctalia Primary

## Objective
Both mactahoe hooks must read the accent only from noctalia's palette (primary / on_primary),
dropping the wallust `sequences` dependency. The GTK SCSS recompile moves into a `pkgs/` script.

Context: noctalia renders `gtk-accent.css`/`gtk4-accent.css` to `gtk-{3,4}.0/gtk.css` with
`{{ colors.primary.default.hex }}` and `{{ colors.on_primary.default.hex }}`, and
`icon-accent.txt` to `~/.cache/noctalia/icon-accent.txt` as `#hex dark`. The old hooks instead
ran wallust and read color12 from `~/.cache/wallust/sequences`. mactahoe `install.sh` builds
with sassc, so the recompile is the correct approach.

## Tasks
- [x] Add `pkgs/mactahoe-gtk-accent.nix` (writeShellScriptBin) compiling the gtk3/gtk4 dark
      stylesheets from the theme src with a given accent + fg, marker-gated.
- [x] Rewrite the noctalia gtk hooks to read accent/fg from the rendered noctalia CSS and call
      the script; no wallust.
- [x] Rewrite the icon hook to read `~/.cache/noctalia/icon-accent.txt` instead of wallust.
- [x] Verify: run the built script against temp paths; `nix flake check --no-build`.

## Corrections
- The `-temp` copies stay required (`_variables.scss`/`_colors.scss` import them).
- The early-exit still greps `/* mactahoe-accent: <accent> */` in all three outputs, because
  noctalia re-renders a gtk.css after the other hook may have compiled it.

## Runtime fixes (activation gaps)
- [x] `modules/styles/theme.nix`: set `gtk.gtk4.theme` (name only, package null). HM's top-level
      `gtk.theme` only seeds GTK 2/3; at `home.stateVersion >= 26.05` `gtk.gtk4.theme` defaults
      to null, so `gtk-4.0/settings.ini` lacked `gtk-theme-name` and GTK 4 fell back to Adwaita.
      package null keeps HM from writing `gtk-4.0/gtk.css` (its `@import` would clobber the
      noctalia overlay).
- [x] `modules/styles/theme.nix`: drop `gtk.iconTheme`, install `pkgs.mactahoe-icon-theme` via
      `home.packages`. A pinned `gtk.iconTheme` wrote a static `gtk-icon-theme-name` in
      `settings.ini` and `icon-theme` in dconf, so GTK apps never followed the hook's variant and
      every switch reset dconf to `-latest-dark`. Now the hook owns the icon theme end to end.
- [x] `modules/core/dconf.nix`: add a static `icon-theme` fallback. Without a managed value the
      dconf key is deleted on every switch and icons stay unthemed until the next accent change,
      because the hook only reruns when noctalia re-renders the wallpaper palette.

## GTK theme hot-reload: not possible (verified)
GTK 4.22 loads `~/.config/gtk-4.0/gtk.css` exactly once and sets **no** inotify watch on it
(`inotify_add_watch` only on `/etc` and `/run/mount/utab.event`). Editing the file, changing
dconf `gtk-theme` (even with the `settings.ini` pin removed), and toggling `color-scheme` all
produced zero re-reads. GTK also reads the theme dir once. There is no signal or settings
change that makes a running GTK app reload the accent; apps must be restarted to pick it up.
The icon theme, by contrast, is read through GSettings and does update live.

## Accent propagation (portal unavailable, restart hook chosen)
- The freedesktop appearance portal cannot carry the accent here: `Settings.ReadAll
  org.freedesktop.appearance` returns only `contrast` and `color-scheme`, `Read accent-color`
  returns `NotFound`, nautilus probes `accent-color (ddd) not found`, and neither
  `xdg-desktop-portal-1.20.4` nor `xdg-desktop-portal-gtk-1.15.3` contains the key. GNOME 50 also
  changed `org.gnome.desktop.interface/accent-color` to a 9-value enum, so the old `(ddd)` portal
  bridge is gone. The gtk.css `@define-color accent_*` roles already cover libadwaita.
- [x] `pkgs/mactahoe-gtk-accent.nix`: print `recompiled` on stdout only when the stylesheet was
  actually rebuilt (the no-op early exit stays silent), so callers can gate a restart on change.
- [x] `modules/options/apps.nix`: `restartGtkApps` (list of process names, default `[ "nautilus" ]`).
- [x] `modules/environment/noctalia.nix`: both gtk hooks terminate `restartGtkApps` via `pkill -x`
  when the compile emitted the token. Verified with both hooks run per accent change: exactly one
  `pkill` fires (the second hook's early-exit gate no-ops), so running GTK apps relaunch themed.

---

# Implementation Plan: Customized Status Bar Script for agy Using Workspace Pills

## Objective
Implement a customized, executable status bar script for `agy` (Antigravity CLI) that consumes
`StatusLineData` JSON on stdin and renders a two-tone powerline pill status bar aligned with
`modules/styles/pills.nix` (charcoal body `#2e2e2e`, contrast fg `#ffffff`, Powerline caps ``/``,
and ANSI/truecolor accent badges).

1. **Pill Formatting & Component Layout**:
   - Centralized pill geometry matching `modules/styles/pills.nix`:
     - Mode pill: Solid accent background with contrast text (` NORMAL `).
     - Left pill: Accent icon badge on left + charcoal `#2e2e2e` body on right (`[accent] 󰉋 [charcoal] ~/path `).
     - Right pill: Charcoal `#2e2e2e` body on left + accent icon badge on right (`[charcoal] main* [accent]  `).
   - Left side:
     - Mode / State: Vim mode (`NORMAL`/`INSERT`/`VISUAL`) or Agent mode (`ENGINEER`/`PLAN`).
     - Model: Robot icon `󰚩`, accent blue, display name (e.g. `Gemini 3.8 Flash`).
     - Workspace: Folder icon `󰉋`, accent cyan, shortened path (`~/repos/home-manager`).
   - Right side:
     - Git: Branch icon ``, accent magenta, branch name + dirty status `*`.
     - Usage / Tokens: Icon `󰕲`, accent yellow/green, tokens or spend if present.
     - Clock: Clock icon `󱑂`, accent blue, `HH:mm`.
   - Alignment:
     - Calculates visible width (stripping ANSI escapes) and pads the gap between left and right
       to span the full terminal width (`terminal_width` or terminal column count).

2. **Integration & Packaging**:
   - Create `pkgs/agy-statusline.nix` package using `writers.writePython3Bin` or `writeScriptBin`.
   - Auto-discovered via `pkgs/default.nix` into `pkgs.agyStatusline`.
   - Symlink or install to `~/.gemini/antigravity-cli/bin/agy-statusline`.
   - Configure `~/.gemini/antigravity-cli/settings.json` with `"type": "command"`, `"command": "/home/hollowheap/.gemini/antigravity-cli/bin/agy-statusline"`, `"enabled": true`.

3. **Verification**:
   - Test standalone execution with simulated JSON payload and empty stdin.
   - Verify visible width, ANSI escapes, and contrast colors.
   - Run `nix flake check --no-build`.

## Tasks
- [x] Write `pkgs/agy-statusline.nix` with the Python statusline renderer.
- [x] Add `agyStatusline` to packages in `modules/core/packages.nix`.
- [x] Link script to `~/.gemini/antigravity-cli/bin/agy-statusline`.
- [x] Update `~/.gemini/antigravity-cli/settings.json`.
- [x] Run evaluation and verification (`nix flake check --no-build`).

---

# Implementation Plan: Vaultwarden-backed AI provider API keys

## Objective
Expose the AI provider keys stored in Vaultwarden (rbw, folder `keys/api`) to the harnesses as
environment variables at interactive shell start, only when the vault is already unlocked.

Source (verified via `rbw list --fields name,folder,type` and `rbw get --list-fields`):
- folder `keys/api`, Login items, secret in the `password` field:
  - `opencode` -> `OPENCODE_API_KEY` (OpenCode Zen, used by crush/pi/opencode)
  - `claude`   -> `ANTHROPIC_API_KEY`
  - `gemini`   -> `GEMINI_API_KEY` (and `GOOGLE_GENERATIVE_AI_API_KEY` for OpenCode)
- `rbw get --folder keys/api <item>` returns the value; all three resolve in ~16 ms.

All three harnesses read these names from the environment, so no provider blocks change:
- crush: reads `ANTHROPIC_API_KEY` / `GEMINI_API_KEY` / `OPENCODE_API_KEY` (zen already uses `$OPENCODE_API_KEY`).
- pi: built-in provider registry maps the same `_API_KEY` names.
- opencode: auto-detects provider env vars.

## Tasks
- [x] `modules/shell/zsh.nix`: in `initContent`, export the three keys from rbw when
      `rbw unlocked` succeeds; skip silently when locked so nothing prompts and existing values stay.
- [x] Verify shell syntax and a live fetch mapping (lengths only, no secret values).
- [x] `nix flake check --no-build` and build the activation package.

## Verification
`bash -n` on the rendered snippet, a sandboxed run with a stub `rbw`, then
`nix flake check --no-build` and `nix build .#homeConfigurations.hollowheap.activationPackage`.

## Notes
- GUI/uwsm-launched processes do not inherit this (shell-only delivery, chosen deliberately).
- No plaintext secret is ever written to disk or the Nix store.

---

# Implementation Plan: Declarative harness settings via upstream `settings` options

## Objective
Fold the live per-harness settings files into the upstream `programs.<harness>.settings` options
(no custom `ai.*` options, no `home.file` writers for settings). Enable `mutableSettings` where the
harness rewrites its own config at runtime so activation merges instead of fighting the symlink.

## Verified upstream surfaces (store source `a1gylxbizsirhh84fiplvrcysdkx5q01-source`)
- `programs.opencode.settings` (JSON) + `mutableSettings` -> writes `home-manager.json`, loaded via
  `OPENCODE_CONFIG`; leaves `opencode.json`/`tui.json` writable.
- `programs.codex.settings` (null or TOML) + `mutableSettings` -> `mkImpureConfigMerger` into `config.toml`.
- `programs.antigravity-cli.settings` (JSON) + `mutableSettings` -> merge into `settings.json`.
- `programs.pi-coding-agent.settings` (JSON) - already declared, matches live; no `mutableSettings` option.
- `programs.crush.settings` (JSON) - already declared; live `crush.json` is an HM symlink.
- `programs.kiro-cli` has NO settings option (enable/package only) -> `cli.json` not declarable.

## Tasks
- [x] `modules/programs/opencode.nix`: `settings` (`$schema`) + `mutableSettings = true`.
- [x] `modules/programs/codex.nix`: `settings` (`tui`, `projects` trust) + `mutableSettings = true`.
- [x] `modules/programs/antigravity.nix`: `settings` (live `settings.json`) + `mutableSettings = true`.
- [x] `nix flake check --no-build` passes.
- [x] `nix build .#homeConfigurations.hollowheap.activationPackage` succeeds.

## Verification
- `nix eval .#homeConfigurations.hollowheap.config.programs.{opencode,codex,antigravity-cli}.settings --json`
- `nix eval ...programs.{opencode,codex,antigravity-cli}.mutableSettings` -> all `true`.
- `nix flake check --no-build` -> `all checks passed!`
- `nix build .#homeConfigurations.hollowheap.activationPackage` -> exit 0 (`9m1h2li…-home-manager-generation`).
- Rendered: `.config/opencode/home-manager.json`; codex `codex-config.toml` (`[projects."/home/hollowheap/repos/home-manager"] trust_level = "trusted"`, `[tui] screen_reader_detection_done = true`); antigravity `antigravity-cli-settings.json` (full live `settings.json`).
- Activation merges at `antigravitySettings` and `codexMutableSettings` steps via `jaq`; run `home-manager switch` to apply.

## Notes
- `kiro-cli` `settings/cli.json`, antigravity `keybindings.json`, pi `mcp.json` have no upstream
  option; they stay unmanaged.
- Verified option shapes: `programs.opencode.settings` JSON + `mutableSettings`; `programs.codex.settings`
  null-or-TOML + `mutableSettings`; `programs.antigravity-cli.settings` JSON + `mutableSettings`;
  `programs.pi-coding-agent.settings` JSON (no `mutableSettings`); `programs.crush.settings` JSON;
  `programs.kiro-cli` has no settings option.
- Local opencode skills (`color-override-audit`, `layout-spacing-audit`) stay local by request.
- App-mutated files (codex `config.toml`, antigravity `settings.json`) enable `mutableSettings` so
  activation merges; activation is a manual `home-manager switch` step.

---

# Implementation Plan: Retire root `PLAN.md`

## Objective
Remove the root `PLAN.md`; its content and backlog move into the `artifacts/tasks/` area, and every
reference is repointed so no doc links to a deleted file.

## Tasks
- [x] Create `artifacts/tasks/overview.md` from `PLAN.md` (objective, scope, stack, goals, overlaps,
      architecture topics, validation, risks, alternatives, open questions).
- [x] Delete `PLAN.md`.
- [x] Repoint references: `AGENTS.md`, `modules/ai/skills.nix`, `artifacts/plan.md`, 6 task files.
- [x] `nix flake check --no-build` passes; no live pointers to the root plan remain.

## Verification
- Root file gone: `git status PLAN.md` -> ` D PLAN.md`.
- Live pointers repointed to `artifacts/tasks/overview.md`.
- Remaining textual mentions of the name are historical (migration record, `overview.md` provenance).
- `nix flake check --no-build` -> `all checks passed!`.

## Notes
- The directory is `artifacts/tasks/` (plural) as it already exists and is linked from the retired
  `PLAN.md`; the request wrote `artifacts/task/`, treated as the same area.
- Migrated verbatim, including stale Stylix/Matugen mentions (a separate cleanup).

---

# Implementation Plan: agy Statusline Selected Agent

## Objective
1. Display the selected agent on the right side of the `agy` statusline as a pill.
2. Note: Custom header script (`hollow-agy`) dropped because `agy` does not support an external header command (hardcoded in Go binary `render.agyBanner`).

## Implementation Details
1. **Statusline Enhancement (`pkgs/agy-statusline.py`)**:
   - Parse `agent_name` from `data.get("agent")`, `data.get("selected_agent")`, or `data.get("agent_name")`.
   - Render `pill_right(cur_agent, "󰘧", COLORS.get(10, (133, 180, 82)))` in `right_parts` before branch.
   - Retain `cur_agent` across width responsiveness tiers (`tier < 3`).
2. **hollow-agy**:
   - Dropped per user decision; `agy` has no configuration option or hook for external header commands.

## Verification
- [x] Direct execution of `agy-statusline.py` with mock stdin JSON including agent info.
- [x] `nix flake check --no-build`.
- [x] `nix build .#homeConfigurations.hollowheap.activationPackage --no-link`.

---

# Implementation Plan: Lock OpenCode on deepseek-v4.1-flash-free

## Objective
Retire `muse-spark` in OpenCode, lock all OpenCode agent configurations and defaults to `opencode/deepseek-v4.1-flash-free`, and isolate the OpenCode CLI from the shell's `OPENCODE_API_KEY` (which is a Zen key that upstream rejects for non-Zen models).

## Tasks
- [x] In `modules/programs/opencode.nix`:
  - Define `opencodeModel = "opencode/deepseek-v4.1-flash-free";` replacing `muse-spark-1.3-contributor-free`.
  - Point `mkAgent` and `settings.model` to `opencodeModel`.
  - Wrap `programs.opencode.package` to `--unset OPENCODE_API_KEY` so OpenCode runs in native free client mode.
- [x] Verify `nix flake check --no-build`.
- [x] Verify rendered agent configs and settings via `nix eval`.
- [x] Verify `nix build .#homeConfigurations.hollowheap.activationPackage`.

---

# Implementation Plan: Native OpenCode Config & Git HTTPS Auth via rbw

## Objective
1. Replace OpenCode wrapper workaround with native declarative config: set `programs.opencode.settings.provider.opencode.env = []` and `small_model = opencodeModel`, removing the wrapper in `modules/programs/opencode.nix`.
2. Enable GitHub HTTPS authentication in `modules/programs/git.nix` using an `rbw`-backed credential helper reading the PAT from `keys/api github`, and remove `pushInsteadOf` forcing SSH on HTTPS GitHub URLs.

## Tasks
- [x] In `modules/programs/opencode.nix`:
  - Remove `programs.opencode.package` wrapper.
  - Add `provider.opencode.env = []` and `small_model = opencodeModel;` to `settings`.
- [x] In `modules/programs/git.nix`:
  - Define `gitCredentialRbwGithub` with `pkgs.writeShellApplication` invoking `rbw get --folder keys/api github`.
  - Configure `credential."https://github.com".helper` and `credential."https://gist.github.com".helper`.
  - Remove `pushInsteadOf = "https://github.com/";` under `git@github.com:`.
  - Add `gitCredentialRbwGithub` to `home.packages`.
- [x] Verify `nix flake check --no-build`.
- [x] Test Git HTTPS credential resolution with `git credential fill`.
- [x] Verify `nix build .#homeConfigurations.hollowheap.activationPackage`.

---

# Implementation Plan: Native Vector Hyprcursor Package & Dynamic Cursor Resolution

## Objective
Fix low-resolution and blurry magnified/tilted cursor by providing native Hyprcursor vector SVG assets for `Bibata-Modern-Classic` alongside XCursor fallbacks, and enabling auto-calculated dynamic cursor resolution.

Context:
1. `pkgs.bibata-cursors` only contains XCursor raster bitmaps. Because `manifest.hl` is absent, Hyprland and `hypr-dynamic-cursors` fail to load hyprcursor themes and fall back to bilinearly magnifying the 20px raster bitmap, resulting in a blurry, low-resolution cursor.
2. In `modules/environment/hyprland.nix`, `hyprcursor.resolution = 96` was set under the assumption that Bibata topped out at 96px bitmaps. With native vector SVGs, `resolution = -1` allows `dynamic-cursors` to dynamically render at full target magnification scale.

## Tasks
- [x] Create `pkgs/bibata-hyprcursor.nix` combining `bibata-cursors` (for X11/GTK/Qt XCursors) and `LOSEARDES77/Bibata-Cursor-hyprcursor` release v1.1 (for native SVG vector hyprcursors).
- [x] Update `modules/styles/theme.nix` to use `pkgs."bibata-hyprcursor"` in `home.pointerCursor.package`.
- [x] Update `modules/environment/hyprland.nix` under `plugin.dynamic_cursors.hyprcursor`: set `resolution = -1;` and update documentation comments.
- [x] Stage `pkgs/bibata-hyprcursor.nix` explicitly by name per `nix-flake-eval` skill.
- [x] Verify evaluation with `nix flake check --no-build`.
- [x] Verify activation package build with `nix build .#homeConfigurations.hollowheap.activationPackage`.
- [x] Inspect output store path to ensure both `cursors/` and `manifest.hl` / `hyprcursors/` are present.

---

# Implementation Plan: Tmux Popup Keybindings & Bat-Extras Shell Integration

## Objective
1. Assign tmux popup float bindings for lazygit (`g`, `C-g`), yazi (`y`, `C-y`), btop (`b`, `C-b`), and floating shell (`t`, `C-t`), remapping `break-pane` to `B` so standard prefix keys work immediately.
2. Port shell tools to `bat-extras`: wire `MANPAGER = "batman"`, shell aliases `man = "batman"`, `cat = "bat"`, `diff = "batdiff"`, enable `batpipe` preprocessor for less/bat, and add `batwatch` to `programs.bat.extraPackages`.

## Tasks
- [x] In `modules/programs/tmux.nix`:
  - Remap `bind b break-pane` to `bind B break-pane`.
  - Add explicit non-Ctrl bindings `bind y`, `bind g`, `bind b`, `bind t` alongside `bind C-y`, `bind C-g`, `bind C-b`, `bind C-t`.
- [x] In `modules/programs/bat.nix`:
  - Add `batwatch` and `prettybat` to `programs.bat.extraPackages`.
- [x] In `modules/shell/zsh.nix`:
  - Add shell aliases `cat = "bat"`, `diff = "batdiff"`, `man = "batman"`.
  - In `initContent`, wire `batpipe` preprocessor: `(( ${+commands[batpipe]} )) && eval "$(batpipe)"`.
- [x] In `modules/core/env.nix`:
  - Add `MANPAGER = "batman"` to `home.sessionVariables`.
- [x] In `pkgs/mactahoe-gtk-theme.nix`:
  - Bypass unneeded `install_app` in `install.sh` sandbox to resolve `/homeless-shelter` permission failure.
- [x] Verify `nix flake check --no-build`.
- [x] Verify `nix build .#homeConfigurations.hollowheap.activationPackage`.

---

# Implementation Plan: Hyprland Submaps, Workspace Defaults & Laptop Remap Toggle

## Objective
1. Fix monitor workspace startup assignment so `HDMI-A-1` starts on workspace 1 (`default = true`), `DP-1` on workspace 2, and `eDP-1` on workspace 3.
2. Bind window pin toggle to `SUPER + SHIFT + P`.
3. Add `SUPER + M` media submap (playback, volume, mute, mic mute).
4. Add `SUPER + R` scrolling layout & window resize submap.
5. Rebind session panel to `SUPER + ESCAPE` (opening Noctalia session panel directly).
6. Add `SUPER + Z` passthrough submap for games and VMs.
7. Add `SUPER + ALT + L` laptop remap toggle submap remapping `t` to ``` ` ``` (grave) and `y` to `Num_Lock`.

## Tasks
- [x] In `modules/environment/hyprland.nix`:
  - [x] Add workspace default rules for monitors: `workspace = 1` (`HDMI-A-1`), `workspace = 2` (`DP-1`), `workspace = 3` (`eDP-1`).
  - [x] Update `bind`:
    - [x] Replace maximize `SUPER + M` with media submap dispatch.
    - [x] Add `SUPER + R` resize submap dispatch.
    - [x] Remap `SUPER + SHIFT + ESCAPE` to `SUPER + ESCAPE` for Noctalia session panel.
    - [x] Add `SUPER + Z` passthrough submap dispatch.
    - [x] Add `SUPER + SHIFT + P` window pin toggle.
    - [x] Add `SUPER + ALT + L` laptop remap toggle dispatch with notification.
  - [x] Declare `submaps`:
    - [x] `media`: track, volume, mute, mic mute controls; exit on `escape`/`return`/`SUPER + M`.
    - [x] `resize`: scrolling column width adjustment (`layout("colwidth ±0.05")`), height adjustment, presets (`1`-`4`), fit; exit on `escape`/`return`/`SUPER + R`.
    - [x] `passthrough`: only `SUPER + Z` and `SUPER + ESCAPE` to exit.
    - [x] `laptop`: `t` sends grave, `SHIFT + t` sends asciitilde, `y` sends Num_Lock, `SUPER + ALT + L` exits with notification.
- [x] Verify with `nix flake check --no-build`.
- [x] Verify activation build with `nix build .#homeConfigurations.hollowheap.activationPackage`.
- [x] Verify rendered `hyprland.lua` structure.

---

# Implementation Plan: Disable Noctalia Idle Suspend

## Objective
Disable Noctalia's automatic system suspend upon idle so background processes (downloads, builds, servers) continue running uninterrupted, while retaining screen-off (monitor power-off) and screen lock.

## Tasks
- [x] In `modules/environment/noctalia.nix`:
  - [x] Set `idle.behavior.suspend.enabled = false;`.
- [x] Verify with `nix flake check --no-build`.
- [x] Verify activation build with `nix build .#homeConfigurations.hollowheap.activationPackage`.
- [x] Inspect generated `noctalia/config.toml` to confirm `[idle.behavior.suspend]` has `enabled = false`.

---

# Implementation Plan: Small-Pillar AI Architecture & 4-Pass Refactor

## Objective
Implement the Small-Pillar AI architecture across `modules/options/ai.nix`, `modules/ai/`, `modules/programs/`, and `skills/` in 4 sequential, independently verifiable passes:
1. Pass 1: Nix options schema (`ai.tiers`, agent tier/effort/dropDisciplines, discipline target), 3-tier routing, render helpers (`modelFor`, `effortFor`, `renderDisciplines`, `renderRules`, `agentBodyFor`, `context`), and renderer wiring (`opencode`, `crush`, `pi-coding-agent`, `codex`).
2. Pass 2: Disciplines split (`unslop`, `lazy`, `report`, `artifacts`, `skills` with `target = "primary"`, `subagent-io` with `target = "subagent"`), rules pruning to 7 primary rules, and `ask -> architect -> engineer` + subagents (`Scout`, `Code Reviewer`).
3. Pass 3: Global skills refactor in `modules/ai/skills.nix` (`grill`, `plan`, `nav-repomap`, `git-commit`) with universal format and examples in `references/examples.md`.
4. Pass 4: Repo-local skills migration (`upstream-recon`, `overlap-check` to `skills/`), slim existing workspace skills (`nix-flake-eval`, `renderer-author`), slim root `AGENTS.md` to <40 lines, and run token audit.

## Tasks
- [x] Pass 1: Schema, rendering helpers, and renderer wiring
  - [x] Add `ai.tiers`, agent `tier`, `effort`, `dropDisciplines`, and discipline `target` in `modules/options/ai.nix`.
  - [x] Expose `ai.render` (`modelFor`, `effortFor`, `agentRules`, `renderDisciplines`, `renderRules`, `agentBody`, `agentBodyFor`, `context`).
  - [x] Wire `modelFor` and `effortFor` in `modules/programs/{opencode,crush,pi-coding-agent,codex}.nix`.
  - [x] In `modules/programs/opencode.nix`, configure scout allowlist and disable `general`/`explore` subagents.
  - [x] Verify Pass 1 with `nix flake check --no-build`.
- [x] Pass 2: Disciplines split, rules pruning, and agent roster
  - [x] Update `modules/ai/disciplines.nix` with `primary` and `subagent` disciplines (`subagent-io`, `lazy.steer`, `lazy.stop-on-pass`, etc.).
  - [x] Update `modules/ai/rules.nix` to 7 primary rules.
  - [x] Update `modules/ai/agents.nix` with `ask`, `architect`, `engineer`, `Scout`, `Code Reviewer`.
  - [x] Update renderer agent mappings and drop lists as needed.
  - [x] Verify Pass 2 with `nix flake check --no-build`.
- [x] Pass 3: Global skills refactor (`grill`, `plan`, `nav-repomap`, `git-commit`)
  - [x] Refactor `modules/ai/skills.nix` with universal preamble-free format and `references/examples.md`.
  - [x] Replace `question` with `grill` and `shared-tree` with `git-commit`.
  - [x] Update `plan` and `nav-repomap`.
  - [x] Verify Pass 3 with `nix flake check --no-build`.
- [x] Pass 4: Repo-local skills, root `AGENTS.md` slimming, token audit
  - [x] Move `upstream-recon` and `overlap-check` to `skills/` and stage with `git add`.
  - [x] Slim `skills/nix-flake-eval/SKILL.md` and `skills/renderer-author/SKILL.md`.
  - [x] Slim `AGENTS.md` to <40 lines, moving matrix tables to `skills/renderer-author/references/matrices.md`.
  - [x] Stage new files and verify `nix flake check --no-build`.
  - [x] Run token/character audit for `AGENTS.md`, `ai.render.context "opencode"`, and rendered OpenCode agents.

---

# Implementation Plan: Universal Powerline Pill Engine & Pure Bash agy-statusline

## Objective
Implement Architectural Proposal 1 across `modules/styles/pills.nix`, `modules/shell/starship.nix`, `modules/programs/pi-coding-agent.nix`, and `pkgs/agy-statusline`:
1. **Extend `modules/styles/pills.nix`**:
   - Keep `styles.pills` strictly as compile-time Nix formatters (no runtime library package).
   - Add `styles.pills.starship` adapter (`mode`, `left`, `right`).
   - Add `styles.pills.pi` adapter (`mode`, `left`, `right`) producing JSON component lists.
   - Add `styles.pills.bash` adapter exposing shell formatting functions (`pill_mode`, `pill_left`, `pill_right`) supporting standard 16 ANSI slots and dynamic 24-bit RGB from `~/.cache/wallust/sequences`.
2. **Rewrite `pkgs/agy-statusline` in Pure Bash**:
   - Create `pkgs/agy-statusline.sh` implementing full feature parity with `pkgs/agy-statusline.py` (JSON stdin parsing via `jq`, git vcs check, model fallback, 5-tier responsive width collapse, dynamic wallust sequence parsing).
   - Update `pkgs/agy-statusline.nix` to use `writeShellApplication` with `runtimeInputs = [ jq git coreutils ]`, removing `python3`.
   - Remove `pkgs/agy-statusline.py`.
3. **Integrate Modules**:
   - Refactor `modules/shell/starship.nix` to consume `config.styles.pills.starship`.
   - Refactor `modules/programs/pi-coding-agent.nix` mode pill synthesis to consume `config.styles.pills.pi`.
4. **Verification**:
   - Verify `nix flake check --no-build`.
   - Test execute `agy-statusline` with mock JSON stdin and empty stdin to verify responsive tiers and ANSI output.
   - Verify activation package build with `nix build .#homeConfigurations.hollowheap.activationPackage --dry-run`.

## Tasks
- [x] Implement `styles.pills.starship`, `styles.pills.pi`, and `styles.pills.bash` in `modules/styles/pills.nix`.
- [x] Rewire `modules/shell/starship.nix` to use `config.styles.pills.starship`.
- [x] Rewire `modules/programs/pi-coding-agent.nix` to use `config.styles.pills.pi`.
- [x] Create `pkgs/agy-statusline.sh` in pure Bash + `jq` with wallust sequence RGB parsing and responsive collapse.
- [x] Update `pkgs/agy-statusline.nix` to package the Bash script with `jq git coreutils` dependencies, and remove `pkgs/agy-statusline.py`.
- [x] Stage untracked files (`git add pkgs/agy-statusline.sh`) and verify `nix flake check --no-build`.
- [x] Execute test runs of `agy-statusline` under various terminal widths and JSON payloads.

---

# Implementation Plan: Modular Wallust Templates & Hardened Noctalia Theming Hook

## Objective
Implement Architectural Proposal 3 per user decisions without unnecessary abstractions:
1. **Modularize Wallust Templates and Reload Hooks**:
   - De-monolith `modules/environment/wallust.nix`: Retain only core `sequences` template and terminal PTY broadcast hook.
   - Distribute app-specific templates and hooks to their respective modules:
     - `modules/programs/nvim.nix`: `nvim` template + `SIGUSR1` hook
     - `modules/programs/ghostty.nix`: `ghostty` template + `ghostty-reload` hook
     - `modules/programs/btop.nix`: `btop` template + `SIGUSR2` hook
     - `modules/programs/bat.nix`: `bat` template + `bat cache --build` hook
     - `modules/programs/yazi.nix`: `yazi` flavor template
     - `modules/programs/crush.nix`: `crush` theme template
     - `modules/programs/opencode.nix`: `opencode` theme template
   - Disabling any app automatically removes its template and reload hook from Wallust.
2. **Harden Noctalia Wallpaper Hook**:
   - In `modules/environment/noctalia.nix`, harden `wallust` post_hook extraction:
     - Handle sections `[wallpaper]` or `[wallpaper.last]` robustly.
     - Strip single/double quotes and whitespace safely with `awk`.
     - Validate that image exists (`-f`) and is readable (`-r`) before calling `wallust run "$img" -s`.
3. **Verification**:
   - Run `nix flake check --no-build`.
   - Run `nix build .#homeConfigurations.hollowheap.activationPackage --dry-run`.
   - Inspect generated `wallust.toml` in derivation to ensure all templates and hooks merge identically.

## Tasks
- [x] Distribute templates and hooks from `modules/environment/wallust.nix` into `modules/programs/{nvim,ghostty,btop,bat,yazi,crush,opencode}.nix`.
- [x] Retain only core `sequences` template and broadcast hook in `modules/environment/wallust.nix`.
- [x] Harden the Noctalia `wallust` post_hook in `modules/environment/noctalia.nix`.
- [x] Verify with `nix flake check --no-build`.
- [x] Verify activation build with `nix build .#homeConfigurations.hollowheap.activationPackage --dry-run`.

---

# Implementation Plan: Git Credential RBW, SOPS GPG Secrets, Email Privacy, accounts.*, and Clean Palette Hooks

## Objective
Implement secrets management, email privacy, upstream git credential helper, and clean modular theming hooks per user feedback:
1. **Upstream `git-credential-rbw` Package**:
   - Create `pkgs/git-credential-rbw.nix` wrapping upstream `doy/rbw` credential helper.
   - Wire `credential.helper = "${pkgs.git-credential-rbw}/bin/git-credential-rbw"` in `modules/programs/git.nix` and delete bespoke `writeShellApplication`.
2. **SOPS Setup with Keyring GPG Key**:
   - Create `.sops.yaml` with user's GPG key fingerprint `41F93F1724EDF2D022E696E86B2A3C5D49EE0523` inspired by `~/repos/nixos-config/.sops.yaml`.
   - Update `modules/services/sops.nix` to use `gnupg.home = "${config.home.homeDirectory}/.gnupg"`.
3. **Hide Email & Add `accounts.*` Declarations**:
   - Remove plain-text email from `modules/programs/git.nix` and `modules/services/auth-agents.nix`.
   - Include decrypted git identity from SOPS (`config.sops.secrets."git/config".path`) in `modules/programs/git.nix`.
   - Create `modules/core/accounts.nix` declaring `accounts.email.accounts.personal` with GPG key, Thunderbird integration, and optional `accounts.local.nix` import.
   - Add `accounts.local.nix` to `.gitignore`.
4. **Clean Modular Palette Hooks (Separate Nix Module, No Restarts, Package Python)**:
   - Create `pkgs/mactahoe-icon-accent.py` and `pkgs/mactahoe-icon-accent.nix` for the Python icon theme variant selection script.
   - Create `modules/environment/dconf-theme.nix` as a dedicated separate module managing the unified Noctalia dconf/gsettings template and hook.
   - Remove `restartGtkApps` and `pkill -x` loops from GTK theme compilation hooks.
   - Clean up `modules/environment/noctalia.nix`.
5. **Verification**:
   - Verify `nix flake check --no-build`.
   - Test build `pkgs.git-credential-rbw` and `pkgs.mactahoe-icon-accent`.
   - Verify activation package dry-run.

- [x] Wire upstream `pkgs.rbw` credential helper in `modules/programs/git.nix` (retiring redundant `pkgs/git-credential-rbw.nix` to prevent `pkgs.buildEnv` collision).
- [x] Update `modules/programs/git.nix` to include SOPS `gitconfig` template for user email.
- [x] Create `.sops.yaml` with GPG key `41F93F1724EDF2D022E696E86B2A3C5D49EE0523`.
- [x] Update `modules/services/sops.nix` to configure GPG home, declare secrets, and render `rbw-config.json` via sops template.
- [x] Update `modules/services/auth-agents.nix` to remove plain-text email and install `pinentry-gnome3`.
- [x] Create `modules/core/accounts.nix` and update `.gitignore` for `accounts.local.nix`.
- [x] Create `pkgs/mactahoe-icon-accent.py` and `pkgs/mactahoe-icon-accent.nix`.
- [x] Create `modules/environment/dconf-theme.nix` and clean up `modules/environment/noctalia.nix` (removing inline python, app restart loop, and separating dconf hook).
- [x] Stage untracked files by name and verify with `nix flake check --no-build`.
- [x] Test build new packages and verify activation package build.
- [x] Enable color cycling on tmux inactive windows in `modules/programs/tmux.nix` with distinct white body for active window.
- [x] Unify `user/email` secret in `modules/services/sops.nix` and `modules/programs/git.nix` via `gitconfig` template, removing inlined gitconfig in `secrets.yaml`.
- [x] Update `skills/nix-flake-eval/SKILL.md` to be aware of rebuild logs (`nix log <drv>`, `artifacts/errors/`) and activation package builds.
- [x] Add pure Pocock-driven `tdd` skill to `modules/ai/skills.nix` rendered across all 8 harnesses.
- [x] Update `skills/renderer-author` with skill authoring standards, unslop action verbs, and skills surface mapping matrix.

---

# Implementation Plan: Pass 5 — Per-Agent Skill Gating, /init, Phased SDLC Skills & Artifact CLI Contract

## Objective
Implement Pass 5 across `modules/options/ai.nix`, `modules/ai/{disciplines,skills,agents}.nix`, `modules/programs/opencode.nix`, `pkgs/artifacts-helper.nix`, and `flake.nix`:
1. **Per-Agent Skill Gating**: Add `agents` option to `skillSubmodule` in `modules/options/ai.nix`; render per-agent allow/deny permissions in `modules/programs/opencode.nix` (subagents deny all skills; primary agents allow repo-local skills while denying global skills outside their authorized agents; architect edits `artifacts/*.md` and executes `artifacts*`/`repomap*` in bash).
2. **Artifacts Discipline**: Update `ai.disciplines.artifacts.rules` in `modules/ai/disciplines.nix` with the 4 workspace files and traceable ID chain (`context.md`, `decisions.md` [DEC-xx], `specs.md` [SPEC-xx], `plan.md` [TASK-xx]).
3. **Artifact Helper CLI Script**: Create `pkgs/artifacts-helper.nix` implementing `status`, `unconverted-decs`, `unconverted-specs`, `next-tasks`, `context <TASK-id>`, and `verify-links`.
4. **Flake Check Test**: Add `checks.x86_64-linux.artifacts-helper-test` in `flake.nix` testing all 6 subcommands.
5. **8 Global Skills**: Define `init`, `grill`, `to-spec`, `to-task`, `implement`, `review`, `git-commit`, `nav-repomap` in `modules/ai/skills.nix` with `<25 word` triggers, active verbs, zero preambles, and `- Verify:` exit gates.
6. **Agent Alignment**: Update `modules/ai/agents.nix` with `execute = true` on `architect` and align agent skill declarations.

## Tasks
- [x] Add `agents` option to `skillSubmodule` in `modules/options/ai.nix`.
- [x] Update `ai.disciplines.artifacts.rules` in `modules/ai/disciplines.nix`.
- [x] Create `pkgs/artifacts-helper.nix` with the 6 subcommands and alias symlinks.
- [x] Add `checks.x86_64-linux.artifacts-helper-test` in `flake.nix` testing all 6 subcommands.
- [x] Update `modules/programs/opencode.nix` with per-agent skill gating and architect permissions.
- [x] Define the 8 global skills in `modules/ai/skills.nix` with `<25 word` triggers and examples.
- [x] Align `modules/ai/agents.nix` agent capabilities and skill lists.
- [x] Run `nix flake check` and verify the test passes cleanly.

---

# Implementation Plan: Skill Adaptation — Retain to-spec, Direct Seam Tasks, and Standalone TDD

## Objective
Adapt SDLC skills and artifact contracts per user feedback:
1. **Retain `to-spec`**: Keep `to-spec` for `architect` (`agents = [ "architect" ]`) for multi-module specifications.
2. **Grant `to-task` to `engineer`**: Set `agents = [ "architect" "engineer" ]` on `to-task`; allow tasks to absorb seam invariants directly (`- [ ] TASK-xx [SPEC-xx|DEC-xx] (blocked-by: ...): <seam invariant & outcome> | Verify: <cmd>`).
3. **Restore Standalone `tdd`**: Add dedicated Pocock-driven `tdd` skill (`agents = [ "engineer" ]`), unmixing it from `implement`.
4. **Refine `implement`**: Focus `implement` strictly on task execution lifecycle (scoped context loading, minimal hunks, explicit `| Verify: <cmd>` check).
5. **Support Direct Links in `artifacts.sh`**: Allow `context <TASK-id>` and `verify-links` to resolve `TASK [DEC-xx]` directly as well as `TASK [SPEC-xx] [DEC-xx]`.
6. **Align Agent Skills**: Update `modules/ai/agents.nix` to include `tdd` and `to-task` for `engineer`.
7. **Verify**: Ensure `nix flake check` and activation package build pass.

## Tasks
- [x] Update `pkgs/artifacts-helper.sh` to support direct `DEC-xx` links from tasks in `context` and `verify-links`.
- [x] Update `flake.nix` check derivation to verify both direct and spec-mediated task links.
- [x] Update `modules/ai/skills.nix` to include standalone `tdd`, refine `implement`, allow `engineer` on `to-task`, and absorb seam invariants.
- [x] Update `modules/ai/agents.nix` to include `to-task` and `tdd` in `engineer.skills`.
- [x] Verify `nix flake check` passes cleanly.



