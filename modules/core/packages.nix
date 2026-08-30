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
    chromium
    steam
    pear-desktop

    # Utilities
    tmux
    satty
    tdf
    jq
    ddcutil
  ];
}
