{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Development
    gcc
    gdb
    uv
    nodejs

    # Desktop Applications
    nautilus
    # chromium
    steam
    pear-desktop
    zrythm
    zoom-us

    # Utilities
    satty
    tdf
    jq
    ddcutil
  ];
}
