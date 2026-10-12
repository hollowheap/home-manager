{ lib, ... }:
let
  noRuntimeModules = [
    "buf"
    "bun"
    "c"
    "cmake"
    "cobol"
    "cpp"
    "crystal"
    "daml"
    "dart"
    "deno"
    "dotnet"
    "elixir"
    "elm"
    "erlang"
    "fennel"
    "fortran"
    "gleam"
    "golang"
    "gradle"
    "haskell"
    "haxe"
    "helm"
    "java"
    "julia"
    "kotlin"
    "lua"
    "maven"
    "meson"
    "mojo"
    "nim"
    "nodejs"
    "ocaml"
    "odin"
    "opa"
    "perl"
    "php"
    "pixi"
    "pulumi"
    "purescript"
    "python"
    "quarto"
    "raku"
    "red"
    "rlang"
    "ruby"
    "rust"
    "scala"
    "solidity"
    "swift"
    "typst"
    "vagrant"
    "vlang"
    "xmake"
    "zig"
  ];

  runtimePillSettings = lib.genAttrs noRuntimeModules (_: {
    format = "via []($style)[$symbol](bg:prev_fg fg:black)[](prev_bg) ";
  });
in
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = runtimePillSettings // {
      format = lib.concatStrings [
        "$username"
        "$directory"
        "$character"
      ];
      right_format = "$git_branch$git_status$nix_shell$cmd_duration$all";
      add_newline = false;
      fill.symbol = " ";
      line_break.disabled = true;

      character = {
        format = "$symbol ";
        success_symbol = "[◎](bold italic bright-yellow)";
        error_symbol = "[○](italic purple)";
        vimcmd_symbol = "[■](italic dimmed green)";
      };

      directory = {
        style = "bright-blue";
        format = "[]($style)[󰉋 ](bg:prev_fg fg:black)[ $path](bg:bright-white fg:black)[$read_only](bg:bright-white fg:bright-red)[](prev_bg) ";
        truncation_length = 4;
        read_only = " 󰌾";
      };

      git_branch = {
        symbol = " ";
        format = "on [](cyan)[$symbol](bg:prev_fg fg:black)[ $branch](bg:bright-white fg:black)[](prev_bg) ";
      };

      git_status = {
        format = "([](bright-yellow)[󱈸 ](bg:prev_fg fg:black)[ $all_status$ahead_behind](bg:bright-white fg:black)[](prev_bg) )";
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

      cmd_duration = {
        min_time = 2000;
        format = "took [](bright-blue)[󱑂 ](bg:prev_fg fg:black)[ $duration](bg:bright-white fg:black)[](prev_bg) ";
      };

      nix_shell = {
        symbol = " ";
        format = "via [](blue)[$symbol](bg:prev_fg fg:black)[ $state](bg:bright-white fg:black)[](prev_bg) ";
      };

      package = {
        symbol = "󰏗 ";
        format = "is [](purple)[$symbol](bg:prev_fg fg:black)[](prev_bg) ";
      };
    };
  };
}
