# AI Config Program Plan

## Objectives
High-level and stable; distilled from PLAN.md for the ai.* system.
- [x] Capability-based multi-harness schema rendering agents, skills, and rules from one source.
- [x] Conflict-free layering: shared base plus per-harness overrides, no built-in duplication.
- [x] Capability-gated rules: procedures render only where the tools exist.
- [ ] Question tooling on every kept harness; drop harnesses without one.

## Tasks
Per-initiative execution checklists below. Append new work; closed initiatives move to artifacts/tasks/.

## Open Follow-ups
- [x] Decide harness cull: Dropped per user preference; keeping all harnesses as-is.
- [ ] Hermes config.yaml merge strategy: managed file clobbers outside user keys.
- [x] Confirm codex skills discovery: Verified on live run (`codex debug prompt-input` proves `r0 = ~/.codex/skills`).
- [ ] Scope crush union delegate rule if crush gains per-agent surfaces.
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
2. Extract per-area task checklists from `PLAN.md` into `artifacts/tasks/`.
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
Implement automated user store hygiene and generation expiration in Home Manager to satisfy `PLAN.md` Objective 34:
1. Declaratively configure `nix.gc` to run weekly with `--delete-older-than 7d`.
2. Configure a weekly systemd user service and timer to expire Home Manager generations older than 7 days using `home-manager expire-generations "-7 days"`.
3. Verify evaluation of systemd services/timers and ensure no unmanaged runtime store leakage.
4. Update `PLAN.md` user store hygiene checkboxes.

## Tasks
- [x] Test failing condition / evaluate current absent state for store hygiene timers.
- [x] Implement `modules/services/store-hygiene.nix` with `nix.gc` and `systemd.user.services.home-manager-expire-generations`.
- [x] Verify `nix eval` on generated systemd units and `nix flake check --no-build`.
- [x] Update `PLAN.md` status.
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
- [ ] Enable WebHID and fix space routing / pin positions in `modules/programs/zen-browser.nix`.
- [ ] Configure `xdg.mimeApps` in `modules/programs/zen-browser.nix` (or `modules/programs/default-apps.nix`) and update `modules/options/apps.nix`.
- [ ] Organize and expand browser hardening in `modules/programs/zen-browser.nix`.
- [ ] Document live dconf diff, `accounts.*` research, and MacTahoe Noctalia theme pipeline.
- [ ] Verify `nix eval` and `nix flake check --no-build`.
