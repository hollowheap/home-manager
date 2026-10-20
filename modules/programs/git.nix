{ config, pkgs, ... }:
{
  programs.git = {
    enable = true;
    includes = [
      { path = config.sops.templates."gitconfig".path; }
    ];
    signing = {
      key = null;
      signByDefault = true;
    };
    settings = {
      commit.gpgSign = true;
      tag.gpgSign = true;
      alias = {
        i = "init";
        cl = "clone";

        s = "status";
        d = "diff";

        a = "add";
        ap = "add --patch";
        c = "commit";
        st = "stash";

        f = "fetch";
        p = "push";
        u = "pull";

        co = "checkout";
        br = "branch";

        rb = "rebase";

        l = "log";
        rl = "reflog";
      };
      core = {
        sshCommand = "ssh -o IdentityAgent=\"\${XDG_RUNTIME_DIR:-/run/user/1000}/rbw/ssh-agent-socket\"";
        preloadIndex = true;
        whitespace = "error";
      };
      init.defaultBranch = "main";
      diff = {
        interHunkContext = 10;
        renames = "copies";
      };
      status = {
        branch = true;
        short = true;
        showStash = true;
      };
      user = {
        name = "Yucky Hito";
      };
      url = {
        "https://github.com/" = {
          insteadOf = [
            "gh:"
          ];
        };
        "git@github.com:" = {
          insteadOf = [
            "gh@:"
          ];
        };
      };
      credential = {
        helper = [
          "cache"
          "${pkgs.rbw}/bin/git-credential-rbw"
        ];
      };
    };
  };
}
