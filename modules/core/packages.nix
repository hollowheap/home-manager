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
    steam
    pear-desktop
    zrythm
    zoom-us
    libreoffice

    # Utilities
    satty
    tdf
    jq
    ddcutil
    harlequin
    moserial
  ];
}
