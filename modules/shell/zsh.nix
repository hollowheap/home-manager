{ config, pkgs, ... }:
let
  inherit (pkgs.lib) mkOrder;
in
{
  home.shellAliases = {
    "_" = "sudo ";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    bd = ''cd "$OLDPWD"'';
    cp = "cp -iv";
    mv = "mv -iv";
    md = "mkdir -pv";
    rmd = "rm -rf";

    eza = "eza --git-ignore --icons=auto -o";

    l = "eza";
    ll = "l -lh";
    la = "ll -A";

    # tree view
    l1 = "la -TL 1";
    l2 = "la -TL 2";
    l3 = "la -TL 3";
    l4 = "la -TL 4";
    l5 = "la -TL 5";
    l6 = "la -TL 6";
    l7 = "la -TL 7";
    l8 = "la -TL 8";
    l9 = "la -TL 9";
    l0 = "la -TL 10";

    nv = "nvim";
    g = "git";
    sc = "systemctl";
    scu = "sc --user";

    nixos-up = "sudo nixos-rebuild switch";
    nixos-up-flake = "sudo nixos-rebuild switch --flake .";
    nixos-gc = "sudo nix-collect-garbage -d";

    hm = "home-manager";
    hm-up = "hm switch";
    hm-up-flake = "hm switch --flake .";
    hm-gc = ''hm expire-generations "-3 days"'';
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    defaultKeymap = "viins";
    autocd = true;
    history = {
      append = true;
      share = true;
      ignoreSpace = true;
      ignoreDups = true;
      saveNoDups = true;
      findNoDups = true;
      save = 10000;
      size = 10000;
    };

    syntaxHighlighting.enable = false;
    autosuggestion.enable = false;
    historySubstringSearch.enable = false;

    shellGlobalAliases = {
      NE = "2> /dev/null";
      DN = "> /dev/null";
      NUL = "> /dev/null 2>&1";
      JQ = "| jq";
      F = "| $FUZZY"; # TODO install fzf
      L = "| $PAGER";
      D = "| delta"; # TODO install delta
      C = "| bat";
      H = "| head";
      T = "| tail";
      G = "| rg";
    };

    completionInit = ''
      autoload -U compinit
      compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
    '';

    initContent =
      let
        zshEarlyInit = mkOrder 500 "";
        zshBeforeCompinit = mkOrder 550 ''
          source "${pkgs.zinit}/share/zinit/zinit.zsh"
        '';
        zshConfig =
          with pkgs;
          mkOrder 1000 ''
                    (( ''${+functions[zinit-cdreplay]} )) && zinit-cdreplay -q

            	zinit ice wait"0a" lucid nocompile
            	zinit light "${zsh-fzf-tab}/share/fzf-tab"

            	zinit ice wait"0b" lucid nocompile
              zinit light "${zsh-you-should-use}/share/zsh/plugins/you-should-use"

            	zinit ice wait"0c" lucid atload"_zsh_autosuggest_start" nocompile
            	zinit light "${zsh-autosuggestions}/share/zsh/plugins/zsh-autosuggestions"
              
              zinit ice wait"0d" lucid nocompile
              zinit light "${zsh-history-substring-search}/share/zsh/plugins/zsh-history-substring-search"

            	zinit ice wait"0e" lucid nocompile
              zinit light "${zsh-fast-syntax-highlighting}/share/zsh/plugins/fast-syntax-highlighting"

            	unsetopt MENU_COMPLETE
              unsetopt FLOWCONTROL
              unsetopt CASE_GLOB
              setopt AUTO_MENU
              setopt AUTO_LIST
              setopt AUTO_PARAM_SLASH
              setopt EXTENDED_GLOB
              setopt PATH_DIRS
              setopt COMPLETE_IN_WORD
              setopt ALWAYS_TO_END

            	# Common settings
              zstyle ':completion:*' group-name ""
              zstyle ':completion:*' verbose yes
              zstyle ':completion:*' completer _complete _match _approximate
            	zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS} # Enable list colors
              zstyle ':completion:*' list-prompt '%S%M matches %s'

            	# Cache
            	zstyle ':completion:*' use-cache on
              zstyle ':completion:*' cache-path "${config.xdg.cacheHome}/zsh/.zcompcache"

            	# Completion formatting
              zstyle ':completion:*' format '[%d]'
              zstyle ':completion:*:options' auto-description '%d'
              zstyle ':completion:*:corrections' format '[%d errors: %e]'
              zstyle ':completion:*:warnings' format 'no matches'

            	# Smart error correction
              zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3>7?7:($#PREFIX+$#SUFFIX)/3))numeric)'

            	# Hide internal functions
              zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'
              
            	# Array index completion
              zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

            	# Prioritize directories over users
              zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
              
            	# Disable sorting and ignore current branch for checkout
              zstyle ':completion:*:git-checkout:*' sort false
            	zstyle ':completion:*:git-checkout:*' ignore-line yes
            	zstyle ':completion:*:git-*' verbose yes

            	# Don't autocomplete what's already inputed
              zstyle ':completion:*:(rm|kill|diff):*' ignore-line other

            	# Show all files fro rm
              zstyle ':completion:*:rm:*' file-patterns '*:all-files'
              
            	# Show my processes, color PIDs, and insert PID number
              zstyle ':completion:*:*:*:*:processes' command 'ps -u $USER -o pid,user,command -w'
              zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;36=0=01'
              zstyle ':completion:*:*:kill:*' force-list always
              zstyle ':completion:*:*:kill:*' insert-ids single
                    
            	# Separate sections and auto insert numbers
              zstyle ':completion:*:manuals' separate-sections true
              zstyle ':completion:*:manuals.(^1*)' insert-sections true

              zstyle ':fzf-tab:*' fzf-flags \
                --height=50% \
            	  --layout=reverse \
                --border=rounded \
                --border-label=" Completions " \
                --border-label-pos=0 \
                --preview-window='right:50%,border-rounded' \
                --prompt="❯ " \
                --marker="❯" \
                --pointer="❯" \
                # --colors='bg+:-1,fg+:11,hl+:14,header:2,marker:9,spinner:10'

            	# cd preview
            	zstyle ':fzf-tab:complete:(cd|z|__zoxide+z):*' fzf-preview \
            	  'eza -lAh1 --color=always $realpath | bat'
            	# ps/kill preview
            	zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
                '[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'
            	# Environment variable preview
            	zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' \
            	fzf-preview 'echo ''${(P)word}'

            	zstyle ':fzf-tab:complete:*:*' fzf-preview 'batpipe $realpath'

            	bindkey "^[OA" fzf-history-widget
            	bindkey "^[OB" fzf-history-widget
            	bindkey "^[[1;5D" vi-backward-word
              bindkey "^[[1;5C" vi-forward-word
            	bindkey "^[[1;6D" vi-backward-word
              bindkey "^[[1;6C" vi-forward-word
              bindkey "^[[1~" vi-beginning-of-line
              bindkey "^[[4~" vi-end-of-line
              bindkey "^[?" run-help

              bindkey "^K" kill-line

            	bindkey -M vicmd 'k' history-substring-search-up
              bindkey -M vicmd 'j' history-substring-search-down

              (( ''${+commands[fastfetch]} )) && fastfetch
          '';
      in
      pkgs.lib.mkMerge [
        zshEarlyInit
        zshBeforeCompinit
        zshConfig
      ];
  };
}
