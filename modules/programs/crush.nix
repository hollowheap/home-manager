{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) concatStringsSep mapAttrs mapAttrsToList;

  aiRender = config.ai.render;

  mkSkill = aiRender.mkSkillDir { prefix = "crush"; };

  instructions = concatStringsSep "\n\n" (
    mapAttrsToList (name: agent: ''
      ## Agent: ${name}
      ${agent.description}

      ${agent.instructions}
    '') config.ai.agents
  );

  # Discipline lines the crush coder prompt covers. Add rule names here once verified.
  droppedDisciplineRules = { };

  renderDiscipline = aiRender.renderDiscipline {
    dropped = droppedDisciplineRules;
    heading = "##";
  };

  # Crush has no per-agent surface: render the union over all agents.
  allRules = concatStringsSep "\n\n" (map (rule: rule.text) config.ai.rules);

  disciplines = concatStringsSep "\n\n" (mapAttrsToList renderDiscipline config.ai.disciplines);
in
{
  programs.crush = {
    enable = true;
    settings = {
      default_provider = "zen";
      default_model = "muse-spark-1.3-contributor-free";
      reasoning_effort = aiRender.effortFor "crush" (config.ai.agents.engineer or { effort = "high"; });
      options.tui.active_theme = "wallust";
      providers = {
        zen = {
          type = "openai-compat";
          name = "OpenCode Zen";
          base_url = "https://opencode.ai/zen/v1";
          api_key = "$OPENCODE_API_KEY";
          models = [
            {
              id = "muse-spark-1.3-contributor-free";
              name = "Muse Spark Free";
            }
            {
              id = "mimo-v2.6-flash-free";
              name = "MiMo Free";
            }
            {
              id = "step-5-preview-free";
              name = "Step 5 Preview Free";
            }
          ];
        };
      };
    };
    skills = mapAttrs mkSkill config.ai.skills;
  };

  xdg.configFile."crush/AGENTS.md" = lib.mkIf config.programs.crush.enable {
    text = ''
      # Shared agent instructions

      ${instructions}

      # Shared disciplines

      ${disciplines}

      # Shared rules

      ${allRules}
    '';
  };

  programs.wallust.settings.templates.crush = {
    template = "crush.json";
    target = "${config.home.homeDirectory}/.config/crush/themes/wallust.json";
  };
}
