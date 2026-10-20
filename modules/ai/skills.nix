{ pkgs, ... }:
{
  ai.skills = {
    init = {
      description = "Scout repo architecture and commands into artifacts/context.md. Load ONLY when onboarding or initializing a repo. Do NOT load when context.md exists.";
      agents = [
        "architect"
        "engineer"
      ];
      content = ''
        ## Workflow

        1. Inspect artifacts/context.md; if already non-empty and user did not request refresh, stop immediately.
        2. Inspect workspace manifests, source entrypoints, directory seams, and test runners directly or via Scout.
        3. Verify build, check, and test commands in the shell to confirm they pass.
        4. Write artifacts/context.md (<60 lines) with ## Stack & Entrypoints, ## Commands, and ## Module Seams.

        ## Rules

        - Keep artifacts/context.md strictly under 60 lines.
        - Record only verified build, check, and eval commands; run commands before writing.
        - Document high-level module seams and boundary entrypoints, never internal functions.
        - Verify: artifacts/context.md exists with non-empty ## Stack & Entrypoints, ## Commands, and ## Module Seams sections.
      '';
      references."examples.md" = ''
        # Init Examples

        ## Bad
        - Dumping 300 lines of file trees and internal types into context.md.
        - Writing unverified commands that fail during subsequent implementation.

        ## Good
        - Scout manifests, identify `nix flake check --no-build`, verify it passes, and write 30-line artifacts/context.md.
      '';
      scripts."artifacts.sh" = ''
        #!/usr/bin/env bash
        exec ${pkgs.artifacts-helper}/bin/artifacts.sh "$@"
      '';
    };

    grill = {
      description = "Interactive design-tree interview resolving architecture decisions into artifacts/decisions.md. Load ONLY when requirements or decisions are open. Do NOT load for settled tasks.";
      agents = [
        "architect"
        "engineer"
      ];
      content = ''
        ## Workflow

        1. Run scripts/artifacts.sh status to inspect workspace state:
           - Greenfield or empty repo (CONTEXT:none and zero code files): run zero code inspection tools (grill-me mode); interview user directly.
           - Existing uninitialized repo (CONTEXT:none): run init to populate artifacts/context.md before interviewing.
           - Initialized repo (CONTEXT:present or existing artifacts): read artifacts/context.md and artifacts/decisions.md; spawn Scout only for unmapped questions.
        2. Separate repo-verifiable facts from user decisions: check plain-text repo/docs once; never run strings/objdump/hexdump on binaries.
        3. Ask all independent frontier questions in one round: use harness question tool with (Recommended) first when available; otherwise output numbered questions with (Recommended) default and end turn.
        4. Settle confirmed decisions into artifacts/decisions.md: append - [ ] DEC-xx: <decision> | Why: <rationale> and ## Non-Goals.

        ## Rules

        - Exhaust plain-text repo/docs lookup before asking; never ask questions the codebase answers directly.
        - Ask all independent questions in a single turn; avoid multi-turn interrogation when options are decoupled.
        - Put recommended option first with clear rationale and trade-offs.
        - Record settled decisions in artifacts/decisions.md with explicit | Why: <rationale>.
        - Verify: artifacts/decisions.md contains settled - [ ] DEC-xx items and scripts/artifacts.sh unconverted-decs reports them.
      '';
      references."examples.md" = ''
        # Grill Examples

        ## Bad
        - Asking three sequential questions across three turns when all three were known upfront.
        - Asking user for the project build command when flake.nix defines it.

        ## Good
        - Single round with 2 decoupled questions, (Recommended) defaults marked, clear impact on architecture.
        - Settle output as `- [ ] DEC-01: SQLite storage | Why: single-node simplicity` in `artifacts/decisions.md`.
      '';
      scripts."artifacts.sh" = ''
        #!/usr/bin/env bash
        exec ${pkgs.artifacts-helper}/bin/artifacts.sh "$@"
      '';
    };

    to-spec = {
      description = "Convert settled decisions into module seams and invariants in artifacts/specs.md. Load ONLY when decisions.md has unconverted DEC items. Do NOT load for tasks.";
      agents = [
        "architect"
      ];
      content = ''
        ## Workflow

        1. Run scripts/artifacts.sh unconverted-decs; if output is NONE, stop immediately.
        2. Formulate public module seams, boundary interfaces, and testable behavioral invariants for each decision.
        3. Append specifications to artifacts/specs.md: - [ ] SPEC-xx [DEC-xx]: <seam & invariant> | Verify: <check>.
        4. Mark converted decisions complete in artifacts/decisions.md: - [x] DEC-xx: ...
        5. Run scripts/artifacts.sh verify-links to ensure valid trace references.

        ## Rules

        - Every spec must reference at least one valid parent decision [DEC-xx].
        - Specify public seams and external behavioral invariants; never mandate private internal implementation.
        - Every spec must declare an explicit verification check command (| Verify: <cmd>).
        - Mark parent decisions complete immediately after drafting corresponding specifications.
        - Verify: scripts/artifacts.sh verify-links outputs OK and scripts/artifacts.sh unconverted-specs lists new items.
      '';
      references."examples.md" = ''
        # To-Spec Examples

        ## Bad
        - Writing specs that reference non-existent DEC IDs or omitting the verify command.
        - Specifying internal helper function signatures instead of public module boundaries.

        ## Good
        - Convert `- [ ] DEC-01: SQLite storage | Why: simplicity` into `- [ ] SPEC-01 [DEC-01]: Database seam exports query helpers | Verify: nix eval .#dbCheck`.
      '';
      scripts."artifacts.sh" = ''
        #!/usr/bin/env bash
        exec ${pkgs.artifacts-helper}/bin/artifacts.sh "$@"
      '';
    };

    to-task = {
      description = "Decompose specifications or decisions into vertical tasks absorbing seam invariants in artifacts/plan.md. Load ONLY when converting items. Do NOT load during active coding.";
      agents = [
        "architect"
        "engineer"
      ];
      content = ''
        ## Workflow

        1. Run scripts/artifacts.sh unconverted-specs; if NONE, check scripts/artifacts.sh unconverted-decs. If both NONE, stop immediately.
        2. Decompose specifications or decisions into atomic vertical tasks absorbing public seam invariants directly into task outcomes.
        3. Append tasks to artifacts/plan.md: - [ ] TASK-xx [SPEC-xx|DEC-xx] (blocked-by: none|TASK-yy): <seam invariant & goal outcome> | Verify: <cmd>.
        4. Mark converted specifications in artifacts/specs.md or decisions in artifacts/decisions.md complete: - [x] ...
        5. Run scripts/artifacts.sh verify-links to confirm valid trace links.

        ## Rules

        - Every task references its parent [SPEC-xx] or [DEC-xx] and dependency (blocked-by: none|TASK-yy).
        - Embed public seam invariants directly in the task description.
        - Ensure initial task specifies (blocked-by: none) so implementation can begin immediately.
        - Keep tasks atomic with exactly one verifiable outcome and command per task.
        - Verify: scripts/artifacts.sh verify-links outputs OK and scripts/artifacts.sh next-tasks lists ready tasks.
      '';
      references."examples.md" = ''
        # To-Task Examples

        ## Bad
        - Tasks referencing missing IDs or circular/unmarked dependencies.
        - Massive multi-action tasks like "build whole backend and frontend".

        ## Good
        - `- [ ] TASK-01 [SPEC-01] (blocked-by: none): Define schema types | Verify: nix build`
        - `- [ ] TASK-02 [DEC-01] (blocked-by: TASK-01): Implement query interface | Verify: nix flake check`
      '';
      scripts."artifacts.sh" = ''
        #!/usr/bin/env bash
        exec ${pkgs.artifacts-helper}/bin/artifacts.sh "$@"
      '';
    };

    implement = {
      description = "Implement next unblocked vertical task with verification check. Load ONLY when an unblocked task is ready in artifacts/plan.md. Do NOT load for planning.";
      agents = [
        "engineer"
      ];
      content = ''
        ## Workflow

        1. Run scripts/artifacts.sh next-tasks to locate unblocked work; if NONE, stop immediately.
        2. Run scripts/artifacts.sh context <TASK-id> to load scoped commands, specs, decisions, and seam invariants; do not read unrelated files.
        3. Review the absorbed seam invariant and run the verification command first if checking existing behavior.
        4. Implement minimum production code required to satisfy the invariant using targeted hunk edits.
        5. Re-run task verification command to confirm pass, then run broader test suite for regressions.
        6. Mark task complete in artifacts/plan.md: - [x] TASK-xx: ...

        ## Rules

        - Load context strictly via scripts/artifacts.sh context <TASK-id>.
        - Respect absorbed seam invariants: change internal implementation without breaking public boundaries.
        - Apply minimal hunk edits; avoid unsolicited refactoring or premature abstractions.
        - If developing code with test runners, consult tdd skill for seam-based test authoring.
        - Mark task complete only after verification check command passes.
        - Stop immediately once verification passes.
        - Verify: Task check command passes and artifacts/plan.md reflects - [x] TASK-xx.
      '';
      references."examples.md" = ''
        # Implement Examples

        ## Bad
        - Starting implementation without checking `scripts/artifacts.sh next-tasks` and editing blocked tasks.
        - Marking tasks complete without executing the verification command.

        ## Good
        - Run `scripts/artifacts.sh context TASK-01`, run reproducer, implement minimal hunk, verify pass, and check box.
      '';
      scripts."artifacts.sh" = ''
        #!/usr/bin/env bash
        exec ${pkgs.artifacts-helper}/bin/artifacts.sh "$@"
      '';
    };

    tdd = {
      description = "Test-driven development via public seams and vertical slices. Load ONLY when writing code with test runners. Do NOT load for declarative configs or pure docs.";
      agents = [
        "engineer"
      ];
      content = ''
        ## Workflow

        1. Identify public seam with user; define external boundary where behavior is observed.
        2. Write one minimal test asserting desired behavior across that seam.
        3. Run test runner; capture exact failure line and error message.
        4. Implement minimum production code required to satisfy the test.
        5. Re-run test to confirm pass, then run broader suite to ensure zero regressions.
        6. Refactor implementation and test for clarity, keeping suite green.
        7. Repeat one vertical slice at a time; never write tests in bulk.

        ## Rules

        - Test behavior through public seams; never assert on private functions or internal state.
        - Keep tests durable across refactors: tests pass unchanged if internals change completely.
        - Work in strict vertical slices: one test, one implementation, one refactor per cycle.
        - Discard production code written before capturing a failing test.
        - Write DAMP tests over DRY: prefer clear test narratives over shared helper abstractions.
        - Mock only external boundaries (network, filesystem, clock); never mock internal domain logic.
        - Verify: Targeted test fails first, passes with minimal implementation, and suite remains green.
      '';
      references."examples.md" = ''
        # TDD Examples

        ## Bad
        - Writing 10 unit tests for internal helper functions before writing implementation.
        - Mocking the entire database, state container, and sibling classes to test a simple calculation.

        ## Good
        - Confirm public API endpoint or module export with user.
        - Write a single failing test against the public export.
        - Run test, observe failure, implement minimal code to pass, refactor cleanly, repeat for next slice.
      '';
    };

    review = {
      description = "Audit staged changes and task edits for regressions and invariants. Load ONLY after implementing a task before committing. Do NOT load during active coding.";
      agents = [
        "engineer"
      ];
      content = ''
        ## Workflow

        1. Run git status and git diff to inspect changes produced during task implementation.
        2. Delegate diff review to Code Reviewer subagent citing the task specification and invariant.
        3. Review subagent findings for correctness bugs, regressions, secret leaks, and security flaws.
        4. Apply minimal patches for any high or medium severity findings.
        5. Re-run task verification commands to confirm the suite remains green.

        ## Rules

        - Review diffs against parent SPEC-xx behavioral invariants.
        - Treat Code Reviewer as read-only; implement fixes directly in the engineer session.
        - Reject unsolicited refactoring, scope creep, and unrequested style cleanup.
        - Verify: Zero high or medium severity review findings and verification suite passes.
      '';
      references."examples.md" = ''
        # Review Examples

        ## Bad
        - Skipping review before committing multi-file refactors.
        - Asking reviewer to rewrite entire files instead of citing exact line numbers.

        ## Good
        - Run git diff, delegate to Code Reviewer, receive line-number citations, patch boundary bug, re-verify.
      '';
      scripts."artifacts.sh" = ''
        #!/usr/bin/env bash
        exec ${pkgs.artifacts-helper}/bin/artifacts.sh "$@"
      '';
    };

    git-commit = {
      description = "Stage verified files and craft Conventional Commits. Load ONLY on explicit user request to commit. Do NOT load during planning or implementation.";
      agents = [
        "engineer"
      ];
      content = ''
        ## Workflow

        1. Run git status, git diff, and git log --oneline -n 5 to inspect working tree state and foreign session edits.
        2. Check diffs for exposed secrets, API keys, tokens, or private credentials before staging.
        3. Stage intended task files explicitly by path; never run git add -A or git add .
        4. Commit with <type>(<scope>): <imperative summary> (<=50 chars, types: feat|fix|refactor|docs|test|chore|perf|ci|build|style).
        5. Map one verified plan.md task to one commit; never rewrite shared git history.

        ## Rules

        - Never commit unless explicitly requested by the user.
        - Always stage explicit file paths; never use blanket git add commands.
        - Check diffs for keys, tokens, and secrets before staging.
        - Never revert, amend, or reset changes made outside the current session.
        - Never force-push, delete remote branches, or rewrite history.
        - Verify: git log -n 1 shows conventional commit message and git diff --staged is clean.
      '';
      references."examples.md" = ''
        # Git-Commit Examples

        ## Bad
        - Committing without user request during a coding or planning turn.
        - Running `git add .` and accidentally staging `.env` or untracked secret keys.

        ## Good
        - User asks "commit changes", agent runs `git status`, stages explicit files, and commits with `feat(ai): add init skill`.
      '';
    };

    nav-repomap = {
      description = "Symbol navigation via repomap and slice reads. Load ONLY when locating definitions or line ranges in unfamiliar code. Do NOT load for known paths.";
      agents = [
        "architect"
        "engineer"
      ];
      content = ''
        ## Workflow

        1. Run scripts/repomap.sh to generate or refresh artifacts/repomap.md when missing or outdated.
        2. Search artifacts/repomap.md for target identifiers, types, or function definitions to locate file paths.
        3. Read 30-60 line slices around target definitions; never dump entire large files into context.
        4. Fall back to targeted ripgrep (rg -n) or fd only if repomap does not index the symbol.

        ## Rules

        - Locate definitions first, read targeted slices second, search with ripgrep last.
        - Never dump full files when only a function or type definition is needed.
        - Bound slice reads to 30-60 lines around target symbols.
        - Verify: Target symbol located with exact file and line range confirmed.
      '';
      references."examples.md" = ''
        # Nav-Repomap Examples

        ## Bad
        - Reading a 1500-line file from line 1 to 1500 to find a 10-line function definition.
        - Running broad grep across the entire workspace without checking repomap first.

        ## Good
        - Search `artifacts/repomap.md` for `mk_pill`, identify line 150 of `modules/programs/nvim.nix`, and read lines 145-175.
      '';
      scripts."repomap.sh" = ''
        #!/usr/bin/env bash
        mkdir -p artifacts
        exec ${pkgs.repomap}/bin/repomap "$@"
      '';
    };
  };
}
