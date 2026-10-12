{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mapAttrs mapAttrsToList optionals concatStringsSep;

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
    ++ (optionals (builtins.elem "planning" agent.skills) [ "todo" ]);

  mkAgent =
    _name: agent:
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

      ${agent.instructions}
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

  disciplineBlocks = mapAttrsToList (name: d: ''
    # ${name}
    ${d.description}

    ${d.content}
  '') config.ai.disciplines;
in
{
  programs.github-copilot-cli = {
    enable = true;
    enableMcpIntegration = true;

    agents = mapAttrs mkAgent config.ai.agents;
    skills = mapAttrs mkSkill config.ai.skills;
    context = concatStringsSep "\n" disciplineBlocks;
  };
}
