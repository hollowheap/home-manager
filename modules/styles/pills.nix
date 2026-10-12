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
          }:
          let
            boldIconAttr = if boldIcon then ",bold" else "";
            boldTextAttr = if boldText then ",bold" else "";
            iconStr = ensureTrailingSpace icon;
            textStr = if padText then pad text else text;
          in
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
        mkSplitPill =
          {
            icon,
            text,
            accent,
            textBg ? "bright-white",
            iconFg ? "black",
            textFg ? "black",
            padText ? true,
          }:
          let
            iconStr = ensureTrailingSpace icon;
            textStr = if padText then pad text else text;
          in
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
      };
    };
  };
}
