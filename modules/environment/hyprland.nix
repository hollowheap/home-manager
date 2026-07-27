{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (builtins) concatLists genList;
  inherit (lib.trivial) mod;
  inherit (lib.generators) mkLuaInline toLua;

  mkArgs = args: { _args = args; };

  mkDsp =
    fn:
    mkLuaInline ''
      hl.dsp.${fn}
    '';
  mkDspExec = cmd: mkDsp "exec_cmd(\"${cmd}\")";
  mkLuaFn =
    str:
    mkLuaInline ''
      function()
        ${str}
      end'';
  launchApp = cmd: if config.useUWSM then "uwsm app -- ${cmd}" else cmd;
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    portalPackage = null;
    systemd.enable = false;

    extraConfig = ''
      local hg = hl.plugin.hyprglass
      if hg ~= nil then
        hg.config(${toLua { } config.hyprPlugins.hyprglass})
      end
    '';

    plugins = with pkgs; [
      hyprglass
    ];

    settings = {
      colors = {
        _var = mkLuaInline ''require("noctalia")'';
      };

      monitor = {
        output = "eDP-1";
        mode = "highrr";
        position = "auto";
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

          resize_on_border = true;

          border_size = config.theme.dims.borderSmall.size;
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
            range = 25;
            color = mkLuaInline "colors.active_shadow";
            color_inactive = mkLuaInline "colors.inactive_shadow";
          };

          blur = {
            enabled = true;
            size = 2;
            passes = 2;
            noise = 0.001;
            xray = false;
            ignore_opacity = true;
            vibrancy_darkness = 0.4;
            contrast = 0.9;
            brightness = 0.8;
            vibrancy = 0.17;
            new_optimizations = false;
          };
        };

        binds = {
          allow_workspace_cycles = true;
        };

        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          disable_scale_notification = true;
          # vrr = 3;
        };

        ecosystem = {
          no_update_news = true;
          no_donation_nag = true;
        };

        scrolling = {
          column_width = 0.67;
          focus_fit_method = 0;
        };

      };

      animation = mkArgs [
        {
          enabled = true;
          leaf = "workspaces";
          style = "slidevert";
          bezier = "default";
          speed = 8;
        }
      ];

      on = mkArgs [
        "hyprland.start"
        (mkLuaFn "hl.exec_cmd(\"uwsm app noctalia\")")
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

      window_rule =

        let
          mkFloatRule = name: match: {
            inherit name;
            inherit match;
            float = true;
          };
        in
        [
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
          (mkFloatRule "discord-updater" {
            class = "discord";
            initial_title = "Discord Updater";
          })
          (mkFloatRule "noctalia-settings" {
            class = "dev.noctalia.Noctalia";
            initial_title = "Noctalia Settings";
          })
          (mkFloatRule "satty" {
            class = "com.gabm.satty";
          })
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
        ];

      # Standard binds mapped to your wrapper's `_args` structure
      bind = map mkArgs (
        [
          # Active window controls
          [
            "SUPER + M"
            (mkDsp "window.fullscreen({ internal = 1, client = 1 })")
          ]
          [
            "SUPER + F"
            (mkDsp "window.fullscreen({ internal = 2, client = 2 })")
          ]
          [
            "SUPER + T"
            (mkDsp "window.float({ action = \"set\" })")
          ]
          [
            "SUPER + Q"
            (mkDsp "window.close()")
          ]
          [
            "SUPER + mouse:272"
            (mkDsp "window.drag()")
            { mouse = true; }
          ]
          [
            "SUPER + mouse:273"
            (mkDsp "window.resize()")
            { mouse = true; }
          ]

          # Active workspace controls
          # [ "SUPER + SHIFT + T" (mkDsp "workspace.opt(\"allfloat\")") ])
          [
            "SUPER + G"
            (mkDsp "group.toggle()")
          ]
          # [ "SUPER + X" (mkDsp "window.togglesplit()") ])

          # App shortcuts
          [
            "SUPER + RETURN"
            (mkDspExec (launchApp config.defaultApps.terminal))
          ]
          [
            "SUPER + B"
            (mkDspExec (launchApp config.defaultApps.browser))
          ]
          [
            "SUPER + E"
            (mkDspExec (launchApp "${config.defaultApps.terminal} -e ${config.defaultApps.fileManager}"))
          ]
          [
            "SUPER + V"
            (mkDspExec (launchApp "noctalia msg launcher clipboard"))
          ]
          [
            "SUPER + SPACE"
            (mkDspExec (launchApp "noctalia msg panel-toggle launcher"))
          ]
          [
            "SUPER + TAB"
            (mkDsp "focus({ workspace = \"previous_per_monitor\" })")
          ]
          [
            "ALT + TAB"
            (mkDspExec "noctalia msg window-switcher")
          ]
          [
            "SUPER + SHIFT + ESCAPE"
            (mkDspExec "noctalia msg panel-toggle session")
          ]

          # Window focus navigation
          [
            "SUPER + mouse_down"
            (mkDsp "focus({ direction = \"l\" })")
          ]
          [
            "SUPER + mouse_up"
            (mkDsp "focus({ direction = \"r\" })")
          ]
          [
            "SUPER + H"
            (mkDsp "focus({ direction = \"l\" })")
          ]
          [
            "SUPER + J"
            (mkDsp "focus({ direction = \"d\" })")
          ]
          [
            "SUPER + K"
            (mkDsp "focus({ direction = \"u\" })")
          ]
          [
            "SUPER + L"
            (mkDsp "focus({ direction = \"r\" })")
          ]

          # Window swapping
          # [ "SUPER + S" (mkDsp "window.swapsplit()") ])
          [
            "SUPER + SHIFT + mouse_down"
            (mkDsp "window.swap({ direction = \"l\" })")
          ]
          [
            "SUPER + SHIFT + mouse_up"
            (mkDsp "window.swap({ direction = \"r\" })")
          ]
          [
            "SUPER + SHIFT + H"
            (mkDsp "window.swap({ direction = \"l\" })")
          ]
          [
            "SUPER + SHIFT + J"
            (mkDsp "window.swap({ direction = \"d\" })")
          ]
          [
            "SUPER + SHIFT + K"
            (mkDsp "window.swap({ direction = \"u\" })")
          ]
          [
            "SUPER + SHIFT + L"
            (mkDsp "window.swap({ direction = \"r\" })")
          ]

          # Workspace navigation
          [
            "SUPER + SHIFT + mouse_down"
            (mkDsp "focus({ workspace = \"e-1\" })")
          ]
          [
            "SUPER + SHIFT + mouse_up"
            (mkDsp "focus({ workspace = \"e+1\" })")
          ]
          [
            "SUPER + P"
            (mkDsp "focus({ workspace = \"r-1\" })")
          ]
          [
            "SUPER + N"
            (mkDsp "focus({ workspace = \"r+1\" })")
          ]

          # Media and Brightness Keys
          [
            "XF86MonBrightnessUp"
            (mkDspExec "noctalia msg brightness-up")
            {
              repeating = true;
              locked = true;
            }
          ]
          [
            "XF86MonBrightnessDown"
            (mkDspExec "noctalia msg brightness-down")
            {
              repeating = true;
              locked = true;
            }
          ]
          [
            "XF86AudioRaiseVolume"
            (mkDspExec "noctalia msg volume-up")
            {
              repeating = true;
              locked = true;
            }
          ]
          [
            "XF86AudioLowerVolume"
            (mkDspExec "noctalia msg volume-down")
            {
              repeating = true;
              locked = true;
            }
          ]
          [
            "XF86AudioMute"
            (mkDspExec "noctalia msg volume-mute")
            { locked = true; }
          ]
          [
            "XF86AudioPlay"
            (mkDspExec "noctalia msg media toggle")
            { locked = true; }
          ]
          [
            "XF86AudioPrev"
            (mkDspExec "noctalia msg media previous")
            { locked = true; }
          ]
          [
            "XF86AudioNext"
            (mkDspExec "noctalia msg media next")
            { locked = true; }
          ]

          # Other shortcuts
          [
            "SUPER + SHIFT + S"
            (mkDspExec "noctalia msg screenshot-region")
          ]
        ]
        # Appending the dynamically generated workspace sets (1-10 and 11-20)
        ++ (concatLists (
          genList (
            i:
            let
              key = toString (mod (i + 1) 10);
              wsIdx = toString (i + 1);
            in
            [
              [
                "SUPER + ${key}"
                (mkDsp "focus({ workspace = \"${wsIdx}\" })")
              ]
              [
                "SUPER + SHIFT + ${key}"
                (mkDsp "window.move({ workspace = \"${wsIdx}\" })")
              ]
            ]
          ) 10
        ))
      );
    };
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
