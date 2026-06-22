{ pkgs, ... }:
{
  stylix = {
    enable = true;
    autoEnable = false;

    image = pkgs.fetchurl {
      url = "https://getwallpapers.com/wallpaper/full/f/8/c/573277.jpg";
      hash = "sha256-WwgKYhGRFa9ZA4SyRyeG6U+OoBXIc8VhpUCI/NTybV4=";
    };
    polarity = "dark";

    targets = {
      bat.enable = true;
      fontconfig.enable = true;
      fzf.enable = true;
      gtk.enable = true;
      nvf.enable = true;
      ghostty.enable = true;
      ghostty.colors.enable = false;
      tmux.enable = true;
      qt.enable = true;
      yazi.enable = true;
    };

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 20;
    };

    icons = {
      enable = true;
      package = pkgs.tela-circle-icon-theme;
      dark = "Tela-circle-standard";
      light = "Tela-circle-standard";
    };

    fonts = {
      packages = with pkgs; [
        noto-fonts
        noto-fonts-color-emoji
        nerd-fonts.victor-mono
      ];
      emoji.name = "Noto Color Emoji";
      monospace.name = "VictorMono NFM";
      sansSerif.name = "Noto Sans";
      serif.name = "Noto Serif";
    };
  };
}
