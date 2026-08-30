{ ... }:
{
  programs = {
    eza.enable = true;
    ripgrep.enable = true;
    fd.enable = true;
    fzf.enable = true;

    delta = {
      enable = true;
      enableGitIntegration = true;
    };
  };
}
