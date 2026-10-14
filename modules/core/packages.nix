{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Development & AI Code Indexing
    gcc
    gdb
    uv
    nodejs
    ast-grep
    universal-ctags
    tree-sitter
    repomap
    hollowheap-colorscript
    hollowpi-colorscript

    # Desktop Applications
    nautilus
    steam
    pear-desktop
    zoom-us
    libreoffice
    prismlauncher
    telegram-desktop
  ];
}
