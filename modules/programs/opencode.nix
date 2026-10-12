{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) concatStringsSep mapAttrs mapAttrsToList optionalAttrs;

  toolsFor =
    agent:
    let
      caps = agent.capabilities;
    in
    {
      read = caps.read;
      write = caps.write;
      execute = caps.execute;
      delegate = caps.delegate;
      web = caps.web;
    };

  mkSkill =
    name: skill:
    pkgs.runCommandLocal "opencode-skill-${name}" { } ''
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

  context = concatStringsSep "\n\n" (
    mapAttrsToList (name: discipline: ''
      # ${name}
      ${discipline.description}

      ${discipline.content}
    '') config.ai.disciplines
  );
in
{
  programs.opencode = {
    enable = true;
    agents = mapAttrs (
      _name: agent:
      {
        description = agent.description;
        mode = if agent.mainAgent then "primary" else "subagent";
        prompt = agent.instructions;
        tools = toolsFor agent;
      }
      // optionalAttrs (agent.model != null) { model = agent.model; }
    ) config.ai.agents;
    skills = mapAttrs mkSkill config.ai.skills;
    inherit context;
  };
}
