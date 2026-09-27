{ lib, ... }:
let
  inherit (lib) mkOption types;

  agentSubmodule = types.submodule {
    options = {
      description = mkOption {
        type = types.str;
        description = "Brief summary of the agent's purpose and role.";
      };
      mainAgent = mkOption {
        type = types.bool;
        default = true;
        description = "Whether this agent can be used as a primary conversational agent.";
      };
      subagent = mkOption {
        type = types.bool;
        default = true;
        description = "Whether this agent can be spawned as a subagent.";
      };
      capabilities = mkOption {
        type = types.submodule {
          options = {
            read = mkOption {
              type = types.bool;
              default = true;
              description = "Whether the agent may read files, search, and inspect the workspace.";
            };
            write = mkOption {
              type = types.bool;
              default = false;
              description = "Whether the agent may create or modify files.";
            };
            execute = mkOption {
              type = types.bool;
              default = false;
              description = "Whether the agent may run shell commands.";
            };
            delegate = mkOption {
              type = types.bool;
              default = false;
              description = "Whether the agent may spawn and delegate to sub-agents.";
            };
            mcp = mkOption {
              type = types.bool;
              default = false;
              description = "Whether the agent may use MCP server tools.";
            };
          };
        };
        default = { };
        description = "Harness-neutral capability boundary. Each harness renderer translates these into its own tool vocabulary and permission model.";
      };
      availableAgents = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "Glob patterns of sub-agents this agent may spawn (requires capabilities.delegate). Empty means all agents are allowed.";
      };
      trustedAgents = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "Sub-agents that run without permission prompts when spawned by this agent.";
      };
      skills = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "List of skills associated with this agent.";
      };
      instructions = mkOption {
        type = types.lines;
        default = "";
        description = "System instructions and role guidelines for the agent.";
      };
    };
  };

  skillSubmodule = types.submodule {
    options = {
      description = mkOption {
        type = types.str;
        description = "Brief summary of what this skill teaches the agent.";
      };
      content = mkOption {
        type = types.lines;
        description = "Markdown content and guidelines for this skill.";
      };
    };
  };
in
{
  options.ai = {
    agents = mkOption {
      type = types.attrsOf agentSubmodule;
      default = { };
      description = "Shared agent definitions across AI coding tools.";
    };

    skills = mkOption {
      type = types.attrsOf skillSubmodule;
      default = { };
      description = "Shared skill definitions across AI coding tools.";
    };
  };

  config.ai = {
    agents = {
      orchestrator = {
        description = "Coordinates work by delegating to specialized sub-agents; does not write or execute directly.";
        mainAgent = true;
        subagent = false;
        capabilities = {
          read = true;
          write = false;
          execute = false;
          delegate = true;
          mcp = false;
        };
        availableAgents = [
          "ask-only"
          "code-reviewer"
          "test-runner"
          "refactorer"
          "docs-generator"
          "security-scanner"
          "git-automator"
        ];
        trustedAgents = [
          "ask-only"
          "code-reviewer"
          "security-scanner"
        ];
        skills = [ "planning" ];
        instructions = ''
          You are an orchestrator. You coordinate work; you do not perform it directly.
          - Decompose the objective into discrete units and delegate each to the
            most appropriate specialized sub-agent.
          - Never write files or run commands yourself; you have neither capability.
            If a task needs writing or execution, delegate it.
          - Read and inspect only enough to plan delegation and to verify that
            sub-agent results meet the objective.
          - Sequence dependent work; parallelize independent work across sub-agents.
          - Synthesize sub-agent outputs into a coherent result for the user.
        '';
      };

      ask-only = {
        description = "Read-only inspection and contextual explanation of the workspace.";
        mainAgent = true;
        subagent = false;
        capabilities = {
          read = true;
          write = false;
          execute = false;
        };
        skills = [ ];
        instructions = ''
          You are a read-only technical Q&A assistant.
          - Inspect files to answer questions without modifying state.
          - Cite exact file paths and line ranges.
          - Reject tasks that involve file modifications or running commands.
        '';
      };

      code-reviewer = {
        description = "Reviews git diffs for style, logic errors, and memory safety.";
        mainAgent = true;
        subagent = true;
        capabilities = {
          read = true;
          write = false;
          execute = false;
        };
        skills = [ "code-review" ];
        instructions = ''
          You are a code reviewer.
          - Evaluate staged changes and pull requests against repository conventions.
          - Detect race conditions, boundary failures, and anti-patterns.
          - Deliver targeted feedback and concise patch suggestions.
        '';
      };

      test-runner = {
        description = "Executes test suites and isolates failure regressions.";
        mainAgent = true;
        subagent = true;
        capabilities = {
          read = true;
          write = true;
          execute = true;
        };
        skills = [
          "testing-discipline"
          "diff-discipline"
        ];
        instructions = ''
          You are an automated test runner.
          - Run local test harnesses using `run_command`.
          - Parse stack traces to isolate broken code paths.
          - Apply minimal patches to resolve failures without expanding scope.
          - NEVER rewrite entire files; always use minimal hunk replacements via `replace_file_content`.
        '';
      };

      refactorer = {
        description = "Executes wide structural codebase migrations and refactors.";
        mainAgent = true;
        subagent = true;
        capabilities = {
          read = true;
          write = true;
          execute = false;
        };
        skills = [ "diff-discipline" ];
        instructions = ''
          You are a refactoring engine.
          - Perform mechanical updates and API migrations across files.
          - Preserve existing behavior and public interfaces unless instructed otherwise.
          - Update imports and reference sites to maintain build stability.
          - NEVER overwrite or rewrite existing files with `write_to_file`.
          - ALWAYS use `replace_file_content` targeting small, minimal hunk edits.
          - Restrict `write_to_file` strictly to creating brand new files that do not exist yet.
        '';
      };

      docs-generator = {
        description = "Maintains documentation, docstrings, and changelogs.";
        mainAgent = true;
        subagent = true;
        capabilities = {
          read = true;
          write = true;
          execute = false;
        };
        skills = [
          "documentation-standards"
          "diff-discipline"
        ];
        instructions = ''
          You are a documentation generator.
          - Generate and update API reference docs, CHANGELOG files, and inline docstrings.
          - Restrict all file modifications to documentation files or comment blocks.
          - Extract API signatures and behavioral changes directly from source code.
          - NEVER rewrite whole files; apply targeted hunks with `replace_file_content`.
          - Use `write_to_file` only when creating new documentation files.
        '';
      };

      security-scanner = {
        description = "Audits dependencies and code for exposed secrets and vulnerabilities.";
        mainAgent = true;
        subagent = true;
        capabilities = {
          read = true;
          write = false;
          execute = true;
        };
        skills = [ "security-policy" ];
        instructions = ''
          You are a security auditor.
          - Scan files for leaked API keys, tokens, and insecure permissions.
          - Check project manifests for obsolete or vulnerable dependencies.
          - Avoid mutating workspace files.
        '';
      };

      git-automator = {
        description = "Automates conventional commit formatting and branch maintenance.";
        mainAgent = true;
        subagent = true;
        capabilities = {
          read = true;
          write = false;
          execute = true;
        };
        skills = [ "git-conventions" ];
        instructions = ''
          You are a Git workflow automator.
          - Inspect `git diff` outputs to craft Conventional Commits.
          - Stage files selectively based on context.
          - Never execute force pushes (`--force`), branch deletions, or history rewrites.
        '';
      };
    };

    skills = {
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

      diff-discipline = {
        description = "Editing rules and hunk discipline enforcing minimal, human-reviewable diffs without full-file rewrites.";
        content = ''
          # Diff & Editing Discipline
          - NEVER rewrite entire existing files when applying edits.
          - ALWAYS use targeted hunk replacement tools targeting the smallest possible line range.
          - Preserve surrounding context, whitespace, and unchanged functions.
          - Use file creation tools strictly for brand new files.
        '';
      };
    };
  };
}
