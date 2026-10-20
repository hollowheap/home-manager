{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mapAttrs mapAttrsToList optionals concatStringsSep;

  aiRender = config.ai.render;

  copilotToolsFor =
    agent:
    let
      caps = agent.capabilities;
    in
    (optionals caps.read [ "read" "search" ])
    ++ (optionals caps.write [ "edit" ])
    ++ (optionals caps.execute [ "execute" ])
    ++ (optionals caps.delegate [ "agent" ])
    ++ (optionals caps.web [ "web" ])
    ++ (optionals (builtins.elem "plan" agent.skills) [ "todo" ]);

  rulesText = aiRender.rulesText config.ai.rules;

  mkAgent =
    _name: agent:
    # TODO: Map agent.model and agent.effort to Copilot CLI configurations
    let
      frontmatter = lib.generators.toYAML { } (
        {
          inherit (agent) description;
          tools = copilotToolsFor agent;
        }
        // (lib.optionalAttrs (agent.model != null) { inherit (agent) model; })
      );
    in
    ''
      ---
      ${lib.removeSuffix "\n" frontmatter}
      ---

      ${agent.instructions}${rulesText agent}
    '';

  mkSkill =
    name: skill:
    ''
      ---
      name: ${name}
      description: ${skill.description}
      ---

      ${skill.content}
    '';

  # Copilot CLI built-ins are closed: no drops. Add rule names here once verified.
  droppedDisciplineRules = { };

  renderDiscipline = aiRender.renderDiscipline {
    dropped = droppedDisciplineRules;
    separator = "\n";
  };

  disciplineBlocks = mapAttrsToList renderDiscipline config.ai.disciplines;
in
{
  programs.github-copilot-cli = {
    enable = true;
    mutableSettings = true;
    enableMcpIntegration = true;

    agents = mapAttrs mkAgent config.ai.agents;
    skills = mapAttrs mkSkill config.ai.skills;
    context = concatStringsSep "\n" disciplineBlocks;
  };
}
