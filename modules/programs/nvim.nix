{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.nvf = {
    enable = true;

    settings.vim = {
      lazy.plugins = {
        "snacks.nvim" = {
          package = pkgs.vimPlugins.snacks-nvim;
          lazy = false;
          setupModule = "snacks";
          setupOpts = {
            dashboard = {
              enable = true;
              example = "github";
            };
            input = {
              enabled = true;
              # expand = true;
              # icon_pos = "left";
              # win.style = "input";
            };
            picker = {
              enable = true;
            };
            statuscolumn = {
              enable = true;
            };
            scroll = {
              enable = true;
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
      };

      lsp = {
        enable = true;
        inlayHints.enable = true;
        lightbulb.enable = true;
        lspkind.enable = true;
        trouble.enable = true;
      };
      # lsp.presets = {
      #   nixd.enable = true;
      # };

      debugger = {
        nvim-dap.enable = true;
        nvim-dap.ui.enable = true;
      };

      autocomplete.blink-cmp.enable = true;

      binds.whichKey.enable = true;
      binds.whichKey.setupOpts.preset = "helix";

      theme = {
        enable = true;
      };

      ui = {
        borders.enable = true;
        borders.plugins = {
          which-key.enable = true;
        };
        colorizer.enable = true;
        noice.enable = true;
      };

      statusline.lualine = {
        enable = true;
        sectionSeparator = {
          left = "";
          right = "";
        };
        activeSection = {
          a = [
            ''
              { "mode", icons_enabled = "true", right_padding = 2, separator = { left = "" } }
            ''
          ];
          b = [
            ''
              { "filetype", icon_only = true, icon = { align = "left" } }
            ''
            ''
              { "filename", symbols = { modified = "", readonly = "" } }
            ''
            "branch"
          ];
          c = [
            ''
              { "diff", colored = false, diff_color = { added = "DiffAdd", modified = "DiffChange", removed = "DiffDelete", symbols = { added = "+", modified = "~", removed = "-" } } }
            ''
            "diagnostics"
          ];
        };
      };

      visuals = {
        blink-indent.enable = true;
        cinnamon-nvim.enable = true;
        fidget-nvim.enable = true;
      };

      lineNumberMode = "relNumber";
      syntaxHighlighting = true;

      globals = {
        mapleader = " ";
        maplocalleader = "\\\\";
      };

      options = {
        compatible = false;

        tabstop = 2;
        softtabstop = 2;
        expandtab = true;

        shiftwidth = 2;
        shiftround = true;

        completeopt = "menuone,noinsert,popup";

        copyindent = true;

        showmatch = true;

        scrolloff = 4;

        cmdheight = 1;

        conceallevel = 2;

        list = true;
        listchars = "tab:> ,nbsp:+,space:·,trail:.,precedes:<,extends:>";

        display = "lastline,truncate";
      };
    };
  };
}
