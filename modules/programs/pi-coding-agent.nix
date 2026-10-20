{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) concatStringsSep mapAttrsToList;

  aiRender = config.ai.render;

  # Pi built-in prompt is unverified for overlap: no drops. Add rule names here once verified.
  droppedDisciplineRules = { };

  renderDiscipline = aiRender.renderDiscipline { dropped = droppedDisciplineRules; };

  disciplines = concatStringsSep "\n\n" (mapAttrsToList renderDiscipline config.ai.disciplines);

  roster = concatStringsSep "\n" (
    mapAttrsToList (name: agent: "- ${name}: ${agent.description}") config.ai.agents
  );

  configDir = config.programs.pi-coding-agent.configDir;

  rulesText = aiRender.rulesText config.ai.rules;

  agentFiles = mapAttrsToList (name: agent: {
    name = "${configDir}/agents/${name}.md";
    value.text = ''
      ---
      name: ${name}
      description: ${agent.description}
      model: ${aiRender.modelFor "pi" agent}
      effort: ${aiRender.effortFor "pi" agent}
      mode: ${if agent.capabilities.write then "ask" else "plan"}
      ---

      ${agent.instructions}${rulesText agent}
    '';
  }) config.ai.agents;

  dashboardFile = [
    {
      name = "${configDir}/dashboard.json";
      value.text = builtins.toJSON {
        width = 80;
        source = {
          command = "${pkgs.hollowpi-colorscript}/bin/hollowpi-colorscript";
          args = [ ];
        };
      };
    }
  ];

  statuslineContent = builtins.toJSON {
    extensions = [
      "mode-guard"
      "budgets"
    ];
    options = {
      componentSeparator = "";
      sectionSeparator = "  ";
      gitIntervalMs = 5000;
    };
    sections = {
      a = [
        {
          type = "text";
          text = "";
          fg = "bright-yellow";
        }
        {
          type = "text";
          text = "󰘧 ";
          fg = "black";
          bg = "bright-yellow";
          bold = true;
        }
        {
          type = "text";
          text = " ";
          fg = "black";
          bg = "bright-white";
          bold = true;
        }
        {
          type = "mode-guard";
          fg = "black";
          bg = "bright-white";
          bold = true;
        }
        {
          type = "text";
          text = " ";
          fg = "black";
          bg = "bright-white";
          bold = true;
        }
        {
          type = "text";
          text = "";
          fg = "bright-white";
        }
      ];
      b = [
        {
          type = "git_branch";
          accent = "bright-cyan";
          icon = "";
        }
      ];
      c = [
        {
          type = "git_diff";
          accent = "bright-yellow";
          icon = "󱈸";
          addedIcon = "+";
          modifiedIcon = "~";
          removedIcon = "-";
          untrackedIcon = "?";
        }
      ];
      d = [
        {
          type = "cwd";
          accent = "bright-blue";
          icon = "";
          depth = 3;
          homeAsTilde = true;
        }
      ];
      v = [
        {
          type = "budgets";
          fg = "bright-yellow";
          bold = true;
        }
      ];
      w = [
        {
          type = "model";
          accent = "bright-purple";
          icon = "󰚩";
          shorten = true;
        }
      ];
      x = [
        {
          type = "tokens";
          accent = "bright-blue";
          icon = "󰕲";
          showInput = true;
          showOutput = true;
        }
      ];
      y = [
        {
          type = "context";
          accent = "bright-green";
          icon = "󰍛";
        }
      ];
      z = [
        {
          type = "clock";
          accent = "bright-magenta";
          icon = "󱑂";
          format = "HH:mm";
        }
      ];
    };
  };

  statuslineFile = [
    {
      name = "${configDir}/statusline.json";
      value.text = statuslineContent;
    }
    {
      name = "${configDir}/pi-statusline.json";
      value.text = statuslineContent;
    }
  ];

  skills = builtins.concatLists (
    mapAttrsToList (
      name: skill:
      [
        {
          name = "${configDir}/skills/${name}/SKILL.md";
          value.text = ''
            ---
            name: ${name}
            description: ${skill.description}
            ---

            ${skill.content}
          '';
        }
      ]
      ++ mapAttrsToList (fileName: content: {
        name = "${configDir}/skills/${name}/references/${fileName}";
        value.text = content;
      }) skill.references
      ++ mapAttrsToList (fileName: content: {
        name = "${configDir}/skills/${name}/scripts/${fileName}";
        value = {
          text = content;
          executable = true;
        };
      }) skill.scripts
    ) config.ai.skills
  );
in
{
  programs.pi-coding-agent = {
    enable = true;
    models = {
      providers = {
        zen = {
          baseUrl = "https://opencode.ai/zen/v1";
          api = "openai-completions";
          apiKey = "opencode";
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
              reasoning = true;
            }
          ];
        };
      };
    };
    settings = {
      defaultProvider = "zen";
      defaultModel = "muse-spark-1.3-contributor-free";
      defaultThinkingLevel = aiRender.effortFor "pi" (config.ai.agents.engineer or { effort = "high"; });
    };
    context = ''
      # Available agents (full briefs in agents/*.md)

      ${roster}
    '';
    appendSystem = ''
      # Shared disciplines

      ${disciplines}
    '';
  };

  home.file = lib.mkIf config.programs.pi-coding-agent.enable (
    builtins.listToAttrs (
      skills ++ agentFiles ++ dashboardFile ++ statuslineFile
    )
  );
}
