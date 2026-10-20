{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) concatStringsSep mapAttrs mapAttrsToList;

  aiRender = config.ai.render;

  toolsFor =
    capabilities:
    let
      caps = capabilities;
    in
    {
      read = caps.read;
      grep = caps.read;
      glob = caps.read;
      list = caps.read;
      edit = caps.write;
      write = caps.write;
      bash = caps.execute;
      task = caps.delegate;
      webfetch = caps.web;
    };

  opencodeModel = "opencode/deepseek-v4.1-flash-free";

  modeFor =
    agent:
    if agent.role == "subagent" then
      "subagent"
    else if agent.mainAgent && agent.subagent then
      "all"
    else if agent.mainAgent then
      "primary"
    else
      "subagent";

  mkAgent =
    name: agent:
    let
      model = aiRender.modelFor "opencode" agent;
      effort = aiRender.effortFor "opencode" agent;
      tools = toolsFor agent.capabilities // {
        # Built-in question tool exists; gate it on the question skill like antigravity's ask_question.
        question = builtins.elem "question" agent.skills || builtins.elem "grill" agent.skills;
      };
      perms =
        if name == "scout" || name == "Scout" then ''
          permission:
            skill: "deny"
            bash:
              "repomap*": "allow"
              "rg*": "allow"
              "fd*": "allow"
              "nix eval*": "allow"
              "nix flake show*": "allow"
              "git status*": "allow"
              "git log*": "allow"
              "git diff*": "allow"
              "*": "deny"
        '' else if name == "code-reviewer" || name == "Code Reviewer" then ''
          permission:
            skill: "deny"
        '' else if name == "ask" then ''
          permission:
            task:
              scout: "allow"
              "*": "deny"
        '' else if agent.role == "primary" || agent.mainAgent then ''
          permission:
            task:
              general: "deny"
              explore: "deny"
        '' else "";
      toolsText = concatStringsSep "\n" (mapAttrsToList (tool: enabled: "  ${tool}: ${if enabled then "true" else "false"}") tools);
      effortLine = lib.optionalString (effort != null) "reasoningEffort: ${effort}\n";
    in
    ''
      ---
      description: ${builtins.toJSON agent.description}
      mode: ${modeFor agent}
      model: ${builtins.toJSON model}
      ${effortLine}tools:
      ${toolsText}
      ${perms}---

      ${aiRender.agentBodyFor "opencode" agent}
    '';

  mkSkill = aiRender.mkSkillDir { prefix = "opencode"; };

  context = aiRender.context "opencode";
in
{
  programs.opencode = {
    enable = true;
    package = pkgs.symlinkJoin {
      name = "opencode-wrapped";
      paths = [ pkgs.opencode ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/opencode \
          --set-default OPENCODE_CONFIG "${config.xdg.configHome}/opencode/home-manager.json" \
          --set-default OPENCODE_TUI_CONFIG "${config.xdg.configHome}/opencode/home-manager-tui.json" \
          --unset OPENCODE_API_KEY
      '';
    };
    mutableSettings = true;
    settings = {
      "$schema" = "https://opencode.ai/config.json";
      model = opencodeModel;
      small_model = opencodeModel;
      provider.opencode.env = [ ];
      agent.general.disable = true;
      agent.explore.disable = true;
      permission = {
        task = {
          general = "deny";
          explore = "deny";
        };
      };
    };
    agents = mapAttrs mkAgent config.ai.agents;
    skills = mapAttrs mkSkill config.ai.skills;
    tui.theme = "wallust";
    inherit context;
  };
}
