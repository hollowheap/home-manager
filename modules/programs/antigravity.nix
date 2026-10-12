{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf filterAttrs mapAttrs mapAttrsToList optionals;

  agToolsFor =
    agent:
    let
      caps = agent.capabilities;
    in
    (optionals caps.read [
      "view_file"
    ])
    ++ (optionals caps.write [
      "replace_file_content"
      "write_to_file"
    ])
    ++ (optionals caps.execute [
      "run_command"
    ])
    ++ (optionals caps.delegate [
      "invoke_subagent"
      "define_subagent"
      "manage_subagents"
      "send_message"
    ])
    ++ (optionals caps.web [
      "search_web"
      "read_url_content"
    ])
    ++ (optionals (caps.execute || caps.delegate) [
      "manage_task"
    ])
    ++ (optionals (builtins.elem "question" agent.skills) [
      "ask_question"
    ]);

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
    lib.optionalString (kept != [ ]) ("\n\n" + lib.concatStringsSep "\n\n" (map (rule: rule.text) kept));

  mkAgent =
    name: agent:
    let
      caps = agent.capabilities;
      yamlFrontmatter = lib.generators.toYAML { } (
        {
          inherit name;
          inherit (agent)
            description
            mainAgent
            subagent
            skills
            ;
          model = "flash";
          tools = agToolsFor agent;
        }
        // lib.optionalAttrs caps.execute { commandExecutionPolicy = "auto"; }
        // lib.optionalAttrs (caps.delegate && agent.availableAgents != [ ]) {
          agents = agent.availableAgents;
        }
      );
    in
    {
      name = ".gemini/config/agents/${name}/agent.md";
      value.text = ''
        ---
        ${yamlFrontmatter}
        ---

        # Instructions
        ${agent.instructions}${rulesText agent}
      '';
    };

  mkSkillDir =
    name: skill:
    let
      refCmds = mapAttrsToList (
        fileName: content: ''
          mkdir -p "$out/references"
          cp ${pkgs.writeText "${name}-ref-${fileName}" content} "$out/references/${fileName}"
        ''
      ) skill.references;
      scriptCmds = mapAttrsToList (
        fileName: content: ''
          mkdir -p "$out/scripts"
          install -m0755 ${pkgs.writeText "${name}-script-${fileName}" content} "$out/scripts/${fileName}"
        ''
      ) skill.scripts;
    in
    pkgs.runCommandLocal "antigravity-skill-${name}" { } (
      ''
        mkdir -p "$out"
        cp ${
          pkgs.writeText "${name}-SKILL.md" ''
            ---
            name: ${name}
            description: ${skill.description} Activate this skill when the user's task involves ${name}, or when the user enters a matching mode (e.g. /${name}).
            ---

            ${skill.content}
          ''
        } "$out/SKILL.md"
      ''
      + lib.concatStringsSep "\n" (refCmds ++ scriptCmds)
    );

  # Antigravity built-ins are closed: no drops. Add rule names here once verified.
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

      ${lib.concatStringsSep "\n\n" (mapAttrsToList (_: text: text) kept)}
    '';

  mkRule =
    name: d: {
      name = ".gemini/config/rules/${name}.md";
      value.text = renderDiscipline name d;
    };
in
{
  programs.antigravity-cli = {
    enable = true;
    skills = mapAttrs mkSkillDir config.ai.skills;
  };

  home.file = mkIf config.programs.antigravity-cli.enable (
    builtins.listToAttrs (
      (mapAttrsToList mkAgent config.ai.agents)
      ++ (mapAttrsToList mkRule config.ai.disciplines)
    )
  );
}
