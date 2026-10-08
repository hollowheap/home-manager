{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.noctalia.enable = true;
  programs.noctalia.settings = {
    theme = {
      mode = lib.mkForce "dark";
      source = lib.mkForce "wallpaper";
      wallpaper_scheme = "m3-content";
      pure_black_dark = true;
      templates = {
        builtin_ids = [ ];
        community_ids = [
          "pear-desktop"
          "discord"
          "steam"
          "zen-browser"
        ];

        user = {
          hyprland = {
            enabled = true;
            input_path = "$XDG_CONFIG_HOME/noctalia/templates/hypr-colors.lua";
            output_path = "$XDG_CONFIG_HOME/hypr/noctalia.lua";
            post_hook = "hyprctl reload config-only";
          };

          wallust = {
            enabled = true;
            input_path = "$XDG_CONFIG_HOME/noctalia/templates/wallust.dummy";
            output_path = "$XDG_CACHE_HOME/noctalia/wallust.dummy";
            post_hook = ''
              st="${config.home.homeDirectory}/.local/state/noctalia/settings.toml"
              if [ -r "$st" ]; then
                img="$(${pkgs.gnused}/bin/sed -n '/^\[wallpaper\.last\]/,/^\[/p' "$st" | ${pkgs.gnugrep}/bin/grep -m1 '^path *=' | ${pkgs.gnused}/bin/sed -E 's/^path *= *"(.*)"$/\1/' || true)"
                if [ -n "$img" ] && [ -r "$img" ]; then
                  ${pkgs.wallust}/bin/wallust run "$img" -s
                fi
              fi
            '';
          };
        };
      };
    };

    shell = {
      setup_wizard_enabled = false;
      polkit_agent = true;
      launch_apps_custom_command = "uwsm app -- $CMD";

      button_borders = false;
      input_borders = false;
      popup_borders = false;
      card_borders = false;

      screen_corners = {
        enabled = true;
        size = config.theme.dims.border.radius * 2;
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

      launcher.app_grid = true;
      session.grid = true;
    };
    location.address = "Singapore, SG";
    calendar.enabled = true;
    calendar.account.personal = {
      type = "google";
      name = "Personal";
    };
    brightness = {
      enable_ddcutil = true;
      monitor.HDMI-A-1.backend = "ddcutil";
      monitor.DP-1.backend = "ddcutil";
    };
    weather.enabled = true;
    wallpaper.transition_on_startup = true;
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
        "launcher"
        "clock"
        "group:audio"
        "workspaces"
      ];
      center = [ "active_window" ];
      end = [ "group:actions" ];
      capsule_group = [
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
            "weather"
            "network"
            "bluetooth"
            "volume"
            "notifications"
            "tray"
          ];
        }
      ];
    };

    idle.behavior = {
      lock.enabled = true;
      suspend = true;
    };

    lockscreen_widgets = {
      enabled = true;

      clock-1 = {
        output = "HDMI-A-1";

      };
    };

    widget = {
      launcher = {
        custom_image = "${pkgs.nixos-icons}/share/icons/hicolor/48x48/apps/nix-snowflake.png";
        custom_image_colorize = true;
        capsule = true;
      };
      clock = {
        capsule = true;
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
      active_window = {
        max_length = 480;
      };
      network = {
        show_label = false;
      };
      tray = {
        anchor = true;
        drawer = true;
      };
    };
  };

  home.packages = with pkgs; [
    ddcutil
    satty
    wl-clipboard
  ];

  xdg.configFile."noctalia/templates/wallust.dummy".text = "dummy";
}
