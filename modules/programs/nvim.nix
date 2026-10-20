{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib.generators) mkLuaInline;
  editorToolchains = import ../../toolchains.nix;
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
in
{
  programs = {
    neovim.enable = true;
    neovim.defaultEditor = true;

    nvf = {
      enable = true;

      settings.vim = {
        extraPackages = [
          pkgs.yamllint
          pkgs.trash-cli
        ];
        lazy.plugins = with pkgs.vimPlugins; {
          "tiny-cmdline.nvim" = {
            lazy = false;
            package = tiny-cmdline-nvim;
            setupModule = "tiny-cmdline";
            setupOpts = { };
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
          "tiny-glimmer.nvim" = {
            lazy = false;
            package = pkgs.vimPlugins.tiny-glimmer-nvim;
            setupModule = "tiny-glimmer";
            setupOpts = { };
          };
          "nvim-dap-virtual-text" = {
            lazy = false;
            package = pkgs.vimPlugins.nvim-dap-virtual-text;
            setupModule = "nvim-dap-virtual-text";
            setupOpts = { };
          };
        };

        mini = {
          ai.enable = true;
          bracketed.enable = true;
          comment.enable = true;
          comment.setupOpts.mappings = {
            comment = "<leader>c";
            comment_line = "<leader>cc";
            comment_visual = "<leader>c";
            textobject = "<leader>c";
          };
          hipatterns.enable = true;
          icons.enable = true;
          jump2d.enable = true;
          operators.enable = true;
          pairs.enable = true;
          surround.enable = true;
          splitjoin.enable = true;
          visits.enable = true;
        };

        languages = {
          enableDAP = true;
          enableExtraDiagnostics = true;
          enableFormat = true;
          enableTreesitter = true;

          clang.enable = true;
          clang.dap.enable = true;
          nix.enable = true;
          python.enable = true;
          python.dap.enable = true;
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
          nvim-lint = {
            enable = true;
            # Only filetypes the language modules don't cover; the rest
            # come from each language's extraDiagnostics.
            linters_by_ft = lib.genAttrs [ "yaml" "zsh" ] (
              ft: editorToolchains.linters.${ft}
            );
          };
        };

        debugger = {
          nvim-dap.enable = true;
          nvim-dap.ui.enable = true;
          nvim-dap.ui.autoStart = false;
        };

        assistant = {
          avante-nvim.enable = true;
          avante-nvim.setupOpts = {
            provider = "kiro";
            mode = "agentic";
            behaviour = {
              auto_suggestions = false;
            };
            acp_providers = {
              kiro = {
                command = "${pkgs.kiro-cli}/bin/kiro-cli";
                args = [ "acp" ];
                env = { };
              };
            };
          };

          supermaven-nvim = {
            enable = true;
            setupOpts = {
              disable_keymaps = true;
              disable_inline_completion = false;
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
              ghost_text.enabled = false;
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
          git-conflict.enable = true;
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
                  cmd = "${pkgs.hollowheap-colorscript}/bin/hollowheap-colorscript";
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
                {
                  section = "recent_files";
                  padding = 1;
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
              scope = {
                enabled = true;
              };
            };
            notifier = {
              enabled = true;
            };
            zen = {
              enabled = true;
            };
            dim = {
              enabled = true;
            };
            bigfile = {
              enabled = true;
            };
            quickfile = {
              enabled = true;
            };
            rename = {
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

              "d" = "+Delete";
              "y" = "+Yank";
              "z" = "+Fold";

              "s" = "+Surround";
              "g" = "+Go to";
              "r" = "+Replace";

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
          ui2.enable = true;
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
                          return _G.pills.left("󰌌", "Input", colors.base0B, colors.base00)
                        elseif ft == "AvanteSelectedCode" then
                          return _G.pills.left("", "Code", colors.base0A, colors.base00)
                        else
                          return _G.pills.left("󰭹", "Chat", colors.base0D, colors.base00)
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
                          return _G.pills.left("󰌌", "Input", colors.base03, colors.base00, colors.base01, colors.base04)
                        elseif ft == "AvanteSelectedCode" then
                          return _G.pills.left("", "Code", colors.base03, colors.base00, colors.base01, colors.base04)
                        else
                          return _G.pills.left("󰭹", "Chat", colors.base03, colors.base00, colors.base01, colors.base04)
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
              "quickfix"
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
                    return _G.pills.mode(info.name, info.color, colors.base00)
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
                      return _G.pills.left(icon, fname, colors.base0D, colors.base00)
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
                      return _G.pills.left("", branch, colors.base0E, colors.base00)
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
                    return _G.pills.right(string.format("%d/%d", s.current, s.total), "", colors.base0A, colors.base00)
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
                    return _G.pills.right(ft, icon, colors.base0C, colors.base00)
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
                      return _G.pills.left(icon, fname, colors.base03, colors.base00, colors.base01, colors.base04)
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
          fidget-nvim.setupOpts.notification.override_vim_notify = false;
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
              "grn"
              "gra"
              "grr"
              "gri"
              "grt"
              "gO"
              "gS"
              "gI"
              "*"
              "#"
              "g*"
              "g#"
              "gq"
              "gw"
              "gJ"
              "g~"
              "g~~"
              "gu"
              "guu"
              "gU"
              "gUU"
              "g?"
              "g??"
            ]
          )
          ++ (map
            (key: {
              inherit key;
              mode = "n";
              action = "<Nop>";
            })
            # Clears that exist in other modes (visual Q, visual gp/gP)
            [
              "Q"
              "gp"
              "gP"
            ]
          )
          ++ (map
            (key: {
              inherit key;
              mode = [
                "v"
                "o"
              ];
              action = "<Nop>";
            })
            # Duplicate text object aliases
            [
              "ib"
              "iB"
              "ab"
              "aB"
            ]
          )
          ++ [
            {
              key = "<C-w>";
              mode = "i";
              action = "<Nop>";
            }
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
              mode = modes.nv;
              action = "<Nop>";
            }
            {
              key = "rr";
              mode = modes.nv;
              action = "r";
              desc = "Replace character";
            }
            {
              key = "rR";
              mode = modes.nv;
              action = "R";
              desc = "Replace mode";
            }
            {
              key = "r~";
              mode = modes.nv;
              action = "g~";
              desc = "Toggle case";
            }
            {
              key = "r~~";
              mode = modes.nv;
              action = "g~~";
              desc = "Toggle case line";
            }
            {
              key = "ru";
              mode = modes.nv;
              action = "gu";
              desc = "Lowercase";
            }
            {
              key = "ruu";
              mode = modes.nv;
              action = "guu";
              desc = "Lowercase line";
            }
            {
              key = "rU";
              mode = modes.nv;
              action = "gU";
              desc = "Uppercase";
            }
            {
              key = "rUU";
              mode = modes.nv;
              action = "gUU";
              desc = "Uppercase line";
            }
            {
              key = "r?";
              mode = modes.nv;
              action = "g?";
              desc = "ROT13 encoding";
            }
            {
              key = "r??";
              mode = modes.nv;
              action = "g??";
              desc = "ROT13 line";
            }
            {
              key = "rw";
              mode = "n";
              action = "*";
              desc = "Search word forward";
            }
            {
              key = "rq";
              mode = "n";
              action = "#";
              desc = "Search word backward";
            }
            {
              key = "rp";
              mode = "n";
              action = "gp";
              desc = "Put after";
            }
            {
              key = "rP";
              mode = "n";
              action = "gP";
              desc = "Put before";
            }
            {
              key = "H";
              mode = modes.nvo;
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
              key = "gH";
              mode = modes.nvo;
              action = "g^";
              desc = "Screen top start";
            }
            {
              key = "gL";
              mode = modes.nvo;
              action = "g$";
              desc = "Screen bottom end";
            }
            {
              key = "Y";
              mode = "n";
              action = "y$";
              desc = "Yank to end of line";
            }
            {
              key = "J";
              mode = modes.nv;
              action = "<C-d>";
              desc = "Scroll view down";
            }
            {
              key = "K";
              mode = modes.nv;
              action = "<C-u>";
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
              key = "<leader>lh";
              lua = true;
              action = "function() vim.lsp.buf.hover() end";
              mode = "n";
              desc = "Hover";
            }
            {
              key = "<leader>lj";
              lua = true;
              action = "function() MiniSplitjoin.toggle() end";
              mode = modes.nv;
              desc = "Split or join lines";
            }
            {
              key = "<leader>ln";
              lua = true;
              action = "function() vim.lsp.buf.rename() end";
              mode = "n";
              desc = "Rename symbol";
            }
            {
              key = "<leader>la";
              lua = true;
              action = "function() vim.lsp.buf.code_action() end";
              mode = "n";
              desc = "Code action";
            }
            {
              key = "<leader>lr";
              lua = true;
              action = "function() vim.lsp.buf.references() end";
              mode = "n";
              desc = "Find references";
            }
            {
              key = "<leader>li";
              lua = true;
              action = "function() vim.lsp.buf.implementation() end";
              mode = "n";
              desc = "Go to implementation";
            }
            {
              key = "<leader>lt";
              lua = true;
              action = "function() vim.lsp.buf.type_definition() end";
              mode = "n";
              desc = "Go to type definition";
            }
            {
              key = "<leader>lo";
              lua = true;
              action = "function() vim.lsp.buf.document_symbol() end";
              mode = "n";
              desc = "Document symbols";
            }
            {
              key = "<leader>lf";
              lua = true;
              action = "function() local ok, conform = pcall(require, 'conform'); if ok then conform.format({ async = true }) else vim.lsp.buf.format({ async = true }) end end";
              mode = "n";
              desc = "Format buffer";
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
              key = "<leader>ds";
              lua = true;
              action = "function() require('dapui').float_element('scopes') end";
              mode = "n";
              desc = "Float scopes";
            }
            {
              key = "<leader>dS";
              lua = true;
              action = "function() require('dapui').float_element('stacks') end";
              mode = "n";
              desc = "Float stacks";
            }
            {
              key = "<leader>dw";
              lua = true;
              action = "function() require('dapui').float_element('watches') end";
              mode = "n";
              desc = "Float watches";
            }
            {
              key = "<leader>dB";
              lua = true;
              action = "function() require('dapui').float_element('breakpoints') end";
              mode = "n";
              desc = "Float breakpoints";
            }
            {
              key = "<leader>de";
              lua = true;
              action = "function() require('dapui').float_element('repl') end";
              mode = "n";
              desc = "Float REPL";
            }
            {
              key = "<leader>dp";
              lua = true;
              action = "function() Snacks.profiler.toggle() end";
              mode = "n";
              desc = "Toggle Profiler";
            }

          ];

        undoFile.enable = true;

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

          cmdheight = 0;

          mouse = "a";

          conceallevel = 2;

          listchars = "tab:> ,nbsp:␣,space:·,trail:.,precedes:…,extends:…";
          list = true;

          display = "lastline,truncate";

          pumheight = 10;
        };
        augroups = [
          {
            name = "UserAutocmds";
          }
        ];
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
          {
            event = [ "BufReadPost" ];
            group = "UserAutocmds";
            desc = "Restore last cursor position";
            callback = mkLuaInline ''
              function(ev)
                if vim.bo[ev.buf].buftype ~= "" then
                  return
                end
                local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
                local count = vim.api.nvim_buf_line_count(ev.buf)
                if mark[1] > 0 and mark[1] <= count then
                  pcall(vim.api.nvim_win_set_cursor, 0, mark)
                end
              end
            '';
          }
          {
            event = [ "LspAttach" ];
            group = "UserAutocmds";
            desc = "Highlight LSP references";
            callback = mkLuaInline ''
              function(ev)
                local client = vim.lsp.get_client_by_id(ev.data.client_id)
                if not client or not client:supports_method("textDocument/documentHighlight") then
                  return
                end
                vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                  buffer = ev.buf,
                  callback = vim.lsp.buf.document_highlight,
                })
                vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                  buffer = ev.buf,
                  callback = vim.lsp.buf.clear_references,
                })
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

                        ${config.styles.pills.lualine.init}
                        _G.mk_pill = _G.pills.left

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

  programs.wallust.settings = {
    templates.nvim = {
      template = "nvim-colors.lua";
      target = "${config.home.homeDirectory}/.config/nvf/lua/wallust.lua";
    };
    hooks.nvim = "${pkgs.procps}/bin/pkill -SIGUSR1 nvim || true";
  };
}
