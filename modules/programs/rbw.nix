{ pkgs, ... }:

{
  programs.rbw = {
    enable = true;
    settings = {
      email = "yuckychong@gmail.com";
      base_url = "https://vault.hollowheap.duckdns.org";
      lock_timeout = 86400; # 24 hours in seconds
      pinentry = pkgs.pinentry-gnome3;
    };
  };

  home.sessionVariables = {
    SSH_AUTH_SOCK = "\${XDG_RUNTIME_DIR}/rbw/ssh-agent-socket";
  };
}
