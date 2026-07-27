{ pkgs, lib, ... }:
let
  inherit (lib.generators) mkLuaInline;
  modes = {
    motion = [
      "n"
      "v"
      "o"
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
        extraPackages = [ hollowHeapColorscript ];
        lazy.plugins = with pkgs; {
          "helpview.nvim" = {
            package = vimPlugins.helpview-nvim;
          };
          "foldtext.nvim" = {
            package = vimUtils.buildVimPlugin {
              pname = "foldtext.nvim";
              version = "2.0.0";
              src = fetchFromGitHub {
                owner = "OXY2DEV";
                repo = "foldtext.nvim";
                rev = "v2.0.0";
                hash = "sha256-jOcspms+hJEe9G+qSD/ytNo5uLgv29DAGdSGn0Az6Fg=";
              };
            };
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

          nix.enable = true;
          python.enable = true;
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

        debugger = {
          nvim-dap.enable = true;
          nvim-dap.ui.enable = true;
        };

        assistant = {
          avante-nvim.enable = true;
          avante-nvim.setupOpts = {
            provider = "gemini-cli";
            acp_providers = {
              gemini-cli = {
                command = "gemini";
                args = [ "--acp" ];
                env = {
                  NODE_NO_WARNINGS = "1";
                };
              };
            };
            # behaviour.auto_set_keymaps = false;
          };

          supermaven-nvim.setupOpts = {
            disable_inline_completion = true;
            disable_keymaps = true;
          };
        };

        autocomplete.blink-cmp = {
          enable = true;
          mappings = {
            previous = "<S-Tab>";
            next = "<Tab>";
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
              package = pkgs.vimUtils.buildVimPlugin {
                name = "blink-cmp-supermaven";
                src = pkgs.fetchFromGitHub {
                  owner = "Huijiro";
                  repo = "blink-cmp-supermaven";
                  rev = "main";
                  hash = "sha256-pVu58uzakRdAr89I7e4xotBTr9sd5QWkQQlCs2PeFjg=";
                };
                dependencies = with pkgs.vimPlugins; [
                  supermaven-nvim
                  blink-cmp
                ];
              };
            };
          };
        };

        git = {
          gitsigns.enable = true;
        };

        utility = {
          snacks-nvim.enable = true;
          snacks-nvim.setupOpts = {
            dashboard = {
              enabled = true;
              width = 80;
              sections = [
                {
                  section = "terminal";
                  cmd = "${hollowHeapColorscript}/bin/hollowheap-colorscript";
                  align = "center";
                  height = 8;
                }
                {
                  section = "keys";
                  gap = 1;
                }
                {
                  section = "startup";
                }
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
              enable = true;
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
          };
        };

        binds = {
          whichKey = {
            enable = true;
            setupOpts = {
              preset = "helix";
            };
            register = {
              "p" = "Paste after";
              "P" = "Paste before";
              "u" = "Undo";
              "U" = "Redo";
              "gO" = "Document Outline";

              "y" = "+Yank";
              "z" = "+Fold";

              "s" = "+Surround";
              "g" = "+Go to";

              "<leader>" = "+Menu";

              "<leader>a" = "+Agent";
              "<leader>l" = "+LSP";
              "<leader>lg" = "+Go to";
              "<leader>lt" = "+Toggle";
              "<leader>lw" = "+Workspace";

              "<leader>s" = "+Search";
              "<leader>sx" = "+Diagnostics";
              # "<leader>f" = "+Find";
              "<leader>d" = "+Debugger";
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


        ui = {
          borders.enable = true;
          borders.plugins = {
            which-key.enable = true;
          };

          colorizer.enable = true;
          colorful-menu-nvim.enable = true;
          illuminate.enable = true;

          noice.enable = true;
          noice.setupOpts = {
            lsp.progress.enabled = false;
            lsp.override = {
              "cmp.entry.get_documentation" = false;
              "vim.lsp.util.convert_input_to_markdown_lines" = false;
              "vim.lsp.util.stylize_markdown" = false;
            };
            notify.enabled = false;
            preset.bottom_search = false;
          };
        };

        statusline.lualine = {
          enable = true;
          icons.enable = true;
          sectionSeparator = {
            left = "";
            right = "";
          };
          componentSeparator = {
            left = "";
            right = "";
          };
          activeSection = {
            a = [
              ''
                { "mode", separator = { left = "" }, right_padding = 2 }
              ''
            ];
            b = [
              ''
                { "filename", symbols = { modified = " ", readonly = " " } }
              ''
              "branch"
            ];
            c = [
              ''
                { "diff", colored = false, diff_color = { added = "DiffAdd", modified = "DiffChange", removed = "DiffDelete" }, symbols = { added = "+", modified = "~", removed = "-" } }
              ''
              "diagnostics"
            ];
            x = [
              ''
                {
                  function()
                    if not package.loaded["noice"] then return "" end
                    return require("noice").api.status.command.get()
                  end,
                  cond = function()
                    if not package.loaded["noice"] then return false end
                    return require("noice").api.status.command.has()
                  end
                }
              ''
              ''
                { "filetype", icon_only = true, icon = { align = "left" } }
              ''
            ];
            # y uses defaults
            z = [
              ''
                { "progress", left_padding = 2 }
              ''
              ''
                { "location", separator = { right = "" } }
              ''
            ];
          };
          inactiveSection = {
            a = [ "filename" ];
            b = [];
            c = [];
            x = [];
            y = [];
            z = [];
          };
        };

        visuals = {
          # blink-indent.enable = true;
          fidget-nvim.enable = true;
        };

        keymaps =
          (map
            (key: {
              inherit key;
              mode = modes.motion;
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
              mode = [ "n" "v" ];
              action = "\"_x";
              desc = "Delete without yank";
            }
            {
              key = "X";
              mode = [ "n" "v" ];
              action = "\"_X";
              desc = "Delete without yank (backwards)";
            }
            {
              key = "*";
              mode = "n";
              action = "*";
              desc = "Search forward";
            }
            {
              key = "#";
              mode = "n";
              action = "#";
              desc = "Search backward";
            }
            {
              key = "d";
              mode = [
                "n"
                "v"
              ];
              action = "d";
              desc = "Delete";
            }
            {
              key = "y";
              mode = [
                "n"
                "v"
              ];
              action = "y";
              desc = "Yank";
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
              mode = modes.motion;
              action = "ge";
              desc = "Prev end of word";
            }
            {
              key = "R";
              mode = modes.motion;
              action = "gE";
              desc = "Prev end of WORD";
            }
            {
              key = "H";
              mode = modes.motion;
              action = "^";
              desc = "Beginning of line";
            }
            {
              key = "L";
              mode = modes.motion;
              action = "$";
              desc = "End of line";
            }
            {
              key = "J";
              mode = modes.motion;
              action = "<C-d>zz";
              desc = "Scroll view down";
            }
            {
              key = "K";
              mode = modes.motion;
              action = "<C-u>zz";
              desc = "Scroll view up";
            }
            {
              key = "gj";
              mode = modes.motion;
              action = "Gzz";
              desc = "Bottom of file";
            }
            {
              key = "gk";
              mode = modes.motion;
              action = "ggzz";
              desc = "Top of file";
            }
            {
              key = "<leader>y";
              mode = modes.motion;
              action = "\"+y";
              desc = "Yank to clipboard";
            }
            {
              key = "<leader>p";
              mode = modes.motion;
              action = "\"+p";
              desc = "Paste after from clipboard";
            }
            {
              key = "<leader>P";
              mode = modes.motion;
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
              mode = modes.motion;
              action = "<cmd>wqa<cr>";
              desc = "Quit and save";
            }
            {
              key = "<leader>qq";
              mode = modes.motion;
              action = "<cmd>qa!<cr>";
              desc = "Quit without saving";
            }

            # Core Pickers
            {
              key = "<leader>sf";
              lua = true;
              action = "function() Snacks.picker.files() end";
              mode = "n";
              desc = "Find Files";
            }
            {
              key = "<leader>sg";
              lua = true;
              action = "function() Snacks.picker.grep() end";
              mode = "n";
              desc = "Live Grep";
            }
            {
              key = "<leader>sb";
              lua = true;
              action = "function() Snacks.picker.buffers() end";
              mode = "n";
              desc = "Buffers";
            }

            # LSP Menus
            {
              key = "<leader>sd";
              lua = true;
              action = "function() Snacks.picker.diagnostics_buffer() end";
              mode = "n";
              desc = "Document diagnostics [snacks]";
            }
            {
              key = "<leader>lr";
              lua = true;
              action = "function() Snacks.picker.lsp_references() end";
              mode = "n";
              desc = "LSP References [snacks]";
            }
            {
              key = "<leader>lS";
              lua = true;
              action = "function() Snacks.picker.lsp_symbols() end";
              mode = "n";
              desc = "List document symbols [snacks]";
            }

            # Workspace/Global Menus
            {
              key = "<leader>sxl";
              lua = true;
              action = "function() Snacks.picker.loclist() end";
              mode = "n";
              desc = "Location List [snacks]";
            }
            {
              key = "<leader>sxq";
              lua = true;
              action = "function() Snacks.picker.qflist() end";
              mode = "n";
              desc = "Quickfix List [snacks]";
            }
            {
              key = "<leader>sxd";
              lua = true;
              action = "function() Snacks.picker.diagnostics() end";
              mode = "n";
              desc = "Workspace Diagnostics [snacks]";
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
            event = [ "UIEnter" ];
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
                    startuptime = _G.lazy_startup_time or vim.uv.now() / 1e6,
                    count = #vim.fn.globpath(vim.o.packpath, "pack/*/*/*", 0, 1),
                    loaded = #vim.fn.globpath(vim.o.packpath, "pack/*/start/*", 0, 1)
                  }
                end
              }
            end

            local matugen_path = vim.fn.expand("~/.config/nvim/lua/matugen.lua")
            local function load_matugen()
              package.loaded['matugen'] = nil
              local ok, matugen = pcall(dofile, matugen_path)
              if ok and type(matugen) == "table" and type(matugen.setup) == "function" then
                matugen.setup()
                vim.api.nvim_exec_autocmds("ColorScheme", {})
              end
            end

            load_matugen()

            vim.api.nvim_create_autocmd("Signal", {
              pattern = "SIGUSR1",
              callback = function()
                load_matugen()
                vim.cmd("redraw!")
              end,
            })
          '';
        };
      };
    };
  };
}
