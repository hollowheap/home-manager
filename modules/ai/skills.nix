{ ... }:
{
  ai.skills = {
    planning = {
      description = "Project planning methodology for turning objectives into structured, atomic execution roadmaps.";
      content = ''
        # Planning

        Produce a plan using the structure below. Treat sections as adaptive:
        include one only when it carries real content, but ALWAYS keep
        "Open Questions & Notes" so anything that does not fit elsewhere is
        never silently dropped. Prefer the smallest plan that fully meets the
        objective.

        ## Template

        # Project Plan

        ## Objective
        Purpose, core focus, and target outcome. State measurable success
        criteria; if success is not measurable, say so explicitly.

        ## Master List of Goals
        - [ ] [High-level goal]

        ## Tasks
        Actionable, atomic items. Note ordering and dependencies where they
        matter; do not list a dependent task before its prerequisite.
        - [ ] [Task item]

        ## Validation
        How each goal/task is verified (build, tests, manual checks). A task
        is not "done" until its acceptance criteria are defined and met.
        - [ ] [Acceptance criterion]

        ## Architecture
        * [Component]: design pattern, data flow, module boundaries, or
          interface contracts.

        ## Scope
        ### Included
        * [Component or workflow within scope]
        ### Excluded
        * [Explicitly omitted component, platform, or workflow]

        ## Tech Stack
        * Languages: [...]
        * Frameworks and Libraries: [...]
        * Tools: [...]

        ## Risks & Rollback
        Forward-looking failure modes and how to reverse changes if they go
        wrong. (Distinct from Known Issues, which are already-observed.)
        - [ ] [Risk and mitigation]

        ## Known Issues
        - [ ] [Documented bug, upstream conflict, or runtime limitation]

        ## Open Questions & Notes
        Unresolved items, assumptions made, and anything that does not fit the
        sections above. NEVER omit this section.

        ## Discipline
        - Never write implementation code while planning; produce the roadmap first.
        - Structure work into prerequisites, atomic steps, and validation stages.
        - Ensure minimal state leakage between systems; prefer clear boundaries.
      '';
    };

    code-review = {
      description = "Code review standards for detecting race conditions, boundary failures, and anti-patterns.";
      content = ''
        # Code Review Standards
        - Audit for memory leaks, unhandled errors, and unexpected type coercions.
        - Enforce small, single-purpose functions.
      '';
    };

    testing-discipline = {
      description = "Guidelines for running test harnesses, isolating regressions, and applying minimal test fixes.";
      content = ''
        # Testing Discipline
        - Always run targeted tests before running full test suites.
        - Verify fixes by observing the transition from failure to pass.
        - Do not weaken assertions to force tests to pass.
      '';
    };

    documentation-standards = {
      description = "Standards for writing clean Markdown documentation, inline docstrings, and changelogs.";
      content = ''
        # Documentation Standards
        - Document why code exists, not merely what it does.
        - Format Markdown cleanly with scannable lists and code blocks.
      '';
    };

    security-policy = {
      description = "Security audit procedures for scanning secrets, credentials, and obsolete dependencies.";
      content = ''
        # Security Policy
        - Inspect for hardcoded keys, cleartext passwords, and insecure socket mappings.
        - Restrict secret injection strictly to runtime decryption mechanisms.
      '';
    };

    git-conventions = {
      description = "Conventional commit message standards and Git branch maintenance rules.";
      content = ''
        # Git Conventions
        - Enforce Conventional Commits (`feat:`, `fix:`, `refactor:`, `chore:`).
        - Keep subject lines under 72 characters, written in the imperative mood.

        ## Committing at Milestones
        - Commit whenever a coherent, self-contained milestone is reached
          (a feature works, a refactor is complete, tests pass), not on a
          fixed cadence.
        - Each commit must be one logical change. Group related edits; never
          mix unrelated concerns in a single commit.
        - Stage files explicitly by name; never `git add -A` or `git add .`.
        - A milestone is committable only when the tree evaluates/builds and
          relevant checks pass. Do not commit known-broken states.
      '';
    };
  };
}
