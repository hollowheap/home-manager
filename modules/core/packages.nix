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

    # Desktop Applications
    nautilus
    steam
    pear-desktop
    zoom-us
    libreoffice
  ];
}
