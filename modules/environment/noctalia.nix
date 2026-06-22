{ config, pkgs, ... }:
{
  programs.noctalia.enable = true;
  programs.noctalia.settings = {
    theme = {
      mode = "dark";
      source = "wallpaper";
      wallpaper_scheme = "m3-rainbow";
      templates = {
        builtin_ids = [
          "btop"
          "ghostty"
        ];
        user = {
          hyprland = {
            enabled = true;
            input_path = "$XDG_CONFIG_HOME/noctalia/templates/hypr-colors.lua";
            output_path = "$XDG_CONFIG_HOME/hypr/noctalia.lua";
            post_hook = "hyprctl reload config-only";
          };
        };
      };
    };
    shell = {
      app_icon_colorize = true;
      setup_wizard_enabled = false;
      polkit_agent = true;
      screen_corners = {
        enabled = true;
        size = config.theme.dims.margin.inner;
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
    bar = {
      order = [ "main" ];
      main = {
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
