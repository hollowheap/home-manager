{ config, pkgs, ... }: let
  inherit (builtins) stringLength;
  inherit (pkgs.lib.strings) replicate;
in {
  imports = [ ./modules ];
  home.username = "yuckyh";
  home.homeDirectory = "/home/yuckyh";
  home.stateVersion = "25.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    # development
    gcc
    gdb
    uv
    # fonts
    nerd-fonts.victor-mono
    noto-fonts
    noto-fonts-color-emoji
    # desktop apps
    nautilus
    # services
    pass-git-helper
    # shell plugins
    zinit
    zsh-autosuggestions
    zsh-fast-syntax-highlighting
    zsh-you-should-use
    zsh-fzf-tab
    # cli tools
    spicetify-cli
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
  # services.noctalia-shell.enable = true;

  # system services
  programs.gpg.enable = true;

  # TODO: Organize for cli tools.
  programs.git = {
    enable = true;
    settings = {
      alias = {
        i = "init";
	cl = "clone";

	s = "status";
	d = "diff";

        a = "add";
	ap = "add --patch";
        c = "commit";
	st = "stash";

	f = "fetch";
	p = "push";
	u = "pull";

	co = "checkout";
	br = "branch";

	rb = "rebase";

	l = "log";
	rl = "reflog";
      };
      core = {
        preloadIndex = true;
        whitespace = "error";
      };
      init.defaultBranch = "main";
      diff = {
        interHunkContext = 10;
        renames = "copies";
      };
      # pager = {
      #   diff = "diff-so-fancy | $PAGER";
      # };
      # "diff-so-fancy" = {
      #   markEmptyLines = false;
      # };
      color = {
        "diff" = {
	  meta = "black bold";
	  frag = "magenta";
	  context = "white";
	  whitespace = "yellow reverse";
	  old = "red";
	};
      };
      status = {
        branch = true;
        short = true;
	showStash = true;
      };
      user = {
        name = "Yucky Hito";
        email = "yuckychong@gmail.com";
      };
      url = {
        "https://github.com/" = {
          insteadOf = [ "gh@" "github@" ];
        };
	"git@github.com:" = {
	  insteadOf = [ "gh:" "github:" ];
          # pushInsteadOf = "https://github.com/";
        };
      };
      credential.helper = [
        "cache"
        "!type pass-git-helper >/dev/null && pass-git-helper $@"
      ];
    };
  };
  programs.neovim.enable = true;
  programs.yazi.enable = true;
  programs.btop.enable = true;
  programs.password-store.enable = true;
  programs.ripgrep.enable = true;
  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [
      batdiff batman batgrep batpipe
    ];
  };

  programs.tealdeer.enable = true;
  programs.tealdeer.settings = {
    updates.auto_update = true;
  };

  programs.fastfetch.enable = true;
  programs.fastfetch.settings = let
    padRight = len: filler: str: let
      needed = len - stringLength str;
    in if needed > 0 then str + replicate needed filler else str;
    mkField = color: icon: field: type: opts: let
      colorCode = toString (color + 30);
      paddedField = padRight 9 " " field;
    in {
      key = "│ {#${colorCode}}${icon} ${paddedField}{#keys}│";
      inherit type;
    } // opts;
  in {
    logo.type = "none";
    display = {
      separator = " ";
      key = { width = 16; type = "string"; };
      constants = ["────────────"];
      percent = { type = ["bar"]; };
      bar = { width = 16; };
    };
    modules = [
      { key = "╭{$1}╮"; type = "custom"; }
      (mkField 1 "{icon}" "os" "os" {})
      (mkField 2 "" "kernel" "kernel" {})
      (mkField 3 "" "packages" "packages" {})
      (mkField 4 "󰝚" "media" "media" {})
      (mkField 5 "󰩟" "network" "localip" { format = "{ipv4} ({ifname})"; })
      { key = "├{$1}┤"; type = "custom"; }
      (mkField 1 "" "user" "title" { format = "{user-name-colored}"; })
      (mkField 2 "" "host" "title" { format = "{host-name-colored}"; })
      (mkField 3 "󰅐" "uptime" "uptime" {})
      { key = "├{$1}┤"; type = "custom"; }
      (mkField 6 "" "wm" "wm" {})
      (mkField 1 "󰉼" "theme" "theme" {})
      (mkField 2 "" "icons" "icons" {})
      (mkField 4 "" "term" "terminal" {})
      (mkField 5 "" "shell" "shell" {})
      { key = "├{$1}┤"; type = "custom"; }
      (mkField 1 "󰍛" "cpu" "cpu" { showPeCoreCount = true; })
      (mkField 2 "󰾲" "gpu" "gpu" {})
      (mkField 3 "" "disk" "disk" { folders = "/"; bar = true; })
      (mkField 4 "" "memory" "memory" {})
      (mkField 5 "󰓡" "swap" "swap" {})
      { key = "├{$1}┤"; type = "custom"; }
      (mkField 9 "" "colors" "custom" {
        format = "\t{#90} {#31} {#32} {#33} {#34} {#35} {#36} {#37} {#38} {#39}    {#38} {#37} {#36} {#35} {#34} {#33} {#32} {#31} {#90}";
      })
      { key = "╰{$1}╯";	type = "custom"; }
      ];
  };

  # TODO: move shell stuff to shell.nix or shell/*.nix
  programs.starship.enable = true;
  programs.starship.enableZshIntegration = true;
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
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      font-family = "VictorMono Nerd Font Mono";
      font-size = 14;
      theme = "noctalia";
    };
  };
  programs.zed-editor.enable = true;
  programs.thunderbird = {
    profiles = {};
    enable = true;
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

    ".config/pass-git-helper/git-pass-mapping.ini".text = ''
      [DEFAULT]
      username_extractor=regex_search
      regex_username=^user: (.*)$
      [github.com*]
      target=dev/github
    '';
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    _ZO_ECHO = "1";
  };

  home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 20;
  };

  fonts.fontconfig = {
    enable = true;
    antialiasing = true;
    hinting = "full";
    subpixelRendering = "rgb";
    defaultFonts = {
      emoji = [ "Noto Color Emoji" ];
      monospace = [ "VictorMono NFM" ];
      sansSerif = [ "Noto Sans" ];
      serif = [ "Noto Serif" ];
    };
  };

  gtk = {
    enable = true;
    colorScheme = "dark";
    theme = {
      name = "Orchis-Dark";
      package = pkgs.orchis-theme;
    };
    iconTheme = {
      name = "Tela-circle-black";
      package = pkgs.tela-circle-icon-theme;
    };
  };

  qt = {
    enable = true;
    style = {
      name = "kvantum";
      package = pkgs.libsForQt5.qtstyleplugin-kvantum;
    };
  };

  xdg.configFile."uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
