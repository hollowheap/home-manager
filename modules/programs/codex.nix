{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) concatStringsSep filterAttrs mapAttrs mapAttrsToList mkIf;

  # Codex base prompt unverified for overlap: no drops. Add rule names here once verified.
  droppedDisciplineRules = { };

  renderDiscipline =
    name: discipline:
    let
      dropped = droppedDisciplineRules.${name} or [ ];
      kept = filterAttrs (rule: text: text != null && !(builtins.elem rule dropped)) discipline.rules;
    in
    ''
      # ${name}
      ${discipline.description}

      ${concatStringsSep "\n\n" (mapAttrsToList (_: text: text) kept)}
    '';

  disciplines = concatStringsSep "\n\n" (mapAttrsToList renderDiscipline config.ai.disciplines);

  agents = concatStringsSep "\n\n" (
    mapAttrsToList (name: agent: ''
      ## Agent: ${name}
      ${agent.description}

      ${agent.instructions}
    '') config.ai.agents
  );

  mkSkillDir =
    name: skill:
    pkgs.runCommandLocal "codex-skill-${name}" { } ''
      mkdir -p "$out/references" "$out/scripts"
      cp ${
        pkgs.writeText "${name}-SKILL.md" ''
          ---
          name: ${name}
          description: ${skill.description}
          ---

          ${skill.content}
        ''
      } "$out/SKILL.md"
      ${concatStringsSep "\n" (mapAttrsToList (fileName: content: ''
        cp ${pkgs.writeText "${name}-reference-${fileName}" content} "$out/references/${fileName}"
      '') skill.references)}
      ${concatStringsSep "\n" (mapAttrsToList (fileName: content: ''
        install -m0755 ${pkgs.writeText "${name}-script-${fileName}" content} "$out/scripts/${fileName}"
      '') skill.scripts)}
    '';

  # Codex reasoning effort tiers. Model itself is omitted: agents inherit the session model.
  codexEffortFor =
    effort:
    if effort == "low" || effort == "xlow" then
      "low"
    else if effort == "medium" then
      "medium"
    else if effort == "high" then
      "high"
    else
      "xhigh";

  tomlFormat = pkgs.formats.toml { };

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

  mkAgentFile =
    name: agent: {
      name = ".codex/agents/${name}.toml";
      value.source = tomlFormat.generate "${name}.toml" (
        {
          inherit name;
          inherit (agent) description;
          developer_instructions = agent.instructions + rulesText agent;
        }
        // lib.optionalAttrs (agent.effort != null) {
          model_reasoning_effort = codexEffortFor agent.effort;
        }
      );
    };
in
{
  programs.codex = {
    enable = true;
    package = pkgs.codex;
    context = ''
      # Shared agents

      ${agents}

      # Shared disciplines

      ${disciplines}
    '';
    skills = mapAttrs mkSkillDir config.ai.skills;
  };

  home.file = mkIf config.programs.codex.enable (
    builtins.listToAttrs (mapAttrsToList mkAgentFile config.ai.agents)
  );
}
