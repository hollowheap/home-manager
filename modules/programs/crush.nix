{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) concatStringsSep mapAttrs mapAttrsToList;

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

  instructions = concatStringsSep "\n\n" (
    mapAttrsToList (name: agent: ''
      ## Agent: ${name}
      ${agent.description}

      ${agent.instructions}
    '') config.ai.agents
  );

  disciplines = concatStringsSep "\n\n" (
    mapAttrsToList (name: discipline: ''
      ## ${name}
      ${discipline.description}

      ${discipline.content}
    '') config.ai.disciplines
  );
in
{
  programs.crush = {
    enable = true;
    settings = { };
    skills = mapAttrs mkSkill config.ai.skills;
  };

  home.file.".config/crush/AGENTS.md" = lib.mkIf config.programs.crush.enable {
    text = ''
      # Shared agent instructions

      ${instructions}

      # Shared disciplines

      ${disciplines}
    '';
  };
}
