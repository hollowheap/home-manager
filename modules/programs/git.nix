{ ... }:
{
  programs.git.enable = true;
  programs.git.settings = {
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
      preloadIndex = true;
      whitespace = "error";
    };
    init.defaultBranch = "main";
    diff = {
      interHunkContext = 10;
      renames = "copies";
    };
    # pager = {
    #   diff = "diff-so-fancy | $PAGER";
    # };
    # "diff-so-fancy" = {
    #   markEmptyLines = false;
    # };
    color = {
      "diff" = {
        meta = "black bold";
        frag = "magenta";
        context = "white";
        whitespace = "yellow reverse";
        old = "red";
      };
    };
    status = {
      branch = true;
      short = true;
      showStash = true;
    };
    user = {
      name = "Yucky Hito";
      email = "yuckychong@gmail.com";
    };
    url = {
      "https://github.com/" = {
        insteadOf = [
          "gh@"
          "github@"
        ];
      };
      "git@github.com:" = {
        insteadOf = [
          "gh:"
          "github:"
        ];
        # pushInsteadOf = "https://github.com/";
      };
    };
    credential.helper = [
      "cache"
      "!type pass-git-helper >/dev/null && pass-git-helper $@"
    ];
  };
}
