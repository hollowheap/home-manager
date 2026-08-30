{ pkgs, ... }:
{
  programs.btop = {
    enable = true;
    package = pkgs.btop-cuda;
    settings.color_theme = "noctalia";
  };
}
