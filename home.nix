{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [ ./modules ];
  home.username = "hollowheap";
  home.homeDirectory = "/home/hollowheap";
  home.stateVersion = "26.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    # development
    gcc
    gdb
    uv
    # desktop apps
    nautilus
    modrinth-app
    # services
    # pass-git-helper
    # shell plugins
    zinit
    zsh-autosuggestions
    zsh-fast-syntax-highlighting
    zsh-you-should-use
    zsh-fzf-tab
    # fonts
    noto-fonts
    noto-fonts-color-emoji
    nerd-fonts.victor-mono
    # utilities
    tmux
    satty
    wl-clipboard
  ];

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentry = {
      package = pkgs.pinentry-gnome3;
      program = "pinentry-gnome3";
    };
  };
  services.playerctld.enable = true;

  # system services
  programs.gpg.enable = true;

  programs.btop.enable = true;
  programs.btop.settings.color_theme = "noctalia";

  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings.theme = "noctalia";
  };

  programs.yazi.enable = true;
  programs.ripgrep.enable = true;
  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [
      batdiff
      batman
      batgrep
      batpipe
    ];
  };

  programs.tealdeer = {
    enable = true;
    settings.updates.auto_update = true;
  };

  programs.starship = {
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

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [
      "--cmd cd"
    ];
  };
  programs.eza.enable = true;
  programs.fzf.enable = true;

  # TODO: Move to programs/*.nix
  programs.thunderbird = {
    profiles = { };
    enable = true;
  };
  programs.vesktop.enable = true;
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
    ];
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
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

  home.sessionVariables = {
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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
