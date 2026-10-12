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

        ## Bad / Good

        Bad: start editing, plan "in head", lose track mid-refactor.
        Good: plan.md with `- [ ] Add pill helper`, `- [ ] Wire lualine sections`, `- [ ] nix flake check`, then edit.

        ## Verification

        artifacts/plan.md exists with Objective/Tasks/Verification; all boxes checked on completion.
      '';
      references."template.md" = ''
        # Plan
        ## Objective
        What + why in 2 sentences.
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

  };
}
