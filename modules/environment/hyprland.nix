{ config, lib, ... }:
let
  inherit (builtins) concatLists genList;
  inherit (lib.trivial) mod;
  inherit (lib.generators) mkLuaInline;

  mkArgs = args: { _args = args; };
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    portalPackage = null;
    systemd.enable = false;
  };

  wayland.windowManager.hyprland.settings = {
    colors = {
      _var = mkLuaInline ''require("noctalia")'';
    };

    monitor = {
      output = "eDP-1";
      mode = "highrr";
      position = "auto";
      scale = "1";
    };

    env = map mkArgs [
      [
        "XDG_CURRENT_DESKTOP"
        "Hyprland"
      ]
      [
        "XDG_SESSION_DESKTOP"
        "Hyprland"
      ]
    ];

    config = {
      cursor = {
        no_hardware_cursors = true;
      };

      general = {
        layout = "scrolling";

        border_size = config.theme.dims.border.size;
        gaps_in = config.theme.dims.margin.inner;
        gaps_out = config.theme.dims.margin.outer;

        col = {
          active_border = mkLuaInline "colors.active_border";
          inactive_border = mkLuaInline "colors.inactive_border";
        };

        snap = {
          enabled = true;
          respect_gaps = true;
        };
      };

      decoration = {
        rounding = config.theme.dims.border.radius;
        rounding_power = config.theme.dims.border.rounding_power;

        inactive_opacity = 0.7;
        active_opacity = 0.9;

        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = mkLuaInline "colors.active_shadow";
          color_inactive = mkLuaInline "colors.inactive_shadow";
        };

        blur = {
          enabled = true;
          size = 3;
          passes = 2;
          vibrancy = 0.1696;
        };
      };
    };

    on = mkArgs [
      "hyprland.start"
      (mkLuaInline "function()\n  hl.exec_cmd(\"uwsm app noctalia\")\nend")
    ];

    layer_rule = [
      {
        name = "noctalia";
        match = {
          namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd)$";
        };
        blur = true;
        blur_popups = true;
        ignore_alpha = 0.5;
      }
    ];

    workspace_rule = [
      {
        workspace = "w[tv1]s[false]";
        gaps_out = config.theme.dims.margin.inner;
        gaps_in = 0;
      }
      {
        workspace = "f[1]s[false]";
        gaps_out = config.theme.dims.margin.inner;
        gaps_in = 0;
      }
    ];

    window_rule = [
      {
        name = "no-maximize";
        match = {
          class = ".*";
        };
        suppress_event = "maximize";
      }
      {
        name = "zen-popups";
        match = {
          class = "zen-.*";
          initial_title = "(Library|About Zen)";
        };
        float = true;
        opaque = true;
      }
      {
        name = "thunderbird-popups";
        match = {
          class = "thunderbird";
          initial_title = "(Write:.*|Address Book|Reminder)";
        };
        float = true;
        opaque = true;
      }
      {
        name = "discord-updater";
        match = {
          class = "discord";
          initial_title = "Discord Updater";
        };
        float = true;
        opaque = true;
      }
      {
        name = "zen-pip";
        match = {
          class = "zen-.*";
          initial_title = "Picture-in-Picture";
        };
        float = true;
        opaque = true;
        persistent_size = true;
        content = "video";
        pin = true;
      }
      {
        name = "noctalia-settings-float";
        match = {
          class = "dev.noctalia.Noctalia.Settings";
          initial_title = "Noctalia Settings";
        };
        float = true;
      }
    ];

    # Standard binds mapped to your wrapper's `_args` structure
    bind = map mkArgs (
      [
        # Active window controls
        [
          "SUPER + M"
          (mkLuaInline "hl.dsp.window.fullscreen({ internal = 1, client = 1 })")
        ]
        [
          "SUPER + F"
          (mkLuaInline "hl.dsp.window.fullscreen({ internal = 2, client = 2 })")
        ]
        [
          "SUPER + T"
          (mkLuaInline "hl.dsp.window.float({ action = \"set\" })")
        ]
        [
          "SUPER + Q"
          (mkLuaInline "hl.dsp.window.close()")
        ]
        [
          "SUPER + mouse:272"
          (mkLuaInline "hl.dsp.window.drag()")
          { mouse = true; }
        ]
        [
          "SUPER + mouse:273"
          (mkLuaInline "hl.dsp.window.resize()")
          { mouse = true; }
        ]

        # Active workspace controls
        # [ "SUPER + SHIFT + T" (mkLuaInline "hl.dsp.workspace.opt(\"allfloat\")") ])
        [
          "SUPER + G"
          (mkLuaInline "hl.dsp.group.toggle()")
        ]
        # [ "SUPER + X" (mkLuaInline "hl.dsp.window.togglesplit()") ])

        # App shortcuts
        [
          "SUPER + RETURN"
          (mkLuaInline "hl.dsp.exec_cmd(\"ghostty\")")
        ]
        [
          "SUPER + V"
          (mkLuaInline "hl.dsp.exec_cmd(\"noctalia msg launcher clipboard\")")
        ]
        [
          "SUPER + SPACE"
          (mkLuaInline "hl.dsp.exec_cmd(\"noctalia msg panel-toggle launcher\")")
        ]
        [
          "SUPER + TAB"
          (mkLuaInline "hl.dsp.exec_cmd(\"noctalia msg window-switcher\")")
        ]
        [
          "SUPER + SHIFT + L"
          (mkLuaInline "hl.dsp.exec_cmd(\"noctalia msg lockScreen lock\")")
        ]

        # Window focus navigation
        [
          "SUPER + H"
          (mkLuaInline "hl.dsp.focus({ direction = \"l\" })")
        ]
        [
          "SUPER + J"
          (mkLuaInline "hl.dsp.focus({ direction = \"d\" })")
        ]
        [
          "SUPER + K"
          (mkLuaInline "hl.dsp.focus({ direction = \"u\" })")
        ]
        [
          "SUPER + L"
          (mkLuaInline "hl.dsp.focus({ direction = \"r\" })")
        ]

        # Window swapping
        # [ "SUPER + S" (mkLuaInline "hl.dsp.window.swapsplit()") ])
        [
          "SUPER + ALT + H"
          (mkLuaInline "hl.dsp.window.swap({ direction = \"l\" })")
        ]
        [
          "SUPER + ALT + J"
          (mkLuaInline "hl.dsp.window.swap({ direction = \"d\" })")
        ]
        [
          "SUPER + ALT + K"
          (mkLuaInline "hl.dsp.window.swap({ direction = \"u\" })")
        ]
        [
          "SUPER + ALT + L"
          (mkLuaInline "hl.dsp.window.swap({ direction = \"r\" })")
        ]

        # Workspace navigation
        [
          "SUPER + mouse_down"
          (mkLuaInline "hl.dsp.focus({ workspace = \"e-1\" })")
        ]
        [
          "SUPER + mouse_up"
          (mkLuaInline "hl.dsp.focus({ workspace = \"e+1\" })")
        ]
        [
          "SUPER + P"
          (mkLuaInline "hl.dsp.focus({ workspace = \"r-1\" })")
        ]
        [
          "SUPER + N"
          (mkLuaInline "hl.dsp.focus({ workspace = \"r+1\" })")
        ]

        # Media and Brightness Keys
        [
          "XF86MonBrightnessUp"
          (mkLuaInline "hl.dsp.exec_cmd(\"noctalia msg brightness-up\")")
          {
            repeating = true;
            locked = true;
          }
        ]
        [
          "XF86MonBrightnessDown"
          (mkLuaInline "hl.dsp.exec_cmd(\"noctalia msg brightness-down\")")
          {
            repeating = true;
            locked = true;
          }
        ]
        [
          "XF86AudioRaiseVolume"
          (mkLuaInline "hl.dsp.exec_cmd(\"noctalia msg volume-up\")")
          {
            repeating = true;
            locked = true;
          }
        ]
        [
          "XF86AudioLowerVolume"
          (mkLuaInline "hl.dsp.exec_cmd(\"noctalia msg volume-down\")")
          {
            repeating = true;
            locked = true;
          }
        ]
        [
          "XF86AudioMute"
          (mkLuaInline "hl.dsp.exec_cmd(\"noctalia msg volume-mute\")")
          { locked = true; }
        ]
        [
          "XF86AudioPlay"
          (mkLuaInline "hl.dsp.exec_cmd(\"noctalia msg media toggle\")")
          { locked = true; }
        ]
        [
          "XF86AudioPrev"
          (mkLuaInline "hl.dsp.exec_cmd(\"noctalia msg media previous\")")
          { locked = true; }
        ]
        [
          "XF86AudioNext"
          (mkLuaInline "hl.dsp.exec_cmd(\"noctalia msg media next\")")
          { locked = true; }
        ]

        # Other shortcuts
        [
          "SUPER + SHIFT + S"
          (mkLuaInline "hl.dsp.exec_cmd(\"noctalia msg screenshot-region\")")
        ]
      ]
      # Appending the dynamically generated workspace sets (1-10 and 11-20)
      ++ (concatLists (
        genList (
          i:
          let
            key = toString (mod (i + 1) 10);
            wsIdx = toString (i + 1);
            wsIdxCont = toString (i + 11);
          in
          [
            [
              "SUPER + ${key}"
              (mkLuaInline "hl.dsp.focus({ workspace = \"${wsIdx}\" })")
            ]
            [
              "SUPER + ALT + ${key}"
              (mkLuaInline "hl.dsp.focus({ workspace = \"${wsIdxCont}\" })")
            ]
            [
              "SUPER + SHIFT + ${key}"
              (mkLuaInline "hl.dsp.window.move({ workspace = \"${wsIdx}\" })")
            ]
            [
              "SUPER + SHIFT + ALT + ${key}"
              (mkLuaInline "hl.dsp.window.move({ workspace = \"${wsIdxCont}\" })")
            ]
          ]
        ) 10
      ))
    );
  };

  xdg.configFile."noctalia/templates/hypr-colors.lua".text = ''
    return {
      active_border = {
        colors = {
          "rgba({{ colors.primary.default.hex_stripped }}ee)",
          "rgba({{ colors.secondary.default.hex_stripped }}ee)",
          "rgba({{ colors.tertiary.default.hex_stripped }}ee)",
          "rgba({{ colors.primary_container.default.hex_stripped }}ee)",
          "rgba({{ colors.secondary_container.default.hex_stripped }}ee)"
        },
        angle = 45
      },
      inactive_border = "rgba({{ colors.surface_variant.default.hex_stripped }}aa)",
      active_shadow = "rgba({{ colors.shadow.default.hex_stripped }}ee)",
      inactive_shadow = "rgba({{ colors.shadow.default.hex_stripped }}aa)"
    }
  '';
}
