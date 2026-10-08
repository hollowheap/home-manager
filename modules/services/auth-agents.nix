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
    settings = {
      email = "yuckychong@gmail.com";
      base_url = "https://vault.hollowheap.duckdns.org";
      lock_timeout = 86400; # 24 hours in seconds
      pinentry = pkgs.pinentry-gnome3;
    };
  };

  home.packages = [
    pkgs.gcr_3
  ];
}
