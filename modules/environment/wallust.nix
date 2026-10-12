{
  config,
  pkgs,
  ...
}:
{
  programs.wallust = {
    enable = true;
    settings = {
      backend = "resized";
      color_space = "salience";
      palette = "saliencedarkbalanced16";
      check_contrast = true;
      fallback_generator = "interpolate";
      saturation = 35;

      templates = {
        nvim = {
          template = "nvim-colors.lua";
          target = "${config.home.homeDirectory}/.config/nvf/lua/wallust.lua";
        };
        ghostty = {
          template = "ghostty";
          target = "${config.home.homeDirectory}/.config/ghostty/themes/wallust";
        };
        btop = {
          template = "btop.theme";
          target = "${config.home.homeDirectory}/.config/btop/themes/wallust.theme";
        };
        yazi = {
          template = "flavor.toml";
          target = "${config.home.homeDirectory}/.config/yazi/flavors/wallust.yazi/flavor.toml";
        };
        lazygit = {
          template = "lazygit.yml";
          target = "${config.home.homeDirectory}/.config/lazygit/theme.yml";
        };
        bat = {
          template = "bat.tmTheme";
          target = "${config.home.homeDirectory}/.config/bat/themes/wallust.tmTheme";
        };
        sequences = {
          template = "sequences";
          target = "${config.home.homeDirectory}/.cache/wallust/sequences";
        };
      };

      hooks = {
        nvim = "${pkgs.procps}/bin/pkill -SIGUSR1 nvim || true";
        ghostty = "${pkgs.glib}/bin/gdbus call --session --dest com.mitchellh.ghostty --object-path /com/mitchellh/ghostty --method org.gtk.Actions.Activate reload-config '[]' '{}' 2>/dev/null || ${pkgs.procps}/bin/pkill -SIGUSR2 -x .ghostty-wrapped 2>/dev/null || ${pkgs.procps}/bin/pkill -SIGUSR2 -x ghostty 2>/dev/null || true";
        btop = "${pkgs.procps}/bin/pkill -SIGUSR2 -x btop || true";
        bat = "${pkgs.bat}/bin/bat cache --build 2>/dev/null || true";
        sequences = "for pt in /dev/pts/[0-9]*; do [ -w \"$pt\" ] && cat ~/.cache/wallust/sequences > \"$pt\" 2>/dev/null || true; done";
      };
    };
  };

  xdg.configFile."wallust/templates".source = ../../assets/wallust-templates;
}
