{ config, pkgs, ... }:
{
  home.packages = [ pkgs.sops ];

  sops = {
    defaultSopsFile = ../../secrets.yaml;
    defaultSopsFormat = "yaml";
    gnupg.home = "${config.home.homeDirectory}/.gnupg";

    secrets = {
      "user/email" = { };
    };

    templates."gitconfig" = {
      path = "${config.xdg.configHome}/git/config.local";
      content = ''
        [user]
        	email = ${config.sops.placeholder."user/email"}
      '';
    };

    templates."rbw-config.json" = {
      path = "${config.xdg.configHome}/rbw/config.json";
      content = ''
        {
          "email": "${config.sops.placeholder."user/email"}",
          "base_url": "https://vault.mesh.hollowheap.duckdns.org",
          "lock_timeout": 86400,
          "pinentry": "${pkgs.pinentry-gnome3}/bin/pinentry"
        }
      '';
    };
  };
}
