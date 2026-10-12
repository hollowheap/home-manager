{
  lib,
  config,
  ...
}:
let
  pills = config.styles.pills;
in
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      format = lib.concatStrings [
        "$username"
        "$directory"
        "$character"
      ];
      right_format = lib.concatStrings [
        "$cmd_duration"
        "$git_branch"
        "$git_status"
      ];
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
      cmd_duration = {
        min_time = 2000;
        format = "(${pills.starship.mkSplitPill {
          icon = "󱑂";
          text = "$duration";
          accent = "bright-blue";
          textBg = "bright-white";
        }} )";
      };
      git_branch = {
        symbol = "";
        format = "(${pills.starship.mkSplitPill {
          icon = "$symbol";
          text = "$branch";
          accent = "cyan";
          textBg = "bright-white";
        }} )";
      };
      git_status = {
        format = "(${pills.starship.mkSplitPill {
          icon = "󱈸";
          text = "$all_status$ahead_behind";
          accent = "bright-yellow";
          textBg = "bright-white";
        }} )";
        staged = "[+](green)";
        modified = "[!](yellow)";
        renamed = "[»](blue)";
        deleted = "[-](red)";
        untracked = "[?](red)";
        stashed = "[≡](purple)";
        conflicted = "[✖](red bold)";

        ahead = "[⇡$count](cyan)";
        behind = "[⇣$count](bright-red)";
        diverged = "[⇕⇡$ahead_count⇣$behind_count](bright-purple)";
      };
    };
  };
}
