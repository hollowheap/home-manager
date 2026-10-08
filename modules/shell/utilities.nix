{ pkgs, ... }:
{
  programs = {
    eza.enable = true;
    ripgrep.enable = true;
    fd.enable = true;
    fzf.enable = true;
    jq.enable = true;

    delta = {
      enable = true;
      enableGitIntegration = true;
    };
  };

  home.packages = with pkgs; [
    harlequin
    tdf
  ];
}
