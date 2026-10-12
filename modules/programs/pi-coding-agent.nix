{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) concatStringsSep mapAttrsToList;
  pills = config.styles.pills;

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

  disciplines = concatStringsSep "\n\n" (
    mapAttrsToList (name: discipline: ''
      # ${name}
      ${discipline.description}

      ${discipline.content}
    '') config.ai.disciplines
  );

  agents = concatStringsSep "\n\n" (
    mapAttrsToList (name: agent: ''
      ## Agent: ${name}
      ${agent.description}

      ${agent.instructions}
    '') config.ai.agents
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

      ${agent.instructions}
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
            type = "terminal";
            cmd = "git --no-pager diff --stat -B -M -C";
            title = "Git Status";
            align = "left";
            height = 10;
            padding = 1;
          }
          {
            type = "keys";
            title = "Quick Commands";
            align = "center";
            items = [
              {
                key = "p";
                action = "/plan";
                desc = "Toggle plan write-scope mode";
              }
              {
                key = "a";
                action = "/approval";
                desc = "Toggle ask / auto approval";
              }
              {
                key = "r";
                action = "/plan-review";
                desc = "Review and approve plan";
              }
              {
                key = "c";
                action = "/cd";
                desc = "Change working directory";
              }
              {
                key = "s";
                action = "/statusline";
                desc = "Configure statusline style";
              }
            ];
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

  statuslineFile = [
    {
      name = "${configDir}/statusline.json";
      value.text = builtins.toJSON {
        enabled = true;
        style = "pill";
        separators = {
          section = {
            left = pills.symbols.left;
            right = pills.symbols.right;
          };
          component = {
            left = " ";
            right = " ";
          };
        };
        theme = {
          modes = {
            ask = {
              fg = "black";
              bg = "brightblue";
              bold = true;
            };
            auto = {
              fg = "black";
              bg = "brightgreen";
              bold = true;
            };
            plan = {
              fg = "black";
              bg = "brightyellow";
              bold = true;
            };
          };
          sections = {
            lualine_a = {
              fg = "black";
              bg = "brightblue";
              bold = true;
            };
            lualine_b = {
              fg = "black";
              bg = "brightcyan";
            };
            lualine_c = {
              fg = "brightwhite";
              bg = "default";
            };
            lualine_x = {
              fg = "brightwhite";
              bg = "default";
            };
            lualine_y = {
              fg = "brightwhite";
              bg = "default";
            };
            lualine_z = {
              fg = "black";
              bg = "brightblue";
            };
          };
        };
        sections = {
          lualine_a = [
            { provider = "mode"; }
          ];
          lualine_b = [
            {
              provider = "branch";
              icon = " ";
            }
          ];
          lualine_c = [
            {
              provider = "plan";
              icon = "󰏫 ";
              color = {
                fg = "black";
                bg = "brightmagenta";
                bold = true;
              };
            }
            {
              provider = "cwd";
              icon = " ";
            }
          ];
          lualine_x = [
            {
              provider = "model";
              icon = "󰚩 ";
            }
            {
              provider = "effort";
            }
          ];
          lualine_y = [
            {
              provider = "tokens";
            }
          ];
          lualine_z = [
            {
              provider = "status";
            }
          ];
        };
      };
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
      # Shared agents

      ${agents}

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
