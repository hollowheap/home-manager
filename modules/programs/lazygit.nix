{ config, ... }:
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

  home.sessionVariables = {
    LG_CONFIG_FILE = "${config.xdg.configHome}/lazygit/config.yml,${config.xdg.configHome}/lazygit/theme.yml";
  };
}
