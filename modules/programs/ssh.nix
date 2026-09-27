{ ... }:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        IdentityAgent = "/run/user/%u/rbw/ssh-agent-socket";
      };
    };
  };
}
