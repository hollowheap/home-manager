{ lib, ... }:
let
  inherit (lib) mkOption types;
  inherit (lib.types) str bool lines submodule listOf attrsOf nullOr;

  agentSubmodule = submodule {
    options = {
      description = mkOption {
        type = str;
        description = "Brief summary of the agent's purpose and role.";
      };
      mainAgent = mkOption {
        type = bool;
        default = true;
        description = "Whether this agent can be used as a primary conversational agent.";
      };
      subagent = mkOption {
        type = bool;
        default = true;
        description = "Whether this agent can be spawned as a subagent.";
      };
      capabilities = mkOption {
        type = submodule {
          options = {
            read = mkOption {
              type = bool;
              default = true;
              description = "Whether the agent may read files, search, and inspect the workspace.";
            };
            write = mkOption {
              type = bool;
              default = false;
              description = "Whether the agent may create or modify files.";
            };
            execute = mkOption {
              type = bool;
              default = false;
              description = "Whether the agent may run shell commands.";
            };
            delegate = mkOption {
              type = bool;
              default = false;
              description = "Whether the agent may spawn and delegate to sub-agents.";
            };
            mcp = mkOption {
              type = bool;
              default = false;
              description = "Whether the agent may use MCP server tools.";
            };
            web = mkOption {
              type = bool;
              default = false;
              description = "Whether the agent may fetch and search the web.";
            };
          };
        };
        default = { };
        description = "Harness-neutral capability boundary. Each harness renderer translates these into its own tool vocabulary and permission model.";
      };
      availableAgents = mkOption {
        type = listOf str;
        default = [ ];
        description = "Glob patterns of sub-agents this agent may spawn (requires capabilities.delegate). Empty means all agents are allowed.";
      };
      trustedAgents = mkOption {
        type = listOf str;
        default = [ ];
        description = "Sub-agents that run without permission prompts when spawned by this agent.";
      };
      skills = mkOption {
        type = listOf str;
        default = [ ];
        description = "List of skills associated with this agent.";
      };
      model = mkOption {
        type = nullOr str;
        default = null;
        description = "Harness-neutral model override. Each renderer maps this to its own model identifier; null uses the harness default.";
      };
      effort = mkOption {
        type = nullOr (types.enum [ "xlow" "low" "medium" "high" "xhigh" "max" ]);
        default = null;
        description = "Harness-neutral reasoning effort override (xlow, low, medium, high, xhigh, max). Harnesses map or ignore this based on their provider capabilities; null uses harness default.";
      };
      instructions = mkOption {
        type = lines;
        default = "";
        description = "System instructions and role guidelines for the agent.";
      };
    };
  };

  ruleSubmodule = submodule {
    options = {
      name = mkOption {
        type = str;
        description = "Stable rule identifier.";
      };
      requires = mkOption {
        type = submodule {
          options = {
            read = mkOption {
              type = bool;
              default = false;
              description = "Rule needs file reading and search.";
            };
            write = mkOption {
              type = bool;
              default = false;
              description = "Rule needs file creation and modification.";
            };
            execute = mkOption {
              type = bool;
              default = false;
              description = "Rule needs shell command execution.";
            };
            delegate = mkOption {
              type = bool;
              default = false;
              description = "Rule needs sub-agent delegation.";
            };
            mcp = mkOption {
              type = bool;
              default = false;
              description = "Rule needs MCP server tools.";
            };
            web = mkOption {
              type = bool;
              default = false;
              description = "Rule needs web fetch and search.";
            };
          };
        };
        default = { };
        description = "Capability intersection: renders only into agents holding every cap set true.";
      };
      text = mkOption {
        type = lines;
        description = "Rule body rendered into matching agents' instructions.";
      };
    };
  };

  skillSubmodule = submodule {
    options = {
      description = mkOption {
        type = str;
        description = "Brief summary of what this skill teaches the agent.";
      };
      content = mkOption {
        type = lines;
        description = "Markdown content and guidelines for this skill.";
      };
      references = mkOption {
        type = attrsOf lines;
        default = { };
        description = "Optional sub-documents and templates placed under references/.";
      };
      scripts = mkOption {
        type = attrsOf lines;
        default = { };
        description = "Optional executable scripts placed under scripts/.";
      };
    };
  };

  disciplineSubmodule = submodule {
    options = {
      description = mkOption {
        type = str;
        description = "Brief summary of the global discipline.";
      };
      rules = mkOption {
        type = attrsOf (nullOr lines);
        default = { };
        description = "Individually addressable rule lines. Null entries are dropped at render time; harness renderers may additionally drop rules their built-in prompts already cover.";
      };
    };
  };
in
{
  options.ai = {
    agents = mkOption {
      type = attrsOf agentSubmodule;
      default = { };
      description = "Shared agent definitions across AI coding tools.";
    };

    skills = mkOption {
      type = attrsOf skillSubmodule;
      default = { };
      description = "Shared skill definitions across AI coding tools.";
    };

    rules = mkOption {
      type = listOf ruleSubmodule;
      default = [ ];
      description = "Conditional rules rendered into an agent's instructions only when its capabilities cover the rule's required intersection.";
    };

    disciplines = mkOption {
      type = attrsOf disciplineSubmodule;
      default = { };
      description = "Global always-on code-writing rules, consolidated per harness into a single sectioned steering/rules file. Each carries harness-specific content that complements that harness's built-in defaults.";
    };
  };
}
