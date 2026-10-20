{ ... }:
{
  ai.agents = {
    ask = {
      description = "Conversational questions, code explanation, and architecture discussion without file edits or command execution.";
      role = "primary";
      tier = "medium";
      capabilities = {
        read = true;
        write = false;
        execute = false;
        delegate = true;
        web = true;
      };
      dropDisciplines = [
        "report"
        "artifacts"
        "lazy"
      ];
      availableAgents = [
        "scout"
      ];
      trustedAgents = [
        "scout"
      ];
      skills = [
        "nav-repomap"
        "grill"
      ];
      prompt = "Answer technical questions, explain architectures, and discuss designs concisely without modifying files or executing shell commands.";
    };

    architect = {
      description = "System architect and specification author. Designs technical solutions and authors specs in artifacts/specs.md.";
      role = "primary";
      tier = "high";
      capabilities = {
        read = true;
        write = true;
        execute = false;
        delegate = true;
        web = true;
      };
      availableAgents = [
        "scout"
      ];
      skills = [
        "plan"
        "grill"
        "nav-repomap"
      ];
      prompt = "Design technical solutions, evaluate architectural trade-offs, and author specifications in artifacts/specs.md without executing shell commands.";
    };

    engineer = {
      description = "Software engineer. Implements features, refactors code, and verifies changes directly with targeted tests and eval.";
      role = "primary";
      tier = "medium";
      capabilities = {
        read = true;
        write = true;
        execute = true;
        delegate = true;
        web = true;
      };
      availableAgents = [
        "scout"
        "code-reviewer"
      ];
      trustedAgents = [
        "scout"
        "code-reviewer"
      ];
      skills = [
        "plan"
        "grill"
        "nav-repomap"
      ];
      prompt = "Implement features, refactor code, and verify with tests. Keep main context minimal, delegate recon to Scout, and review non-trivial diffs with Code Reviewer.";
    };

    scout = {
      description = "Read-only codebase scout and search specialist. Locates exact file:line targets, symbols, and option shapes without modifying files.";
      role = "subagent";
      tier = "low";
      capabilities = {
        read = true;
        write = false;
        execute = true;
        delegate = false;
        web = true;
      };
      skills = [
        "nav-repomap"
      ];
      prompt = "Inspect codebase and docs to answer parent queries. Cite exact file:line targets. Never edit files.";
    };

    code-reviewer = {
      description = "Code and diff reviewer for correctness, regressions, security, and conventions. Runs tests and linters; never edits code.";
      role = "subagent";
      tier = "medium";
      capabilities = {
        read = true;
        write = false;
        execute = true;
        delegate = false;
        web = false;
      };
      skills = [
        "nav-repomap"
      ];
      prompt = "Review staged diffs and recent edits for correctness, regressions, security, and repo conventions. Cite file:line for every finding.";
    };
  };
}
