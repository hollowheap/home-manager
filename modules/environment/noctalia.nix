{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    pwvucontrol
    brightnessctl
    cliphist
    matugen
  ];

  programs.quickshell.enable = true;
  programs.noctalia-shell = {
    enable = true;
    systemd.enable = true;
  };
  programs.noctalia-shell.settings = {
    appLauncher = {
      enableClipboardHistory = true;
      terminalCommand = "ghostty -e";
    };
    audio = {
      externalMixer = "pwvucontrol";
      visualizerType = "wave";
      visualizerQuality = "low";
    };
    bar = {
      density = "comfortable";
      floating = true;
      position = "right";
      showCapsule = true;
      widgets = {
        left = [
          {
	    id = "ControlCenter";
	    colorizeSystemIcon = "primary";
	    enableColorization = true;
	    useDistroLogo = true;
	  }
	  {
	    id = "Clock";
	    formatHorizontal = "HH:mm - dd/MM";
	    formatVertical = "HH mm - dd MM";
	  }
	  {
	    id = "MediaMini";
	    showAlbumArt = true;
	  }
	  {
	    id = "AudioVisualizer";
	    hideWhenIdle = true;
	    width = 100;
	  }
        ];
        center = [
          {
            id = "Workspace";
	    followFocusedScreen = true;
            hideUnoccupied = false;
            labelMode = "none";
          }
        ];
        right = [
	  { id = "KeyboardLayout"; }
          {
            alwaysShowPercentage = false;
            id = "Battery";
            warningThreshold = 30;
          }
	  {
	    id = "NotificationHistory";
	    showUnreadBadge = false;
	  }
	  { id = "Tray"; colorizeIcons = true; }
        ];
      };
    };
    colorSchemes = {
      darkMode = config.gtk.colorScheme == "dark";
      matugenSchemeType = "scheme-fidelity";
      useWallpaperColors = true;
    };
    dock.enabled = false;
    general = {
      shadowDirection = true;
    };
    location.name = "Singapore, Singapore";
    osd.location = "bottom";
    sessionMenu.countdownDuration = 5000;
    templates = {
      enableUserTemplates = true;
      cava = true;
      ghostty = true;
      gtk = true;
      niri = true;
      qt = true;
      spicetify = true;
    };
    ui = {
      fontDefault = "Sans Serif";
      fontFixed = "Monospace";
      panelsAttachedToBar = true;
    };
    wallpaper = {
      hideWallpaperFilenames = true;
      randomEnabled = true;
      randomIntervalSec = 300;
      recursiveSearch = true;
      transitionType = "fade";
    };
  };
}
