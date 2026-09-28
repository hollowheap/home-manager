{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mapAttrsToList optionals filterAttrs concatStringsSep;

  mkSteeringRule = name: skill: {
    name = ".kiro/steering/${name}.md";
    value.text = ''
      # ${name}
      ${skill.description}

      ${skill.content}
    '';
  };

  kiroDisciplines = filterAttrs (_: d: d.kiro != "") config.ai.disciplines;

  disciplineSection = name: d: ''
    ## ${name}
    ${d.description}

    ${d.kiro}
  '';

  disciplineFile = ''
    # Disciplines
    Global code-writing rules that complement Kiro's built-in defaults.

    ${concatStringsSep "\n" (mapAttrsToList disciplineSection kiroDisciplines)}
  '';

  kiroToolsFor =
    caps:
    [ "read" ]
    ++ (optionals caps.write [ "write" ])
    ++ (optionals caps.execute [ "shell" ])
    ++ (optionals caps.delegate [ "subagent" ])
    ++ (optionals caps.mcp [ "@mcp" ])
    ++ (optionals caps.web [ "web" ]);

  kiroExcludedFor =
    caps:
    (optionals (!caps.write) [ "write" ])
    ++ (optionals (!caps.execute) [ "shell" ])
    ++ (optionals (!caps.web) [ "web" ]);

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
    ])
    ++ (optionals caps.delegate [
      {
        capability = "subagent";
        match = [ "*" ];
        effect = "allow";
      }
    ])
    ++ (optionals (!caps.mcp) [
      {
        capability = "mcp";
        match = [ "*" ];
        effect = "deny";
      }
    ])
    ++ (optionals (!caps.web) [
      {
        capability = "web_search";
        match = [ "*" ];
        effect = "deny";
      }
      {
        capability = "web_fetch";
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
      value.text = lib.generators.toJSON { } (
        {
          inherit (agent) description;
          prompt = agent.instructions;
          tools = kiroToolsFor caps;
          excludedTools = kiroExcludedFor caps;
          permissions.rules = kiroRulesFor caps;
          resources = skillResources ++ repomapResource;
          includeMcpJson = caps.mcp;
        }
        // (lib.optionalAttrs caps.delegate {
          toolsSettings.subagent = {
            availableAgents = agent.availableAgents;
            trustedAgents = agent.trustedAgents;
          };
        })
      );
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
      ".kiro/steering/discipline.md".text = disciplineFile;

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
