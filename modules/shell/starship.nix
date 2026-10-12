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
          invert = true;
        }} )";
      };
      git_branch = {
        symbol = "";
        format = "(${pills.starship.mkSplitPill {
          icon = "$symbol";
          text = "$branch";
          accent = "cyan";
          textBg = "bright-white";
          invert = true;
        }} )";
      };
      git_status = {
        format = "(${pills.starship.mkSplitPill {
          icon = "󱈸";
          text = "$all_status$ahead_behind";
          accent = "bright-yellow";
          textBg = "black";
          textFg = "white";
          invert = true;
        }} )";
        staged = "[+ ](fg:green bg:black)";
        modified = "[! ](fg:yellow bg:black)";
        renamed = "[» ](fg:blue bg:black)";
        deleted = "[- ](fg:red bg:black)";
        untracked = "[? ](fg:red bg:black)";
        stashed = "[≡ ](fg:purple bg:black)";
        conflicted = "[✖ ](fg:red bg:black bold)";
        ahead = "[⇡$count ](fg:cyan bg:black)";
        behind = "[⇣$count ](fg:bright-red bg:black)";
        diverged = "[⇕⇡$ahead_count⇣$behind_count ](fg:bright-purple bg:black)";
      };
    };
  };
}
