{ config, pkgs, ... }:
{
  home.packages = [ pkgs.sops ];

  sops = {
    defaultSopsFile = ../../secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    # age.sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];

    secrets = {
      # Boilerplate for future secrets:
      # "email/password" = { };
    };
  };
}
