{ pkgs, ... }:
{
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentry = {
      package = pkgs.pinentry-gnome3;
      program = "pinentry-gnome3";
    };
  };

  programs.rbw = {
    enable = true;
  };

  home.packages = [
    pkgs.gcr_3
    pkgs.pinentry-gnome3
  ];
}
