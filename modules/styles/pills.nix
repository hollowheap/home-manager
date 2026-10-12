{ config, lib, ... }:

let
  cfg = config.styles.pills;

  ensureTrailingSpace = s: if lib.hasSuffix " " s then s else "${s} ";
  pad = s: " " + lib.removePrefix " " (lib.removeSuffix " " s) + " ";
in
{
  options.styles.pills = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable pill terminal UI style abstraction.";
    };

    symbols = {
      left = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Left pill cap glyph (U+E0B6).";
      };

      right = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Right pill cap glyph (U+E0B4).";
      };
    };

    tmux = lib.mkOption {
      type = lib.types.attrsOf lib.types.unspecified;
      default = { };
      description = "Tmux pill formatting functions.";
    };

    starship = lib.mkOption {
      type = lib.types.attrsOf lib.types.unspecified;
      default = { };
      description = "Starship prompt pill formatting functions.";
    };

    lualine = lib.mkOption {
      type = lib.types.attrsOf lib.types.unspecified;
      default = { };
      description = "Lualine pill separator definitions and helpers.";
    };
  };

  config = lib.mkIf cfg.enable {
    styles.pills = {
      tmux = {
        # Single-segment pill: #[fg=bg,bg=outerBg]#[fg=fg,bg=bg]content#[fg=bg,bg=outerBg]
        mkPill =
          {
            content,
            bg,
            fg ? "black",
            outerBg ? "default",
            bold ? false,
          }:
          let
            boldAttr = if bold then ",bold" else "";
          in
          "#[fg=${bg},bg=${outerBg}]${cfg.symbols.left}#[fg=${fg}${boldAttr},bg=${bg}]${content}#[fg=${bg},bg=${outerBg}]${cfg.symbols.right}";

        # Split pill (accent icon/tag segment + text body segment):
        # #[fg=accent,bg=outerBg]#[fg=iconFg,bg=accent]icon #[fg=textFg,bg=textBg] text #[fg=textBg,bg=outerBg]
        # When inverted, reverses the order: text first, icon second.
        mkSplitPill =
          {
            icon,
            text,
            accent,
            textBg ? "brightwhite",
            iconFg ? "black",
            textFg ? "black",
            outerBg ? "default",
            boldIcon ? false,
            boldText ? false,
            padText ? true,
            invert ? false,
          }:
          let
            boldIconAttr = if boldIcon then ",bold" else "";
            boldTextAttr = if boldText then ",bold" else "";
            iconStr = ensureTrailingSpace icon;
            textStr = if padText then pad text else text;
          in
          if invert then
            "#[fg=${textBg},bg=${outerBg}]${cfg.symbols.left}#[fg=${textFg}${boldTextAttr},bg=${textBg}]${textStr}#[fg=${iconFg}${boldIconAttr},bg=${accent}]${iconStr}#[fg=${accent},bg=${outerBg}]${cfg.symbols.right}"
          else
            "#[fg=${accent},bg=${outerBg}]${cfg.symbols.left}#[fg=${iconFg}${boldIconAttr},bg=${accent}]${iconStr}#[fg=${textFg}${boldTextAttr},bg=${textBg}]${textStr}#[fg=${textBg},bg=${outerBg}]${cfg.symbols.right}";
      };

      starship = {
        # Single-segment pill: [](bg)[content](fg:fg bg:bg)[](bg)
        mkPill =
          {
            content,
            bg,
            fg ? "black",
          }:
          "[${cfg.symbols.left}](${bg})[${content}](fg:${fg} bg:${bg})[${cfg.symbols.right}](${bg})";

        # Split pill: [](accent)[icon ](fg:iconFg bg:accent)[ text ](fg:textFg bg:textBg)[](textBg)
        # When inverted, reverses the order: text first, icon second.
        mkSplitPill =
          {
            icon,
            text,
            accent,
            textBg ? "bright-white",
            iconFg ? "black",
            textFg ? "black",
            padText ? true,
            invert ? false,
          }:
          let
            iconStr = ensureTrailingSpace icon;
            textStr = if padText then pad text else text;
          in
          if invert then
            "[${cfg.symbols.left}](${textBg})[${textStr}](fg:${textFg} bg:${textBg})[${iconStr}](fg:${iconFg} bg:${accent})[${cfg.symbols.right}](${accent})"
          else
            "[${cfg.symbols.left}](${accent})[${iconStr}](fg:${iconFg} bg:${accent})[${textStr}](fg:${textFg} bg:${textBg})[${cfg.symbols.right}](${textBg})";
      };

      lualine = {
        separator = {
          left = cfg.symbols.left;
          right = cfg.symbols.right;
        };
        leftCap = {
          left = cfg.symbols.left;
          right = "";
        };
        rightCap = {
          left = "";
          right = cfg.symbols.right;
        };
        mkPillFn = ''
          _G.mk_pill = function(icon, content, accent, content_bg, content_fg, icon_fg, bar_bg, invert)
            if not content or content == "" then return "" end
            accent = accent or "#7677aa"
            content_bg = content_bg or "#ffffff"
            content_fg = content_fg or "#000000"
            icon_fg = icon_fg or "#000000"
            bar_bg = bar_bg or "#000000"

            local hl_id = "Pill_" .. (accent:gsub("#", "")) .. "_" .. (content_bg:gsub("#", ""))
            vim.api.nvim_set_hl(0, hl_id .. "_Left",  { fg = invert and content_bg or accent, bg = bar_bg })
            vim.api.nvim_set_hl(0, hl_id .. "_Icon",  { fg = icon_fg, bg = accent })
            vim.api.nvim_set_hl(0, hl_id .. "_Body",  { fg = content_fg, bg = content_bg })
            vim.api.nvim_set_hl(0, hl_id .. "_Right", { fg = invert and accent or content_bg, bg = bar_bg })

            if invert then
              return string.format("%%#%s_Left#${cfg.symbols.left}%%#%s_Body# %s %%#%s_Icon#%s %%#%s_Right#${cfg.symbols.right}",
                hl_id, hl_id, content, hl_id, icon, hl_id)
            else
              return string.format("%%#%s_Left#${cfg.symbols.left}%%#%s_Icon#%s %%#%s_Body# %s %%#%s_Right#${cfg.symbols.right}",
                hl_id, hl_id, icon, hl_id, content, hl_id)
            end
          end
        '';
      };
    };
  };
}
