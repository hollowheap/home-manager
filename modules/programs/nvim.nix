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
        lazy.plugins = with pkgs; {
          "helpview.nvim" = {
            ft = [ "help" ];
            lazy = true;
            package = vimPlugins.helpview-nvim;
          };
          "foldtext.nvim" = {
            keys = [
              {
                mode = modes.nvo;
                key = "z";
              }
            ];
            lazy = true;
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
          config.virtual_text = true;
        };

        debugger = {
          nvim-dap.enable = true;
          nvim-dap.ui.enable = true;
        };

        assistant = {
          avante-nvim.enable = true;
          avante-nvim.setupOpts = {
            # provider = "copilot";
          };

          supermaven-nvim.enable = true;
          supermaven-nvim.setupOpts = {
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
          smart-splits.enable = true;
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
                  icon = " ";
                  key = "c";
                  desc = "Config";
                  action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.expand('~/.config/home-manager/')})";
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
              "<leader>l" = "+LSP";
              "<leader>lg" = "+Go to";
              "<leader>lt" = "+Toggle";
              "<leader>lw" = "+Workspace";

              "<leader>s" = "+Search";
              "<leader>sx" = "+Diagnostics";
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
        theme = {
          enable = true;
          base16-colors = {
            base00 = "#000000";
            base01 = "#1e1e1e";
            base02 = "#2e2e2e";
            base03 = "#555555";
            base04 = "#6e6e6e";
            base05 = "#ababab";
            base06 = "#d9d9d9";
            base07 = "#ffffff";
            base08 = "#ff0000";
            base09 = "#ff0000";
            base0A = "#ff0000";
            base0B = "#00ff00";
            base0C = "#00ff00";
            base0D = "#0000ff";
            base0E = "#0000ff";
            base0F = "#0000ff";
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
          # setupOpts.options.theme =
          #   let
          #     colors = "require('base16-colorscheme').colors";
          #   in
          #   mkLuaInline "";
          icons.enable = true;
          sectionSeparator = {
            left = "";
            right = "";
          };
          componentSeparator = {
            left = "";
            right = "";
          };
          activeSection =
            let
              separator = ''separator = { left = "", right = "" }'';
            in
            {
              a = [
                ''
                  { "mode", ${separator} }
                ''
              ];
              b = [
                ''
                  { "filename", ${separator}, symbols = { modified = " ", readonly = " " }, onclick = function() Snacks.picker.buffers() end }
                ''
                ''
                  { "branch", ${separator}, icon = " •", right_padding = 1, onclick = function() Snacks.picker.git_branches() end }
                ''
              ];
              c = [
                ''
                  { "diff", ${separator}, colored = false, symbols = { added = "+ ", modified = "~ ", removed = "- " } }
                ''
                "diagnostics"
              ];
              x = [
                ''
                  { "filetype", icon_only = true, icon = { align = "left" } }
                ''
              ];
              y = [
                ''{ "searchcount" }''
              ];
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
            b = [ ];
            c = [ ];
            x = [ ];
            y = [ ];
            z = [ ];
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

            require("noctalia").setup()

            local colors = require("base16-colorscheme").colors
            require("lualine").setup({
	            options = {
                theme = {
                  normal = {
                    a = { fg = colors.base00, bg = colors.base08 },
                    b = { fg = colors.base05, bg = colors.base00 },
                    c = { fg = colors.base05, bg = colors.base00 },

                    x = { fg = colors.base05, bg = colors.base00 },
                    y = { fg = colors.base05, bg = colors.base00 },
                    z = { fg = colors.base00, bg = colors.base05 },
                  },
                  insert = { a = { fg = colors.base00, bg = colors.base09 } },
                  visual = { a = { fg = colors.base00, bg = colors.base0A } },
                  replace = { a = { fg = colors.base00, bg = colors.base0B } },
                  command = { a = { fg = colors.base00, bg = colors.base0C } },

                  inactive = { 
                    a = { fg = colors.base00, bg = colors.base05 },
                    b = { fg = colors.base05, bg = colors.base00 },
                    c = { fg = colors.base05, bg = colors.base00 },

                    x = { fg = colors.base05, bg = colors.base00 },
                    y = { fg = colors.base05, bg = colors.base00 },
                    z = { fg = colors.base00, bg = colors.base05 },
                  },
                }
	            }
            })
          '';
        };
      };
    };
  };

  xdg.configFile."noctalia/templates/nvim-colors.lua".text = ''
    local M = {}

    function M.setup()
      require('base16-colorscheme').setup({
        -- Background tones
        base00 = '{{colors.surface.default.hex}}', -- Default Background
        base01 = '{{colors.surface_container.default.hex}}', -- Lighter Background (status bars)
        base02 = '{{colors.surface_container_high.default.hex}}', -- Selection Background
        base03 = '{{colors.outline.default.hex}}', -- Comments, Invisibles
        -- Foreground tones
        base04 = '{{colors.on_surface_variant.default.hex}}', -- Dark Foreground (status bars)
        base05 = '{{colors.on_surface.default.hex}}', -- Default Foreground
        base06 = '{{colors.on_surface.default.hex}}', -- Light Foreground
        base07 = '{{colors.on_background.default.hex}}', -- Lightest Foreground
        -- Accent colors
        base08 = '{{colors.error.default.hex}}', -- Variables, XML Tags, Errors
        base09 = '{{colors.tertiary.default.hex}}', -- Integers, Constants
        base0A = '{{colors.secondary.default.hex}}', -- Classes, Search Background
        base0B = '{{colors.primary.default.hex}}', -- Strings, Diff Inserted
        base0C = '{{colors.tertiary_fixed_dim.default.hex}}', -- Regex, Escape Chars
        base0D = '{{colors.primary_fixed_dim.default.hex}}', -- Functions, Methods
        base0E = '{{colors.secondary_fixed_dim.default.hex}}', -- Keywords, Storage
        base0F = '{{colors.error_container.default.hex}}', -- Deprecated, Embedded Tags
      })
    end

    vim.uv.new_signal():start('sigusr1',
      vim.schedule_wrap(function()
        package.loaded['noctalia'] = nil
        require('noctalia').setup()
      end)
    )

    return M
  '';
}
