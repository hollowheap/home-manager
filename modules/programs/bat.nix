{ pkgs, ... }:
{
  programs.bat = {
    enable = true;
    config = {
      theme = "wallust";
    };
    extraPackages = with pkgs.bat-extras; [
      batdiff
      batman
      batgrep
      batpipe
    ];
  };
}
