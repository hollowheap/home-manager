{ lib, ... }:
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      format = lib.concatStrings [
        "$username"
        "$directory"
        "$git_branch"
        "$git_status"
        "$character"
        # "$all"
      ];
      right_format = "$cmd_duration$all";
      add_newline = false;
      fill.symbol = " ";
      line_break.disabled = true;
      character = {
        success_symbol = "[λ ::](bold green)";
        error_symbol = "[✘ ::](bold red)";
        vimcmd_symbol = "[ ::](bold green)";
      };
      directory = {
        style = "cyan";
        format = "[➜](bold)[ $path ]($style)";
        truncation_length = 4;
      };
      git_branch = {
        symbol = " ";
        style = "fg:black bg:cyan";
        format = "on [](cyan)[$symbol$branch]($style)[](prev_bg) ";
      };
      git_status = {
        format = "[$untracked$staged$modified$renamed$conflicted$ahead_behind ](style)";
        # options available for format
        staged     = "[+](green)";
        modified   = "[!](yellow)";
        renamed    = "[»](blue)";
        deleted    = "[-](red)";
        untracked  = "[?](red)";
        stashed    = "[≡](purple)";
        conflicted = "[✖](red bold)";

        ahead      = "[⇡$count](cyan)";
        behind     = "[⇣$count](bright-red)";
        diverged   = "[⇕⇡$ahead_count⇣$behind_count](bright-purple)";
      };
    };
  };
}
