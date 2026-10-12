{
  pkgs,
  lib,
  ...
}:
let
  inherit (lib.generators) mkLuaInline;
  modes = {
    nvo = [
      "n"
      "v"
      "o"
    ];

    nv = [
      "n"
      "v"
    ];
  };

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
    ''${g5}        ██  ██   ██ ██ ██ ██ ██ ██ ██▄██▄██     ██  ██   ██▄█▀ ▄█▀██ ██ ██      ''${reset}
    ''${g6}      ▀██▀  ▀██▄▄▀███▀▄██▄██▄▀███▀  ▀██▀██▀   ▀██▀  ▀██▄▄▀█▄▄▄▄▀█▄██▄████▀      ''${reset}
    ''${g7}                                                                     ██         ''${reset}
    ''${g8}                                                                     ▀          ''${reset}
    EOF
  '';
in
{
  programs = {
    neovim.enable = true;
    neovim.defaultEditor = true;

    nvf = {
      enable = true;

      settings.vim = {
        extraPackages = [
        ];
        lazy.plugins = with pkgs.vimPlugins; {
          "tiny-cmdline.nvim" = {
            keys = [
              {
                mode = modes.nvo;
              }
            ];
            lazy = true;
            package = tiny-cmdline-nvim;
          };
          "helpview.nvim" = {
            ft = [ "help" ];
            lazy = true;
            package = helpview-nvim;
          };
          "foldtext.nvim" = {
            keys = [
              {
                mode = modes.nvo;
                key = "z";
              }
            ];
            lazy = true;
            package = foldtext-nvim;
          };
          "mega.cmdparse" = {
            lazy = true;
            package = mega-cmdparse;
          };
          "wallust.nvim" = {
            lazy = false;
            package = wallust;
          };
        };

        mini = {
          ai.enable = true;
          icons.enable = true;
          operators.enable = true;
          pairs.enable = true;
          surround.enable = true;
          splitjoin.enable = true;
        };

        languages = {
          enableDAP = true;
          enableExtraDiagnostics = true;
          enableFormat = true;
          enableTreesitter = true;

          clang.enable = true;
          nix.enable = true;
          python.enable = true;
          tsx.enable = true;
          typescript.enable = true;
          yaml.enable = true;
          zsh.enable = true;
          markdown.enable = true;
          markdown.extensions.markview-nvim.enable = true;
        };

        lsp = {
          enable = true;
          inlayHints.enable = true;
          lightbulb.enable = true;
          lspkind.enable = true;
          servers = {
            nil.nix.flake = {
              autoArchive = true;
              autoEvalInputs = true;
            };
          };
        };

        diagnostics = {
          config = {
            virtual_text = {
              prefix = "●";
              spacing = 4;
              source = "if_many";
            };
            signs = true;
            underline = true;
            update_in_insert = false;
            severity_sort = true;
          };
        };

        debugger = {
          nvim-dap.enable = true;
          nvim-dap.ui.enable = true;
        };

        assistant = {
          avante-nvim.enable = true;
          avante-nvim.setupOpts = {
            provider = "kiro";
            mode = "agentic";
            acp_providers = {
              kiro = {
                command = "${pkgs.kiro-cli}/bin/kiro-cli";
                args = [ "acp" ];
                env = { };
              };
            };
          };

          supermaven-nvim = {
            # enable = true;
            setupOpts = {
              disable_keymaps = true;
              disable_inline_completion = true;
            };
          };
        };

        autocomplete.blink-cmp = {
          enable = true;
          setupOpts = {
            sources = {
              default = [
                "lsp"
                "path"
                "snippets"
                "buffer"
                "avante"
                "supermaven"
              ];
              providers = {
                avante = {
                  module = "blink-cmp-avante";
                  name = "Avante";
                  opts = { };
                };
                supermaven = {
                  module = "blink-cmp-supermaven";
                  name = "supermaven";
                  score_offset = 100;
                  opts = { };
                };
              };
            };
            completion = {
              ghost_text.enabled = true;
              documentation = {
                auto_show = true;
                auto_show_delay_ms = 200;
              };
              menu = {
                auto_show = true;
              };
            };
          };
          mappings = {
            previous = "<S-Tab>";
            next = "<Tab>";
            confirm = "<CR>";
            complete = "<C-Space>";
            close = "<C-e>";
            scrollDocsUp = "<C-b>";
            scrollDocsDown = "<C-f>";
          };
          sourcePlugins = {
            blink-cmp-avante = {
              enable = true;
              module = "blink-cmp-avante";
              package = pkgs.vimPlugins.blink-cmp-avante;
            };
            blink-cmp-supermaven = {
              enable = true;
              module = "blink-cmp-supermaven";
              package = pkgs.vimPlugins.blink-cmp-supermaven;
            };
          };
        };

        git = {
          gitsigns.enable = true;
        };

        utility = {
          smart-splits.enable = true;
          grug-far-nvim.enable = true;
          snacks-nvim.enable = true;
          snacks-nvim.setupOpts = {
            dashboard = {
              enabled = true;
              width = 80;
              preset.keys = [
                {
                  icon = " ";
                  key = "f";
                  desc = "Find File";
                  action = ":lua Snacks.dashboard.pick('files')";
                }
                {
                  icon = " ";
                  key = "n";
                  desc = "New File";
                  action = ":ene | startinsert";
                }
                {
                  icon = " ";
                  key = "g";
                  desc = "Find Text";
                  action = ":lua Snacks.dashboard.pick('live_grep')";
                }
                {
                  icon = " ";
                  key = "r";
                  desc = "Recent Files";
                  action = ":lua Snacks.dashboard.pick('oldfiles')";
                }
                {
                  icon = " ";
                  key = "s";
                  desc = "Restore Session";
                  section = "session";
                }
                {
                  icon = " ";
                  key = "q";
                  desc = "Quit";
                  action = ":qa";
                }
              ];
              sections = [
                {
                  section = "terminal";
                  cmd = "${hollowHeapColorscript}/bin/hollowheap-colorscript";
                  align = "center";
                  height = 8;
                }
                {
                  icon = " ";
                  title = "Git Status";
                  ttl = 300;
                  indent = 2;
                  padding = 1;
                  section = "terminal";
                  enabled = mkLuaInline "Snacks.git.get_root() ~= nil";
                  cmd = "git --no-pager diff --stat -B -M -C";
                  height = 10;
                }
                {
                  section = "keys";
                  gap = 1;
                }
                # {
                #   section = "startup";
                # }
              ];
            };
            explorer = {
              enabled = true;
              replace_netrw = true;
              trash = true;
            };
            indent = {
              enabled = true;
            };
            input = {
              enabled = true;
            };
            picker = {
              enabled = true;
              ui_select = true;
            };
            statuscolumn = {
              enabled = true;
            };
            scroll = {
              enabled = true;
            };
            notify = {
              enabled = true;
            };
            profiler = {
              enabled = true;
            };
            words = {
              enabled = true;
            };
          };
        };

        binds = {
          whichKey = {
            enable = true;
            setupOpts = {
              preset = "helix";
              filter = mkLuaInline "function(mapping) return mapping.desc and mapping.desc ~= '' and mapping.desc ~= '<Nop>' and not mapping.hidden end";
            };
            register = {
              "p" = "Paste after";
              "P" = "Paste before";
              "u" = "Undo";
              "U" = "Redo";
              "gO" = "Document Outline";

              "d" = "+Delete";
              "y" = "+Yank";
              "z" = "+Fold";

              "s" = "+Surround";
              "g" = "+Go to";

              "<leader>" = "+Menu";

              "<leader>a" = "+Agent";
              "<leader>aa" = "Ask prompt";
              "<leader>ae" = "Edit selection";
              "<leader>at" = "Toggle sidebar";
              "<leader>af" = "Focus sidebar";
              "<leader>ar" = "Refresh repomap";
              "<leader>an" = "New chat session";
              "<leader>ah" = "Select history";
              "<leader>as" = "Toggle suggestion";

              "<leader>l" = "+LSP";
              "<leader>lg" = "+Go to";
              "<leader>lt" = "+Toggle";
              "<leader>lw" = "+Workspace";

              "<leader>s" = "+Search";
              "<leader>sx" = "+Diagnostics";
              "<leader>d" = "+Debugger";
              "<leader>db" = "Toggle Breakpoint";
              "<leader>dc" = "Continue / Start";
              "<leader>di" = "Step Into";
              "<leader>do" = "Step Over";
              "<leader>dO" = "Step Out";
              "<leader>dt" = "Terminate Debugger";
              "<leader>dr" = "Restart Debugger";
              "<leader>du" = "Toggle DAP UI";
              "<leader>dp" = "Toggle Profiler";
              "<leader>q" = "+Quit";
            };
          };
          hardtime-nvim = {
            enable = true;
            setupOpts = {
              max_count = 2;
            };
          };
        };
        theme = {
          enable = true;
          base16-colors = {
            base00 = "#000000";
            base01 = "#1a1a1a";
            base02 = "#2e2e2e";
            base03 = "#555555";
            base04 = "#888888";
            base05 = "#e0e0e0";
            base06 = "#eeeeee";
            base07 = "#ffffff";
            base08 = "#ff5555";
            base09 = "#ffaa00";
            base0A = "#ffff55";
            base0B = "#55ff55";
            base0C = "#55ffff";
            base0D = "#5555ff";
            base0E = "#ff55ff";
            base0F = "#aa55ff";
          };
          name = "base16";
        };

        ui = {
          borders.enable = true;
          borders.plugins = {
            which-key.enable = true;
          };

          nvim-highlight-colors.enable = true;
          colorful-menu-nvim.enable = true;
          illuminate.enable = true;
          modes-nvim.enable = true;
        };

        statusline.lualine = {
          enable = true;
          setupOpts = {
            options = {
              disabled_filetypes = {
                statusline = [
                  "snacks_dashboard"
                  "snacks_picker_list"
                  "snacks_picker_input"
                  "dashboard"
                  "alpha"
                ];
              };
              section_separators = {
                left = "";
                right = "";
              };
              component_separators = {
                left = "";
                right = "";
              };
            };
            extensions = lib.mkForce [
              (mkLuaInline ''
                {
                  sections = {
                    lualine_a = {
                      function()
                        local colors = require("base16-colorscheme").colors
                        local ft = vim.bo.filetype
                        if ft == "AvanteInput" then
                          return _G.mk_pill("󰌌", "Input", colors.base0B, colors.base07, colors.base00, colors.base00, colors.base00)
                        elseif ft == "AvanteSelectedCode" then
                          return _G.mk_pill("", "Code", colors.base0A, colors.base07, colors.base00, colors.base00, colors.base00)
                        else
                          return _G.mk_pill("󰭹", "Chat", colors.base0D, colors.base07, colors.base00, colors.base00, colors.base00)
                        end
                      end
                    },
                    lualine_b = {},
                    lualine_c = {},
                    lualine_x = {},
                    lualine_y = {},
                    lualine_z = {}
                  },
                  inactive_sections = {
                    lualine_a = {
                      function()
                        local colors = require("base16-colorscheme").colors
                        local ft = vim.bo.filetype
                        if ft == "AvanteInput" then
                          return _G.mk_pill("󰌌", "Input", colors.base03, colors.base01, colors.base04, colors.base04, colors.base00)
                        elseif ft == "AvanteSelectedCode" then
                          return _G.mk_pill("", "Code", colors.base03, colors.base01, colors.base04, colors.base04, colors.base00)
                        else
                          return _G.mk_pill("󰭹", "Chat", colors.base03, colors.base01, colors.base04, colors.base04, colors.base00)
                        end
                      end
                    },
                    lualine_b = {},
                    lualine_c = {},
                    lualine_x = {},
                    lualine_y = {},
                    lualine_z = {}
                  },
                  filetypes = { "Avante", "AvanteInput", "AvanteSelectedCode", "AvanteSelectedFiles", "AvanteTodos" }
                }
              '')
            ];
            sections = {
              lualine_a = [
                (mkLuaInline ''
                  function()
                    local colors = require("base16-colorscheme").colors
                    local mode_map = {
                      ['n'] = { name = 'NORMAL', color = colors.base0D },
                      ['no'] = { name = 'O-PENDING', color = colors.base0D },
                      ['nov'] = { name = 'O-PENDING', color = colors.base0D },
                      ['noV'] = { name = 'O-PENDING', color = colors.base0D },
                      ['no\22'] = { name = 'O-PENDING', color = colors.base0D },
                      ['niI'] = { name = 'NORMAL', color = colors.base0D },
                      ['niR'] = { name = 'NORMAL', color = colors.base0D },
                      ['niV'] = { name = 'NORMAL', color = colors.base0D },
                      ['nt'] = { name = 'NORMAL', color = colors.base0D },
                      ['ntT'] = { name = 'NORMAL', color = colors.base0D },
                      ['v'] = { name = 'VISUAL', color = colors.base0E },
                      ['vs'] = { name = 'VISUAL', color = colors.base0E },
                      ['V'] = { name = 'V-LINE', color = colors.base0E },
                      ['Vs'] = { name = 'V-LINE', color = colors.base0E },
                      ['\22'] = { name = 'V-BLOCK', color = colors.base0E },
                      ['\22s'] = { name = 'V-BLOCK', color = colors.base0E },
                      ['s'] = { name = 'SELECT', color = colors.base0E },
                      ['S'] = { name = 'S-LINE', color = colors.base0E },
                      ['\19'] = { name = 'S-BLOCK', color = colors.base0E },
                      ['i'] = { name = 'INSERT', color = colors.base0B },
                      ['ic'] = { name = 'INSERT', color = colors.base0B },
                      ['ix'] = { name = 'INSERT', color = colors.base0B },
                      ['R'] = { name = 'REPLACE', color = colors.base08 },
                      ['Rc'] = { name = 'REPLACE', color = colors.base08 },
                      ['Rx'] = { name = 'REPLACE', color = colors.base08 },
                      ['Rv'] = { name = 'V-REPLACE', color = colors.base08 },
                      ['Rvc'] = { name = 'V-REPLACE', color = colors.base08 },
                      ['Rvx'] = { name = 'V-REPLACE', color = colors.base08 },
                      ['c'] = { name = 'COMMAND', color = colors.base0A },
                      ['cv'] = { name = 'EX', color = colors.base0A },
                      ['ce'] = { name = 'EX', color = colors.base0A },
                      ['r'] = { name = 'PROMPT', color = colors.base0C },
                      ['rm'] = { name = 'MORE', color = colors.base0C },
                      ['r?'] = { name = 'CONFIRM', color = colors.base0C },
                      ['!'] = { name = 'SHELL', color = colors.base08 },
                      ['t'] = { name = 'TERMINAL', color = colors.base0D },
                    }
                    local mode = vim.api.nvim_get_mode().mode
                    local info = mode_map[mode] or { name = mode, color = colors.base0D }
                    return _G.mk_pill("󰘧", info.name, info.color, colors.base07, colors.base00, colors.base00, colors.base00)
                  end
                '')
              ];
              lualine_b = [
                {
                  "@1" = mkLuaInline ''
                    function()
                      local fname = vim.fn.expand("%:t")
                      if fname == "" then fname = "[No Name]" end
                      local colors = require("base16-colorscheme").colors
                      local icon = "󰈚"
                      local ok, mini_icons = pcall(require, "mini.icons")
                      if ok then
                        local i = mini_icons.get("file", fname)
                        if i and i ~= "" then icon = i end
                      end
                      if vim.bo.modified then fname = fname .. " " end
                      if vim.bo.readonly then fname = fname .. " " end
                      return _G.mk_pill(icon, fname, colors.base0D, colors.base07, colors.base00, colors.base00, colors.base00)
                    end
                  '';
                  on_click = mkLuaInline ''
                    function()
                      Snacks.picker.buffers()
                    end
                  '';
                }
                {
                  "@1" = mkLuaInline ''
                    function()
                      local colors = require("base16-colorscheme").colors
                      local branch = vim.b.gitsigns_head or vim.g.loaded_fugitive and vim.fn.FugitiveHead() or ""
                      if branch == "" then
                        local ok, head = pcall(function() return vim.fn.system("git rev-parse --abbrev-ref HEAD 2>/dev/null"):gsub("\n", "") end)
                        if ok and head ~= "" and not head:find("fatal") then branch = head end
                      end
                      if branch == "" then return "" end
                      return _G.mk_pill("", branch, colors.base0E, colors.base07, colors.base00, colors.base00, colors.base00)
                    end
                  '';
                  on_click = mkLuaInline ''
                    function()
                      Snacks.picker.git_branches()
                    end
                  '';
                }
              ];
              lualine_c = [
                {
                  "@1" = "diff";
                  colored = false;
                  symbols = {
                    added = "+ ";
                    modified = "~ ";
                    removed = "- ";
                  };
                }
                [ "diagnostics" ]
              ];
              lualine_x = [
                (mkLuaInline ''
                  function()
                    if vim.v.hlsearch == 0 then return "" end
                    local colors = require("base16-colorscheme").colors
                    local s = vim.fn.searchcount({ recompute = 1, maxcount = 999 })
                    if not s or s.total == 0 then return "" end
                    return _G.mk_pill("", string.format("%d/%d", s.current, s.total), colors.base0A, colors.base07, colors.base00, colors.base00, colors.base00)
                  end
                '')
              ];
              lualine_y = [ ];
              lualine_z = [
                (mkLuaInline ''
                  function()
                    local ft = vim.bo.filetype
                    if ft == "" then return "" end
                    local colors = require("base16-colorscheme").colors
                    local icon = "󰈚"
                    local ok, mini_icons = pcall(require, "mini.icons")
                    if ok then
                      local i = mini_icons.get("filetype", ft)
                      if i and i ~= "" then icon = i end
                    end
                    return _G.mk_pill(icon, ft, colors.base0C, colors.base07, colors.base00, colors.base00, colors.base00)
                  end
                '')
              ];
            };
            inactive_sections = {
              lualine_a = [ ];
              lualine_b = [
                {
                  "@1" = mkLuaInline ''
                    function()
                      local fname = vim.fn.expand("%:t")
                      if fname == "" then fname = "[No Name]" end
                      local colors = require("base16-colorscheme").colors
                      local icon = "󰈚"
                      local ok, mini_icons = pcall(require, "mini.icons")
                      if ok then
                        local i = mini_icons.get("file", fname)
                        if i and i ~= "" then icon = i end
                      end
                      if vim.bo.modified then fname = fname .. " " end
                      if vim.bo.readonly then fname = fname .. " " end
                      return _G.mk_pill(icon, fname, colors.base03, colors.base01, colors.base04, colors.base04, colors.base00)
                    end
                  '';
                  on_click = mkLuaInline ''
                    function()
                      Snacks.picker.buffers()
                    end
                  '';
                }
              ];
              lualine_c = [ ];
              lualine_x = [ ];
              lualine_y = [ ];
              lualine_z = [ ];
            };
          };
        };

        visuals = {
          fidget-nvim.enable = true;
          fidget-nvim.setupOpts.notification.override_vim_notify = true;
        };

        keymaps =
          (map
            (key: {
              inherit key;
              mode = modes.nvo;
              action = "<Nop>";
            })
            # Disable unintuitive defaults first
            [
              "<C-r>"
              "<C-e>"
              "<C-y>"
              "ge"
              "gE"
              "gg"
              "G"
            ]
          )
          ++ [
            {
              key = "x";
              mode = modes.nv;
              action = "\"_x";
              desc = "Delete without yank";
            }
            {
              key = "X";
              mode = modes.nv;
              action = "\"_X";
              desc = "Delete without yank (backwards)";
            }
            # Better defaults (very opionated)
            {
              key = "U";
              mode = "n";
              action = "<C-r>";
              desc = "Redo";
            }

            {
              key = "r";
              mode = modes.nvo;
              action = "ge";
              desc = "Prev end of word";
            }
            {
              key = "R";
              mode = modes.nvo;
              action = "gE";
              desc = "Prev end of WORD";
            }
            {
              key = "H";
              mode = modes.nv;
              action = "^";
              desc = "Beginning of line";
            }
            {
              key = "L";
              mode = modes.nvo;
              action = "$";
              desc = "End of line";
            }
            {
              key = "J";
              mode = modes.nvo;
              action = "<C-d>zz";
              desc = "Scroll view down";
            }
            {
              key = "K";
              mode = modes.nvo;
              action = "<C-u>zz";
              desc = "Scroll view up";
            }
            {
              key = "gj";
              mode = modes.nvo;
              action = "Gzz";
              desc = "Bottom of file";
            }
            {
              key = "gk";
              mode = modes.nvo;
              action = "ggzz";
              desc = "Top of file";
            }
            {
              key = "<leader>y";
              mode = modes.nvo;
              action = "\"+y";
              desc = "Yank to clipboard";
            }
            {
              key = "<leader>p";
              mode = modes.nvo;
              action = "\"+p";
              desc = "Paste after from clipboard";
            }
            {
              key = "<leader>P";
              mode = modes.nvo;
              action = "\"+P";
              desc = "Paste before from clipboard";
            }

            # Quality of life
            {
              key = "<leader>j";
              mode = "n";
              lua = true;
              action = "function() MiniSplitJoin.toggle() end";
              desc = "Split or join lines";
            }
            {
              key = "<leader>qw";
              mode = modes.nv;
              action = "<cmd>wqa<cr>";
              desc = "Quit and save";
            }
            {
              key = "<leader>qq";
              mode = modes.nvo;
              action = "<cmd>qa!<cr>";
              desc = "Quit without saving";
            }

            # Core Pickers
            {
              key = "<leader>e";
              lua = true;
              action = "function() Snacks.explorer() end";
              mode = modes.nv;
              desc = "Explorer";
            }
            {
              key = "<leader>f";
              lua = true;
              action = "function() Snacks.picker.files() end";
              mode = modes.nv;
              desc = "Find Files";
            }
            {
              key = "<leader>sf";
              lua = true;
              action = "function() Snacks.picker.files() end";
              mode = modes.nv;
              desc = "Find Files";
            }
            {
              key = "<leader>sg";
              lua = true;
              action = "function() Snacks.picker.grep() end";
              mode = modes.nv;
              desc = "Live Grep";
            }
            {
              key = "<leader>sb";
              lua = true;
              action = "function() Snacks.picker.buffers() end";
              mode = modes.nv;
              desc = "Buffers";
            }
            {
              key = "<leader>sn";
              lua = true;
              action = "function() Snacks.picker.noice() end";
              mode = modes.nv;
              desc = "Noice";
            }

            # LSP Menus
            {
              key = "<leader>sd";
              lua = true;
              action = "function() Snacks.picker.diagnostics_buffer() end";
              mode = modes.nv;
              desc = "Diagnostics (buffer) [snacks]";
            }
            {
              key = "<leader>sD";
              lua = true;
              action = "function() Snacks.picker.diagnostics() end";
              mode = modes.nv;
              desc = "Diagnostics (workspace) [snacks]";
            }
            {
              key = "<leader>lr";
              lua = true;
              action = "function() Snacks.picker.lsp_references() end";
              mode = modes.nv;
              desc = "LSP References [snacks]";
            }
            {
              key = "<leader>lS";
              lua = true;
              action = "function() Snacks.picker.lsp_symbols() end";
              mode = "n";
              desc = "List document symbols [snacks]";
            }
            {
              key = "<leader>sl";
              lua = true;
              action = "function() Snacks.picker.loclist() end";
              mode = "n";
              desc = "Location List [snacks]";
            }
            {
              key = "<leader>sq";
              lua = true;
              action = "function() Snacks.picker.qflist() end";
              mode = "n";
              desc = "Quickfix List [snacks]";
            }

            {
              key = "<C-h>";
              lua = true;
              action = "function() require('smart-splits').move_cursor_left() end";
              mode = modes.nvo;
              desc = "Focus Left Window/Pane";
            }
            {
              key = "<C-j>";
              lua = true;
              action = "function() require('smart-splits').move_cursor_down() end";
              mode = modes.nvo;
              desc = "Focus Below Window/Pane";
            }
            {
              key = "<C-k>";
              lua = true;
              action = "function() require('smart-splits').move_cursor_up() end";
              mode = modes.nvo;
              desc = "Focus Above Window/Pane";
            }
            {
              key = "<C-l>";
              lua = true;
              action = "function() require('smart-splits').move_cursor_right() end";
              mode = modes.nvo;
              desc = "Focus Right Window/Pane";
            }

            # Smart-Splits Ctrl-Key Resizing
            {
              key = "<M-h>";
              lua = true;
              action = "function() require('smart-splits').resize_left() end";
              mode = "n";
              desc = "Resize Window Left";
            }
            {
              key = "<M-j>";
              lua = true;
              action = "function() require('smart-splits').resize_down() end";
              mode = "n";
              desc = "Resize Window Down";
            }
            {
              key = "<M-k>";
              lua = true;
              action = "function() require('smart-splits').resize_up() end";
              mode = "n";
              desc = "Resize Window Up";
            }
            {
              key = "<M-l>";
              lua = true;
              action = "function() require('smart-splits').resize_right() end";
              mode = "n";
              desc = "Resize Window Right";
            }

            # DAP Debugger Keymaps
            {
              key = "<leader>db";
              lua = true;
              action = "function() require('dap').toggle_breakpoint() end";
              mode = "n";
              desc = "Toggle Breakpoint";
            }
            {
              key = "<leader>dc";
              lua = true;
              action = "function() require('dap').continue() end";
              mode = "n";
              desc = "Continue / Start";
            }
            {
              key = "<leader>di";
              lua = true;
              action = "function() require('dap').step_into() end";
              mode = "n";
              desc = "Step Into";
            }
            {
              key = "<leader>do";
              lua = true;
              action = "function() require('dap').step_over() end";
              mode = "n";
              desc = "Step Over";
            }
            {
              key = "<leader>dO";
              lua = true;
              action = "function() require('dap').step_out() end";
              mode = "n";
              desc = "Step Out";
            }
            {
              key = "<leader>dt";
              lua = true;
              action = "function() require('dap').terminate() end";
              mode = "n";
              desc = "Terminate Debugger";
            }
            {
              key = "<leader>dr";
              lua = true;
              action = "function() require('dap').restart() end";
              mode = "n";
              desc = "Restart Debugger";
            }
            {
              key = "<leader>du";
              lua = true;
              action = "function() require('dapui').toggle() end";
              mode = "n";
              desc = "Toggle DAP UI";
            }
            {
              key = "<leader>dp";
              lua = true;
              action = "function() Snacks.profiler.toggle() end";
              mode = "n";
              desc = "Toggle Profiler";
            }

          ];

        lineNumberMode = "relNumber";
        syntaxHighlighting = true;

        globals = {
          mapleader = " ";
          maplocalleader = "\\\\";
        };

        options = {
          compatible = false;

          breakindent = true;
          cursorline = true;
          linebreak = true;
          number = true;
          splitbelow = true;
          splitright = true;

          ruler = true;
          showmode = false;
          showcmd = true;
          wrap = true;

          fillchars = "eob: ";

          incsearch = true;

          ignorecase = true;
          infercase = true;
          smartcase = true;

          smartindent = true;

          completeopt = "menuone,noinsert,popup";
          virtualedit = "block";
          formatoptions = "qjl1";

          tabstop = 2;
          softtabstop = 2;
          expandtab = true;

          shiftwidth = 2;
          shiftround = true;

          copyindent = true;

          showmatch = true;

          scrolloff = 4;

          cmdheight = 1;

          conceallevel = 2;

          listchars = "tab:> ,nbsp:␣,space:·,trail:.,precedes:…,extends:…";
          list = true;

          display = "lastline,truncate";

          pumheight = 10;
        };
        autocmds = [
          {
            event = [ "VimEnter" ];
            once = true;
            callback = mkLuaInline ''
              function()
                _G.lazy_startup_time = vim.uv.now()
              end
            '';
          }
        ];
        luaConfigRC = {
          startupTime = ''
                        package.preload["lazy.stats"] = function()
                          return {
                            stats = function()
                              return {
                                startuptime = _G.lazy_startup_time or vim.uv.now() / 1e12,
                                count = #vim.fn.globpath(vim.o.packpath, "pack/*/*/*", 0, 1),
                                loaded = #vim.fn.globpath(vim.o.packpath, "pack/*/start/*", 0, 1)
                              }
                            end
                          }
                        end

                        package.path = package.path .. ";" .. vim.fn.expand("~/.config/nvf/lua/?.lua")
                        local ok, wallust = pcall(require, "wallust")
                        if ok then
                          wallust.setup()
                        end

                        _G.mk_pill = function(icon, content, accent, content_bg, content_fg, icon_fg, bar_bg)
                          if not content or content == "" then return "" end
                          accent = accent or "#7677aa"
                          content_bg = content_bg or "#ffffff"
                          content_fg = content_fg or "#000000"
                          icon_fg = icon_fg or "#000000"
                          bar_bg = bar_bg or "#000000"

                          local hl_id = "Pill_" .. (accent:gsub("#", "")) .. "_" .. (content_bg:gsub("#", "")) .. "_" .. (content_fg:gsub("#", "")) .. "_" .. (icon_fg:gsub("#", ""))
                          vim.api.nvim_set_hl(0, hl_id .. "_Left",  { fg = accent, bg = bar_bg })
                          vim.api.nvim_set_hl(0, hl_id .. "_Icon",  { fg = icon_fg, bg = accent })
                          vim.api.nvim_set_hl(0, hl_id .. "_Body",  { fg = content_fg, bg = content_bg })
                          vim.api.nvim_set_hl(0, hl_id .. "_Right", { fg = content_bg, bg = bar_bg })

                          return string.format("%%#%s_Left#%%#%s_Icon#%s %%#%s_Body# %s %%#%s_Right#",
                            hl_id, hl_id, icon, hl_id, content, hl_id)
                        end

                        _G.update_lualine_theme = function()
                          local colors = require("base16-colorscheme").colors
                          local lualine_theme = {
                            normal = {
                              a = { fg = colors.base07, bg = colors.base00 },
                              b = { fg = colors.base07, bg = colors.base00 },
                              c = { fg = colors.base05, bg = colors.base00 },

                              x = { fg = colors.base07, bg = colors.base00 },
                              y = { fg = colors.base07, bg = colors.base00 },
                              z = { fg = colors.base07, bg = colors.base00 },
                            },
                            insert = { a = { fg = colors.base07, bg = colors.base00 } },
                            visual = { a = { fg = colors.base07, bg = colors.base00 } },
                            replace = { a = { fg = colors.base07, bg = colors.base00 } },
                            command = { a = { fg = colors.base07, bg = colors.base00 } },

                            inactive = {
                              a = { fg = colors.base07, bg = colors.base00 },
                              b = { fg = colors.base07, bg = colors.base00 },
                              c = { fg = colors.base07, bg = colors.base00 },

                              x = { fg = colors.base07, bg = colors.base00 },
                              y = { fg = colors.base07, bg = colors.base00 },
                              z = { fg = colors.base07, bg = colors.base00 },
                            },
                          }
                          local ok_l, lualine = pcall(require, "lualine")
                          if ok_l then
                            local cfg = lualine.get_config()
                            cfg.options = cfg.options or {}
                            cfg.options.theme = lualine_theme
                            cfg.options.section_separators = ""
                            cfg.options.component_separators = ""
                            lualine.setup(cfg)
                          end
                        end

                        _G.update_lualine_theme()
          '';
          which-key = ''
            local wk = require("which-key")
            wk.add({
              { "<C-r>", hidden = true },
              { "<C-e>", hidden = true },
              { "<C-y>", hidden = true },
              { "ge",    hidden = true },
              { "gE",    hidden = true },
              { "gg",    hidden = true },
              { "G",     hidden = true },
            })
          '';
        };
      };
    };
  };
}
