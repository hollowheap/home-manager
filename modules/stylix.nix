{ pkgs, ... }:
{
  gtk = {
    theme = {
      name = "MacTahoe-Dark";
      package = pkgs.mactahoe-gtk-theme;
    };
  };

  stylix = {
    enable = true;
    autoEnable = false;

    image = pkgs.fetchurl {
      url = "https://getwallpapers.com/wallpaper/full/f/8/c/573277.jpg";
      hash = "sha256-WwgKYhGRFa9ZA4SyRyeG6U+OoBXIc8VhpUCI/NTybV4=";
    };
    polarity = "dark";

    targets = {
      fontconfig.enable = true;
      nvf.enable = true;
      nvf.transparentBackground = true;

      ghostty.enable = true;
      ghostty.colors.enable = false;
    };

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 20;
    };

    icons = {
      enable = true;
      package = pkgs.mactahoe-icon-theme;
      dark = "mactahoe-icon-theme-latest-dark";
      light = "mactahoe-icon-theme-latest-light";
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
