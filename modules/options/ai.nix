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
            web = mkOption {
              type = types.bool;
              default = false;
              description = "Whether the agent may fetch and search the web.";
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

  disciplineSubmodule = types.submodule {
    options = {
      description = mkOption {
        type = types.str;
        description = "Brief summary of the global discipline.";
      };
      kiro = mkOption {
        type = types.lines;
        default = "";
        description = "Discipline content for Kiro, written as a delta complementing Kiro's built-in defaults. Empty to omit for Kiro.";
      };
      antigravity = mkOption {
        type = types.lines;
        default = "";
        description = "Discipline content for Antigravity, written as a delta complementing Antigravity's built-in defaults. Empty to omit for Antigravity.";
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

    disciplines = mkOption {
      type = types.attrsOf disciplineSubmodule;
      default = { };
      description = "Global always-on code-writing rules, consolidated per harness into a single sectioned steering/rules file. Each carries harness-specific content that complements that harness's built-in defaults.";
    };
  };
}
