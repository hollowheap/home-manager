{ pkgs, ... }:
{
  ai.skills = {
    plan = {
      description = "Structured implementation planning with atomic tasks and verification in artifacts/plan.md. Use when task needs 3+ steps, multi-file changes, or coordination. Do NOT use for single trivial edits.";
      content = ''
        Sequential atomic tasks with explicit verification. No state changes before plan exists.

        ## Use / Do NOT use

        Use when: non-trivial feature, refactor across files, delegated or multi-phase work.
        Do NOT use when: single-line fix, docs typo, or purely informational question.

        ## Workflow

        1. Read relevant files/specs before drafting; never assume architecture.
        2. Write artifacts/plan.md: Objective, numbered Tasks, Verification per task.
        3. Keep exactly one task in_progress; mark completed only after verification passes.
        4. Update roadmap as milestones are achieved; add follow-ups discovered mid-work.
        5. See references/template.md for required headings.

        ## Rules

        1. Tasks are atomic: one action + one verifiable outcome each.
        2. Every task names its check (test cmd, eval, build).
        3. Never batch completions; update status in real time.
        4. Objectives are stable and high-level; append new work as Tasks sections, move closed initiatives to artifacts/tasks/<slug>.md.
        5. Ownership: the engineer maintains plan.md; architects and orchestrators contribute roadmaps through this skill.

        ## Bad / Good

        Bad: start editing, plan "in head", lose track mid-refactor.
        Good: plan.md with `- [ ] Add pill helper`, `- [ ] Wire lualine sections`, `- [ ] nix flake check`, then edit.

        ## Verification

        artifacts/plan.md exists with Objective/Tasks/Verification; all boxes checked on completion.
      '';
      references."template.md" = ''
        # Plan
        ## Objectives
        Stable high-level goals (see PLAN.md); new initiatives append Tasks below.
        Closed initiatives move to artifacts/tasks/; this file keeps objectives and active work.
        ## Tasks
        - [ ] Action + file path + outcome
        - [ ] Next action + verification cmd
        ## Verification
        Exact commands: tests, nix eval, nix build, nix flake check.
      '';
    };

    question = {
      description = "Question-tool ambiguity clarification with recommended-first options. Use when architectural assumption is risky and the harness exposes a question tool. Do NOT use without one; flag the harness instead.";
      content = ''
        Requires a built-in question tool (opencode: question, antigravity: ask_question). Never improvise CLI menus.

        ## Use / Do NOT use

        Use when: architectural assumption is risky, destructive scope, or 2+ valid designs with big tradeoffs.
        Do NOT use when: the harness exposes no question tool (flag the harness for removal), convention exists, or change is reversible.

        ## Workflow

        1. Complete all non-blocked work before asking.
        2. Identify the single blocking ambiguity; state assumption you would otherwise make.
        3. Invoke the harness question tool with 2-4 options.
        4. Put the recommended option first (opencode: append (Recommended)); never add catch-all options the tool already provides (opencode: custom answer).
        5. Ask in full sentences even under unslop; precision beats brevity here.

        ## Rules

        1. Exhaust two or three distinct approaches before asking or declaring blocked; report what was tried.
        2. Max 2-3 questions per turn; batch related options.
        3. Each option names consequence (cost, scope, reversibility).
        4. Never assume destructive, security, or persisted-output decisions.

        ## Bad / Good

        Bad: numbered CLI menu pasted as chat text.
        Good: tool call with options and a recommended default, then proceed on answers.

        ## Verification

        Answers recorded verbatim; proceed only after answer or explicit default approval.
      '';
    };

    nav-repomap = {
      description = "Repository symbol navigation via repomap artifact and slice reads. Use when locating definitions in unfamiliar code or finding exact line ranges. Do NOT use when file path is already known and small.";
      content = ''
        Locate first, read slices second, search last.

        ## Use / Do NOT use

        Use when: unfamiliar repo, symbol hunt, exact file:line needed for edits.
        Do NOT use when: you already know the small target file; just Read it.

        ## Workflow

        1. Run scripts/repomap.sh to generate/refresh artifacts/repomap.md when missing or outdated.
        2. Consult artifacts/repomap.md to locate symbol definitions and exact line ranges.
        3. Read targeted line ranges with Read offset/limit.
        4. Fall back to Glob (fd semantics) and Grep (rg -n -C 2 semantics) when symbol absent from repomap.

        ## Rules

        1. Never guess line numbers; cite repomap or Grep result.
        2. Slice reads over full-file dumps; 30-60 line windows.
        3. Refresh repomap after renames/moves, not on every edit.

        ## Bad / Good

        Bad: Grep entire store for `mk_pill` unbounded.
        Good: repomap -> `modules/programs/nvim.nix:42` -> Read offset 35 limit 30.

        ## Verification

        Answer cites exact file paths and line ranges; edits anchor on verified hunks.
      '';
      scripts."repomap.sh" = ''
        #!/usr/bin/env bash
        mkdir -p artifacts
        exec ${pkgs.repomap}/bin/repomap "$@"
      '';
    };

    shared-tree = {
      description = "Parallel-session protocol for shared repos. Use when git log or status shows foreign activity, or before staging and committing. Do NOT use for solo workspaces.";
      content = ''
        Other sessions work this tree. Coordinate, don't fight.

        ## Use / Do NOT use

        Use when: foreign commits or file activity appear, staging, committing.
        Do NOT use when: sole owner of the tree.

        ## Workflow

        1. Inspect git status, git diff, and git log --oneline before staging.
        2. Stage files explicitly by name; never touch others' paths.
        3. Never amend, rebase, or rewrite shared history.
        4. Plan files are append-only per initiative; expect interleaving.

        ## Rules

        1. Your files swept into others' commits: verify state, keep working.
        2. Commit message notes foreign content included, if any.
        3. Uncommitted work stays uncommitted unless asked.

        ## Bad / Good

        Bad: `git add -A` swallowing a parallel session's half-done theme work.
        Good: status review, explicit paths, conventional commit, their tree intact.

        ## Verification

        Commit contains only intended paths; foreign files untouched.
      '';
    };

    upstream-recon = {
      description = "Upstream module archaeology via store source and option eval. Use before writing a renderer against a home-manager or nixpkgs module. Do NOT guess option shapes.";
      content = ''
        Read the upstream source first; option shapes rot in memory, not in store.

        ## Use / Do NOT use

        Use when: new renderer, unknown option surface, package attr in doubt.
        Do NOT use when: the surface is already verified this session.

        ## Workflow

        1. Read option descriptions via eval (`.description` on the option path).
        2. Follow `.declarations` into /nix/store source; read the module file.
        3. Confirm package attrs (`meta.description`, `meta.mainProgram`) by eval.
        4. Write the renderer against verified shapes only.

        ## Rules

        1. Near-miss names burn: verify exact attr (`codex`, not `codex-cli`).
        2. Declarations path first; web search only when store lookup fails.
        3. Record verified shapes in the plan for the next reader.

        ## Bad / Good

        Bad: assume `programs.codex.agents` exists; fail at eval time.
        Good: attrNames shows context/skills/rules only; agents go via home.file TOML.

        ## Verification

        Every referenced option and package evals; renderer writes no guesswork.
      '';
    };

    overlap-check = {
      description = "Built-in prompt overlap audit for shared text. Use before adding always-on disciplines or rules. Do NOT drop lines without verified overlap.";
      content = ''
        Every always-on line costs every turn on every harness. Prove duplication before cutting.

        ## Use / Do NOT use

        Use when: adding disciplines, rules, or global context lines.
        Do NOT use when: editing per-agent or on-demand skill text.

        ## Workflow

        1. Fetch the harness base prompt (store source, docs, or repo file).
        2. Matrix each candidate line against built-in coverage.
        3. Drop only verified overlap; empty map plus comment otherwise.
        4. Re-verify rendered output per harness after wiring drops.

        ## Rules

        1. Closed prompts are unverifiable: no drops, ever.
        2. Partial coverage keeps the line; drops need full coverage.
        3. One harness's proof never transfers to another.
        4. Measure the same prompt before and after; never trust vendor percentages. Audit rendered context size (chars÷4 ≈ tokens per harness) before claiming any win.

        ## Bad / Good

        Bad: drop conciseness everywhere because crush is terse; pi goes chatty.
        Good: opencode and crush drop three lines each with source links; rest render full.

        ## Verification

        Rendered contexts show drops exactly where proven, full text elsewhere.
      '';
    };
  };
}
