{ pkgs, ... }:
{
  programs = {
    eza.enable = true;
    ripgrep.enable = true;
    fd.enable = true;
    fzf = {
      enable = true;
      tmux = {
        enableShellIntegration = true;
        shellIntegrationOptions = [ "-p 75%,65%" ];
      };
      defaultOptions = [
        "--tmux=center,75%,65%"
        "--layout=reverse"
        "--border=rounded"
        "--prompt='❯ '"
        "--marker='❯'"
        "--pointer='❯'"
      ];
      historyWidget.options = [
        "--border-label=' History '"
        "--border-label-pos=0"
        "--prompt=' History ❯ '"
      ];
      fileWidget.options = [
        "--border-label=' Files '"
        "--border-label-pos=0"
        "--prompt=' Files ❯ '"
      ];
      changeDirWidget.options = [
        "--border-label=' Directories '"
        "--border-label-pos=0"
        "--prompt=' Directories ❯ '"
      ];
    };
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
