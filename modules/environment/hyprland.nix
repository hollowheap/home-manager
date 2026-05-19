{ config, lib, ... }: let
  inherit (builtins) concatLists genList;
  inherit (lib.trivial) mod;
in {
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    systemd.enable = false;
  };

  wayland.windowManager.hyprland.settings = {
    monitor = [ "eDP-1, highrr, auto, 1" ];
    bindel = [
      ", XF86MonBrightnessUp, exec, noctalia-shell ipc call brightness increase"
      ", XF86MonBrightnessDown, exec, noctalia-shell ipc call brightness decrease"
      ", XF86AudioRaiseVolume, exec, noctalia-shell ipc call volume increase"
      ", XF86AudioLowerVolume, exec, noctalia-shell ipc call volume decrease"
    ];
    bindl = [
      ", XF86AudioMute, exec, noctalia-shell ipc call volume muteOutput"
      ", XF86AudioPlay, exec, noctalia-shell ipc call media playPause"
      ", XF86AudioPrev, exec, noctalia-shell ipc call media previous"
      ", XF86AudioNext, exec, noctalia-shell ipc call media next"
    ];
    bindm = [
      # Window Management
      "SUPER, mouse:272, movewindow"
      "SUPER, mouse:273, resizewindow"
    ];
    bindc = [
      "SUPER, mouse:272, togglefloating"
    ];
    bind = [
      "SUPER, Return, exec, ghostty"
      "SUPER, M, fullscreen, 1" # Maximize
      "SUPER, F, fullscreen, 0" # Fullscreen
      "SUPER, Q, killactive,"
      "SUPER, V, exec, noctalia-shell ipc call launcher clipboard"
      "SUPER, Space, exec, noctalia-shell ipc call launcher toggle"
      "SUPER SHIFT, L, exec, noctalia-shell ipc call lockScreen lock"
      "SUPER SHIFT, L, exec, noctalia-shell ipc call lockScreen lock"

      # "SUPER SHIFT, S, exec, screenshot"

      # Window Navigation
      "SUPER, H, movefocus, l"
      "SUPER, J, movefocus, d"
      "SUPER, K, movefocus, u"
      "SUPER, L, movefocus, r"

      # Window Swapping
      "SUPER, S, swapsplit"
      "SUPER ALT, H, swapwindow, l"
      "SUPER ALT, J, swapwindow, d"
      "SUPER ALT, K, swapwindow, u"
      "SUPER ALT, L, swapwindow, r"

      # Workspace Navigation
      "SUPER, mouse_down, workspace, e-1"
      "SUPER, mouse_up, workspace, e+1"
      "SUPER, P, workspace, r-1"
      "SUPER, N, workspace, r+1"
    ] ++ (concatLists (genList (i: let
      key = toString (mod (i + 1) 10);
      workspaceIndex = toString (i + 1);
      workspaceIndexCont = toString (i + 11);
    in [
      "SUPER, ${key}, workspace, ${workspaceIndex}"
      "SUPER ALT, ${key}, workspace, ${workspaceIndexCont}"
      "SUPER SHIFT, ${key}, movetoworkspace, ${workspaceIndex}"
      "SUPER SHIFT ALT, ${key}, movetoworkspace, ${workspaceIndexCont}"
    ]) 10));
  };
}
