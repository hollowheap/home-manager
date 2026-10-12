{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) concatStringsSep filterAttrs mapAttrsToList;

  hollowHeapColorscript = pkgs.writeShellScriptBin "hollowheap-colorscript" ''
    initializeANSI()
    {
      esc=$(printf '\033')
      reset="''${esc}[0m"
      g1="''${esc}[38;2;94;129;172m"
      g2="''${esc}[38;2;106;131;172m"
      g3="''${esc}[38;2;118;133;172m"
      g4="''${esc}[38;2;131;135;172m"
      g5="''${esc}[38;2;143;136;172m"
      g6="''${esc}[38;2;155;138;173m"
      g7="''${esc}[38;2;168;140;173m"
      g8="''${esc}[38;2;180;142;173m"
    }

    initializeANSI

    cat << EOF
    ''${g1}       ▄▄▄  ▄▄▄       ▄▄ ▄▄                    ▄▄▄  ▄▄▄                         ''${reset}
    ''${g2}      █▀██  ██         ██ ██                  █▀██  ██                          ''${reset}
    ''${g3}        ██  ██         ██ ██                    ██  ██                          ''${reset}
    ''${g4}        ██████   ▄███▄ ██ ██ ▄███▄▀█▄ █▄ ██▀    ██████   ▄█▀█▄ ▄▀▀█▄ ████▄      ''${reset}
    ''${g5}        ██  ██   ██ ██ ██ ██ ██ ██ ██ ██▄██▄██     ██  ██   ██▄█▀ ▄█▀██ ██ ██   ''${reset}
    ''${g6}      ▀██▀  ▀██▄▄▀███▀▄██▄██▄▀███▀  ▀██▀██▀   ▀██▀  ▀██▄▄▀█▄▄▄▄▀█▄██▄████▀      ''${reset}
    ''${g7}                                                                     ██         ''${reset}
    ''${g8}                                                                     ▀          ''${reset}
    EOF
  '';

  # Pi built-in prompt is unverified for overlap: no drops. Add rule names here once verified.
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

  roster = concatStringsSep "\n" (
    mapAttrsToList (name: agent: "- ${name}: ${agent.description}") config.ai.agents
  );

  configDir = config.programs.pi-coding-agent.configDir;

  opencodeModelFor =
    model:
    if model == "low" then
      "mimo-v2.6-flash-free"
    else if model == "flash" || model == "medium" then
      "muse-spark-1.3-contributor-free"
    else if model == "high" || model == "pro" || model == "xhigh" || model == "max" then
      "step-5-preview-free"
    else
      model;

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

  agentFiles = mapAttrsToList (name: agent: {
    name = "${configDir}/agents/${name}.md";
    value.text = ''
      ---
      name: ${name}
      description: ${agent.description}
      model: ${opencodeModelFor (agent.model or "medium")}
      effort: ${agent.effort or "high"}
      mode: ${if agent.capabilities.write then "ask" else "plan"}
      ---

      ${agent.instructions}${rulesText agent}
    '';
  }) config.ai.agents;

  dashboardFile = [
    {
      name = "${configDir}/dashboard.json";
      value.text = builtins.toJSON {
        enabled = true;
        sections = [
          {
            type = "terminal";
            cmd = "${hollowHeapColorscript}/bin/hollowheap-colorscript";
            align = "center";
            height = 8;
            padding = 1;
          }
          {
            type = "startup";
            align = "center";
            padding = 1;
          }
        ];
      };
    }
  ];

  statuslineContent = builtins.toJSON {
    extensions = [
      "mode-guard"
      "budgets"
    ];
    options = {
      componentSeparator = " ";
      sectionSeparator = "  ";
      gitIntervalMs = 5000;
    };
    sections = {
      a = [
        {
          type = "mode-guard";
          accent = "bright-yellow";
          fg = "bright-yellow";
          icon = "󰘧";
          bold = true;
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
          accent = "bright-yellow";
          fg = "bright-yellow";
          icon = "󰄩";
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
    };
    context = ''
      # Available agents (full briefs in agents/*.md)

      ${roster}

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
