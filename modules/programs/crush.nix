{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) concatStringsSep filterAttrs mapAttrs mapAttrsToList;

  mkSkill =
    name: skill:
    pkgs.runCommandLocal "crush-skill-${name}" { } ''
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

  crushModelFor =
    model:
    if model == "low" then
      "mimo-v2.6-flash-free"
    else if model == "flash" || model == "medium" then
      "muse-spark-1.3-contributor-free"
    else if model == "high" || model == "pro" || model == "xhigh" || model == "max" then
      "step-5-preview-free"
    else
      model;

  instructions = concatStringsSep "\n\n" (
    mapAttrsToList (name: agent: ''
      ## Agent: ${name}
      ${agent.description}
      Model: ${if agent.model != null then crushModelFor agent.model else "muse-spark-1.3-contributor-free"}

      ${agent.instructions}
    '') config.ai.agents
  );

  # Discipline lines the crush coder prompt already covers harder (<4 lines output,
  # no preamble/postamble, file:line refs): drop them here, keep the rest.
  droppedDisciplineRules = {
    complete = [
      "whole"
    ];
    hygiene = [
      "clean-hands"
    ];
    skills = [
      "load"
      "obey"
    ];
    unslop = [
      "concise"
      "no-restate"
      "dense"
    ];
  };

  renderDiscipline =
    name: discipline:
    let
      dropped = droppedDisciplineRules.${name} or [ ];
      kept = filterAttrs (rule: text: text != null && !(builtins.elem rule dropped)) discipline.rules;
    in
    ''
      ## ${name}
      ${discipline.description}

      ${concatStringsSep "\n\n" (mapAttrsToList (_: text: text) kept)}
    '';

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

      # Shared rules

      ${allRules}

      # Shared disciplines

      ${disciplines}
    '';
  };
}
