{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) concatStringsSep mapAttrs mapAttrsToList mkIf;

  aiRender = config.ai.render;

  # Codex base prompt unverified for overlap: no drops. Add rule names here once verified.
  droppedDisciplineRules = { };

  renderDiscipline = aiRender.renderDiscipline { dropped = droppedDisciplineRules; };

  disciplines = concatStringsSep "\n\n" (mapAttrsToList renderDiscipline config.ai.disciplines);

  mkSkillDir = aiRender.mkSkillDir { prefix = "codex"; };

  tomlFormat = pkgs.formats.toml { };

  rulesText = aiRender.rulesText config.ai.rules;

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
          model_reasoning_effort = aiRender.effortFor "codex" agent;
        }
      );
    };
in
{
  programs.codex = {
    enable = true;
    package = pkgs.codex;
    context = ''
      # Shared disciplines

      ${disciplines}
    '';
    skills = mapAttrs mkSkillDir config.ai.skills;
    mutableSettings = true;
    settings = {
      tui.screen_reader_detection_done = true;
      projects."${config.home.homeDirectory}/repos/home-manager".trust_level = "trusted";
    };
  };

  home.file = mkIf config.programs.codex.enable (
    builtins.listToAttrs (mapAttrsToList mkAgentFile config.ai.agents)
  );
}
