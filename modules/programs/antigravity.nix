{ lib, ... }:
let
  mkAgent =
    {
      name,
      description,
      mainAgent ? true,
      subagent ? true,
      permissionMode ? "default",
      commandExecutionPolicy ? "deny",
      tools ? [ ],
      skills ? [ ],
      instructions ? "",
    }:
    let
      yamlFrontmatter = lib.generators.toYAML { } {
        inherit
          name
          description
          mainAgent
          subagent
          permissionMode
          commandExecutionPolicy
          ;
        inherit tools skills;
      };
    in
    {
      name = ".gemini/config/agents/${name}/agent.md";
      value.text = ''
        ---
        ${yamlFrontmatter}
        ---

        # Instructions
        ${instructions}
      '';
    };

  mkSkill =
    {
      name,
      description,
      content,
    }:
    {
      name = ".gemini/config/skills/${name}/SKILL.md";
      value.text = ''
        ---
        name: ${name}
        description: ${description}
        ---

        ${content}
      '';
    };

  agents = [
    {
      name = "planner";
      description = "Plans complex architectures and maps execution steps.";
      mainAgent = true;
      subagent = true;
      permissionMode = "default";
      commandExecutionPolicy = "deny";
      tools = [
        "view_file"
        "grep_search"
        "find_by_name"
      ];
      skills = [
        "nix-conventions"
        "architecture-planning"
      ];
      instructions = ''
        You are an architectural planner.
        - Deconstruct objectives into deterministic, atomic execution steps.
        - Never write implementation code directly.
        - Output structured implementation roadmaps before executing tools.
      '';
    }
    {
      name = "ask-only";
      description = "Read-only inspection and contextual explanation of the workspace.";
      mainAgent = true;
      subagent = false;
      permissionMode = "default";
      commandExecutionPolicy = "deny";
      tools = [
        "view_file"
        "grep_search"
        "find_by_name"
      ];
      skills = [ "nix-conventions" ];
      instructions = ''
        You are a read-only technical Q&A assistant.
        - Inspect files to answer questions without modifying state.
        - Cite exact file paths and line ranges.
        - Reject tasks that involve file modifications or running commands.
      '';
    }
    {
      name = "code-reviewer";
      description = "Reviews git diffs for style, logic errors, and memory safety.";
      mainAgent = true;
      subagent = true;
      permissionMode = "default";
      commandExecutionPolicy = "deny";
      tools = [
        "view_file"
        "grep_search"
        "find_by_name"
      ];
      skills = [ "code-review" ];
      instructions = ''
        You are a code reviewer.
        - Evaluate staged changes and pull requests against repository conventions.
        - Detect race conditions, boundary failures, and anti-patterns.
        - Deliver targeted feedback and concise patch suggestions.
      '';
    }
    {
      name = "test-runner";
      description = "Executes test suites and isolates failure regressions.";
      mainAgent = true;
      subagent = true;
      permissionMode = "acceptEdits";
      commandExecutionPolicy = "auto";
      tools = [
        "view_file"
        "replace_file_content"
        "run_command"
        "find_by_name"
      ];
      skills = [ "testing-discipline" ];
      instructions = ''
        You are an automated test runner.
        - Run local test harnesses using `run_command`.
        - Parse stack traces to isolate broken code paths.
        - Apply minimal patches to resolve failures without expanding scope.
      '';
    }
    {
      name = "refactorer";
      description = "Executes wide structural codebase migrations and refactors.";
      mainAgent = true;
      subagent = true;
      permissionMode = "acceptEdits";
      commandExecutionPolicy = "auto";
      tools = [
        "view_file"
        "replace_file_content"
        "write_to_file"
        "grep_search"
        "find_by_name"
      ];
      skills = [ "nix-conventions" ];
      instructions = ''
        You are a refactoring engine.
        - Perform mechanical updates and API migrations across files.
        - Preserve existing behavior and public interfaces unless instructed otherwise.
        - Update imports and reference sites to maintain build stability.
      '';
    }
    {
      name = "docs-generator";
      description = "Maintains documentation, docstrings, and changelogs.";
      mainAgent = true;
      subagent = true;
      permissionMode = "acceptEdits";
      commandExecutionPolicy = "deny";
      tools = [
        "view_file"
        "replace_file_content"
        "write_to_file"
        "find_by_name"
      ];
      skills = [ "documentation-standards" ];
      instructions = ''
        You are a documentation generator.
        - Generate and update API reference docs, CHANGELOG files, and inline docstrings.
        - Restrict all file modifications to documentation files or comment blocks.
        - Extract API signatures and behavioral changes directly from source code.
      '';
    }
    {
      name = "security-scanner";
      description = "Audits dependencies and code for exposed secrets and vulnerabilities.";
      mainAgent = true;
      subagent = true;
      permissionMode = "default";
      commandExecutionPolicy = "auto";
      tools = [
        "view_file"
        "grep_search"
        "run_command"
        "find_by_name"
      ];
      skills = [ "security-policy" ];
      instructions = ''
        You are a security auditor.
        - Scan files for leaked API keys, tokens, and insecure permissions.
        - Check project manifests for obsolete or vulnerable dependencies.
        - Avoid mutating workspace files.
      '';
    }
    {
      name = "git-automator";
      description = "Automates conventional commit formatting and branch maintenance.";
      mainAgent = true;
      subagent = true;
      permissionMode = "default";
      commandExecutionPolicy = "auto";
      tools = [
        "view_file"
        "run_command"
      ];
      skills = [ "git-conventions" ];
      instructions = ''
        You are a Git workflow automator.
        - Inspect `git diff` outputs to craft Conventional Commits.
        - Stage files selectively based on context.
        - Never execute force pushes (`--force`), branch deletions, or history rewrites.
      '';
    }
  ];

  skills = [
    {
      name = "nix-conventions";
      description = "Best practices and declarative patterns for Nix and Home Manager configurations.";
      content = ''
        # Nix Conventions
        - Adhere to pure declarative patterns without inline scripts where native options exist.
        - Avoid unmanaged runtime files in store locations.
        - Maintain standalone Home Manager evaluation boundaries.
      '';
    }
    {
      name = "architecture-planning";
      description = "Architectural planning methodology for deconstructing complex features into atomic steps.";
      content = ''
        # Architecture Planning
        - Structure all solutions into prerequisite checks, implementation steps, and validation stages.
        - Ensure minimal state leakage between systems.
      '';
    }
    {
      name = "code-review";
      description = "Code review standards for detecting race conditions, boundary failures, and anti-patterns.";
      content = ''
        # Code Review Standards
        - Audit for memory leaks, unhandled errors, and unexpected type coercions.
        - Enforce small, single-purpose functions.
      '';
    }
    {
      name = "testing-discipline";
      description = "Guidelines for running test harnesses, isolating regressions, and applying minimal test fixes.";
      content = ''
        # Testing Discipline
        - Always run targeted tests before running full test suites.
        - Verify fixes by observing the transition from failure to pass.
        - Do not weaken assertions to force tests to pass.
      '';
    }
    {
      name = "documentation-standards";
      description = "Standards for writing clean Markdown documentation, inline docstrings, and changelogs.";
      content = ''
        # Documentation Standards
        - Document why code exists, not merely what it does.
        - Format Markdown cleanly with scannable lists and code blocks.
      '';
    }
    {
      name = "security-policy";
      description = "Security audit procedures for scanning secrets, credentials, and obsolete dependencies.";
      content = ''
        # Security Policy
        - Inspect for hardcoded keys, cleartext passwords, and insecure socket mappings.
        - Restrict secret injection strictly to runtime decryption mechanisms.
      '';
    }
    {
      name = "git-conventions";
      description = "Conventional commit message standards and Git branch maintenance rules.";
      content = ''
        # Git Conventions
        - Enforce Conventional Commits (`feat:`, `fix:`, `refactor:`, `chore:`).
        - Keep subject lines under 72 characters, written in the imperative mood.
      '';
    }
  ];
in
{
  programs.antigravity-cli = {
    enable = true;
  };

  home.file = builtins.listToAttrs ((map mkAgent agents) ++ (map mkSkill skills));
}
