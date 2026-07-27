{ config, pkgs, ... }:
{
  programs.noctalia.enable = true;
  programs.noctalia.settings = {
    theme = {
      mode = "auto";
      source = "wallpaper";
      wallpaper_scheme = "faithful";
      templates = {
        builtin_ids = [
          "btop"
          "ghostty"
        ];
        community_ids = [
          "neovim"
          "pear-desktop"
          "vicinae"
          "discord"
          "steam"
          "bat"
          "zen-browser"
        ];

        user = {
          hyprland = {
            enabled = true;
            input_path = "$XDG_CONFIG_HOME/noctalia/templates/hypr-colors.lua";
            output_path = "$XDG_CONFIG_HOME/hypr/noctalia.lua";
            post_hook = "hyprctl reload config-only";
          };
          neovim = {
            enabled = true;
            input_path = "$XDG_CONFIG_HOME/noctalia/templates/neovim.lua";
            output_path = "~/.cache/nvim/matugen.lua";
            post_hook = "pkill -USR1 nvim || true";
          };
        };
      };
    };
    shell = {
      setup_wizard_enabled = false;
      polkit_agent = true;
      launch_apps_custom_command = "uwsm app -- $CMD";

      screen_corners = {
        enabled = true;
        size = config.theme.dims.border.radius;
      };
      panel = {
        transparency_mode = "glass";
        borders = false;
      };
      screenshot = {
        directory = "~/Pictures/Screenshots";
        freeze_screen = true;
        pipe_to_command = true;
        pipe_command = "satty -f - --copy-command wl-copy";
      };
      session.grid = true;
    };
    wallpaper.default.path = "/home/hollowheap/Pictures/Wallpapers/Nilou2.png";
    location.address = "Singapore, SG";
    calendar.enabled = true;
    calendar.account.personal = {
      type = "google";
      name = "Personal";
    };
    weather.enabled = true;
    dock = {
      enabled = true;
      auto_hide = true;
      icon_size = 24;
      reserve_space = false;
    };
    bar.order = [ "main" ];
    bar."main" = {
      position = "top";
      padding = 24;
      margin_ends = 48;
      margin_edge = config.theme.dims.margin.inner;
      background_opacity = 0.9;
      start = [
        "group:main"
        "group:audio"
      ];
      center = [ "workspaces" ];
      end = [ "group:actions" ];
      capsule_group = [
        {
          id = "main";
          members = [
            "control-center"
            "clock"
          ];
          padding = 12;
        }
        {
          id = "audio";
          members = [
            "media"
            "audio_visualizer"
          ];
        }
        {
          id = "actions";
          members = [
            "tray"
            "weather"
            "network"
            "bluetooth"
            "volume"
            "notifications"
          ];
        }
      ];
    };

    widget = {
      control-center = {
        custom_image = "${pkgs.nixos-icons}/share/icons/hicolor/48x48/apps/nix-snowflake.png";
        custom_image_colorize = true;
      };
      media = {
        album_art_only = true;
      };
      audio_visualizer = {
        bands = 8;
      };
      workspaces = {
        labels_only_when_occupied = true;
        capsule = true;
      };
      tray = {
        drawer = true;
      };
    };
  };
}
