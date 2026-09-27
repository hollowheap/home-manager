{ config, lib, ... }:
let
  inherit (lib) mkIf mapAttrsToList optionals;

  # Translate harness-neutral capabilities into Antigravity's tool vocabulary
  # and permission/command policies.
  agToolsFor =
    caps:
    (optionals caps.read [
      "view_file"
      "grep_search"
      "find_by_name"
    ])
    ++ (optionals caps.write [
      "replace_file_content"
      "write_to_file"
    ])
    ++ (optionals caps.execute [
      "run_command"
    ]);

  mkAgent =
    name: agent:
    let
      caps = agent.capabilities;
      yamlFrontmatter = lib.generators.toYAML { } {
        inherit name;
        inherit (agent)
          description
          mainAgent
          subagent
          skills
          ;
        permissionMode = if caps.write then "acceptEdits" else "default";
        commandExecutionPolicy = if caps.execute then "auto" else "deny";
        tools = agToolsFor caps;
      };
    in
    {
      name = ".gemini/config/agents/${name}/agent.md";
      value.text = ''
        ---
        ${yamlFrontmatter}
        ---

        # Instructions
        ${agent.instructions}
      '';
    };

  mkSkill = name: skill: {
    name = ".gemini/config/skills/${name}/SKILL.md";
    value.text = ''
      ---
      name: ${name}
      description: ${skill.description} Activate this skill when the user's task involves ${name}, or when the user enters a matching mode (e.g. /${name}).
      ---

      ${skill.content}
    '';
  };
in
{
  programs.antigravity-cli = {
    enable = true;
  };

  home.file = mkIf config.programs.antigravity-cli.enable (
    builtins.listToAttrs (
      (mapAttrsToList mkAgent config.ai.agents) ++ (mapAttrsToList mkSkill config.ai.skills)
    )
  );
}
