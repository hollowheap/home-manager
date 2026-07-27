{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [ ./modules ];

  home = {
    packages = with pkgs; [
      # development
      gcc
      gdb
      uv
      # desktop apps
      nautilus
      # modrinth-app
      # services
      # pass-git-helper
      # fonts
      noto-fonts
      noto-fonts-color-emoji
      nerd-fonts.victor-mono
      # utilities
      tmux
      satty
      wl-clipboard
      tdf
      jq
      pear-desktop
    ];

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    file = {
      # # Building this configuration will create a copy of 'dotfiles/screenrc' in
      # # the Nix store. Activating the configuration will then make '~/.screenrc' a
      # # symlink to the Nix store copy.
      # ".screenrc".source = dotfiles/screenrc;

      # # You can also set the file content immediately.
      # ".gradle/gradle.properties".text = ''
      #   org.gradle.console=verbose
      #   org.gradle.daemon.idletimeout=3600000
      # '';

      # ".config/pass-git-helper/git-pass-mapping.ini".text = ''
      #   [DEFAULT]
      #   username_extractor=regex_search
      #   regex_username=^user: (.*)$
      #   [github.com*]
      #   target=dev/github
      # '';
    };

    sessionVariables = {
      LIBVA_DRIVER_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      NVD_BACKEND = "direct";

      XDG_SESSION_TYPE = "wayland";
      GDK_BACKEND = "wayland,x11";
      QT_QPA_BACKEND = "wayland;xcb";
      SDL_BACKEND = "wayland";
      CLUTTER_BACKEND = "wayland";

      QT_QPA_PLATFORMTHEME = "qt6ct";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

      _ZO_ECHO = "1";
    };

    pointerCursor.enable = true;
  };

  services = {
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      pinentry = {
        package = pkgs.pinentry-gnome3;
        program = "pinentry-gnome3";
      };
    };
    playerctld.enable = true;
  };

  programs = {
    gpg.enable = true;

    btop = {
      enable = true;
      package = pkgs.btop-cuda;
      settings.color_theme = "noctalia";
    };

    antigravity-cli.enable = true;
    # gemini-cli.enable = true;
    yazi.enable = true;
    bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [
        batdiff
        batman
        batgrep
        batpipe
      ];
    };

    lazygit.enable = true;
    lazygit.enableZshIntegration = true;

    tealdeer = {
      enable = true;
      settings.updates.auto_update = true;
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        format = lib.concatStrings [
          "$username"
          "$directory"
          "$fill"
          "$cmd_duration"
          "$all"
        ];
        add_newline = false;
        fill.symbol = " ";
      };
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [
        "--cmd cd"
      ];
    };
    eza.enable = true;
    ripgrep.enable = true;
    fd.enable = true;
    delta.enable = true;
    delta.enableGitIntegration = true;
    fzf.enable = true;

    ghostty = {
      enable = true;
      enableZshIntegration = true;
      settings.theme = "noctalia";
    };

    vicinae = {
      enable = true;
    };

    # TODO: Move to programs/*.nix
    thunderbird = {
      profiles = { };
      enable = true;
    };

    vesktop = {
      enable = true;
      vencord.settings = {
        enabledThemes = [
          "noctalia.theme"
          # "noctalia-material.theme"
        ];
        frameless = true;
        transparent = true;
        plugins = {
          AlwaysAnimated.enabled = true;
          Experimentals.enabled = true;
          FakeNitro.enabled = true;
          FakeProfileThemes.enabled = true;
        };
      };

      settings = {
        discordBranch = "stable";
        minimizeToTray = true;
        arRpc = true;
        hardwareAcceleration = true;
        hardwareVideoAcceleration = true;
      };
    };

    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
      ];
    };

    # Let Home Manager install and manage itself.
    home-manager.enable = true;
  };

  fonts.fontconfig = {
    enable = true;
    antialiasing = true;
    hinting = "full";
    subpixelRendering = "rgb";
  };

  gtk = {
    enable = true;
    colorScheme = "dark";
  };

  qt.enable = true;

  xdg.configFile."uwsm/env".source =
    "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
}
