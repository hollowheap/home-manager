{ lib, ... }:
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      format = lib.concatStrings [
        "$username"
        "$directory"
        "$fill"
        "$cmd_duration"
        "$all"
      ];
      add_newline = false;
      fill.symbol = " ";
    };
  };
}
