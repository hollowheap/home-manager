{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mapAttrs mapAttrsToList optionals;

  aiRender = config.ai.render;

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
    ++ (optionals (builtins.elem "grill" agent.skills || builtins.elem "question" agent.skills) [
      "ask_question"
    ]);

  rulesText = aiRender.rulesText config.ai.rules;

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
      name = ".gemini/antigravity-cli/agents/${name}/agent.md";
      value.text = ''
        ---
        ${yamlFrontmatter}
        ---

        # Instructions
        ${agent.instructions}${rulesText agent}
      '';
    };

  mkSkillDir = aiRender.mkSkillDir {
    prefix = "antigravity";
    descriptionSuffix =
      name:
      " Activate this skill when the user's task involves ${name}, or when the user enters a matching mode (e.g. /${name}).";
  };

  # Antigravity built-ins are closed: no drops. Add rule names here once verified.
  droppedDisciplineRules = { };

  renderDiscipline = aiRender.renderDiscipline { dropped = droppedDisciplineRules; };

  mkRule =
    name: d: {
      name = ".gemini/config/rules/${name}.md";
      value.text = ''
        ---
        trigger: always_on
        description: "${d.description}"
        ---
        ${renderDiscipline name d}'';
    };
in
{
  programs.antigravity-cli = {
    enable = true;
    mutableSettings = true;
    settings = {
      allowNonWorkspaceAccess = true;
      editorMode = "vim";
      model = "Gemini 3.8 Flash (High)";
      notifications = true;
      pickerGrouping = "grouped";
      runningLightSpeed = "fast";
      showFeedbackSurvey = false;
      showTips = false;
      statusLine = {
        type = "command";
        command = "${config.home.homeDirectory}/.gemini/antigravity-cli/bin/agy-statusline";
        enabled = true;
      };
      toolPermission = "always-proceed";
      trustedWorkspaces = [
        "${config.home.homeDirectory}/repos/home-manager"
        "${config.home.homeDirectory}/repos/nixos-config"
        "${config.home.homeDirectory}/repos"
        "${config.home.homeDirectory}/repos/md-questioner"
        "${config.home.homeDirectory}/repos/inf2001-scratch"
        "${config.home.homeDirectory}/repos/my-pi-agent"
        "${config.home.homeDirectory}/repos/pico-car"
      ];
      vimInsertFirst = true;
    };
    skills = mapAttrs mkSkillDir config.ai.skills;
  };

  home.file = mkIf config.programs.antigravity-cli.enable (
    builtins.listToAttrs (
      (mapAttrsToList mkAgent config.ai.agents)
      ++ (mapAttrsToList mkRule config.ai.disciplines)
    )
    // {
      ".gemini/antigravity-cli/bin/agy-statusline".source = "${pkgs.agy-statusline}/bin/agy-statusline";
    }
  );
}
