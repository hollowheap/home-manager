{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf filterAttrs mapAttrs mapAttrsToList optionals concatStringsSep;

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

  rulesText =
    agent:
    let
      matches =
        rule:
        lib.all (cap: !rule.requires.${cap} || agent.capabilities.${cap}) [
          "read"
          "write"
          "execute"
          "delegate"
          "mcp"
          "web"
        ];
      kept = lib.filter matches config.ai.rules;
    in
    lib.optionalString (kept != [ ]) ("\n\n" + concatStringsSep "\n\n" (map (rule: rule.text) kept));

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

  renderDiscipline =
    name: d:
    let
      dropped = droppedDisciplineRules.${name} or [ ];
      kept = filterAttrs (rule: text: text != null && !(builtins.elem rule dropped)) d.rules;
    in
    ''
      # ${name}
      ${d.description}

      ${concatStringsSep "\n" (mapAttrsToList (_: text: text) kept)}
    '';

  disciplineBlocks = mapAttrsToList renderDiscipline config.ai.disciplines;
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
