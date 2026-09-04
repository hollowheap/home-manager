{ ... }:
{
  programs.lazygit = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      git.diffRenderers = [
        {
          command = "delta --paging=never";
        }
      ];
    };
  };
}
