{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mapAttrsToList optionals;

  # Skills render to Kiro steering rules (always-on context).
  mkSteeringRule = name: skill: {
    name = ".kiro/steering/${name}.md";
    value.text = ''
      # ${name}
      ${skill.description}

      ${skill.content}
    '';
  };

  # Translate harness-neutral capabilities into Kiro's V3 tool vocabulary
  # and capability-based permission rules. Kiro is read-only by default;
  # write/shell must be explicitly granted at BOTH the visibility (tools)
  # and authorization (permissions.rules) layers, and deny-overrides
  # guarantees the boundary even against injected instructions.
  kiroToolsFor =
    caps: [ "read" ] ++ (optionals caps.write [ "write" ]) ++ (optionals caps.execute [ "shell" ]);

  kiroExcludedFor =
    caps: (optionals (!caps.write) [ "write" ]) ++ (optionals (!caps.execute) [ "shell" ]);

  kiroRulesFor =
    caps:
    (optionals (!caps.write) [
      {
        capability = "fs_write";
        match = [ "**" ];
        effect = "deny";
      }
    ])
    ++ (optionals (!caps.execute) [
      {
        capability = "shell";
        match = [ "*" ];
        effect = "deny";
      }
    ]);

  mkKiroAgent =
    name: agent:
    let
      caps = agent.capabilities;
      # Read-only agents cannot run `repomap` themselves (no shell), so give
      # them the pre-generated outline as a static file resource. Execute-capable
      # agents can invoke `repomap` live and do not need the snapshot.
      readOnly = !caps.write && !caps.execute;
      skillResources = map (s: "skill://.kiro/steering/${s}.md") agent.skills;
      repomapResource = optionals readOnly [ "file://.kiro/repomap.md" ];
    in
    {
      name = ".kiro/agents/${name}.json";
      value.text = lib.generators.toJSON { } {
        inherit (agent) description;
        prompt = agent.instructions;
        tools = kiroToolsFor caps;
        excludedTools = kiroExcludedFor caps;
        permissions.rules = kiroRulesFor caps;
        resources = skillResources ++ repomapResource;
      };
    };
in
{
  programs.kiro-cli = {
    enable = true;
    enableZshIntegration = true;
  };

  home.file = mkIf config.programs.kiro-cli.enable (
    builtins.listToAttrs (
      (mapAttrsToList mkSteeringRule config.ai.skills) ++ (mapAttrsToList mkKiroAgent config.ai.agents)
    )
    // {
      # Regenerate the repository outline at session start so read-only agents
      # (which cannot run `repomap` themselves) receive a fresh map via their
      # file://.kiro/repomap.md resource.
      ".kiro/hooks/repomap-refresh.json".text = lib.generators.toJSON { } {
        version = "v1";
        hooks = [
          {
            name = "repomap-refresh";
            trigger = "SessionStart";
            action = {
              type = "command";
              command = "${pkgs.repomap}/bin/repomap > .kiro/repomap.md";
            };
            timeout = 30;
            enabled = true;
          }
        ];
      };
    }
  );
}
