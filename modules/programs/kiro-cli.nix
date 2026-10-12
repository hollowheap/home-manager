{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mapAttrsToList optionals filterAttrs concatStringsSep;

  slugToTitle =
    slug:
    let
      words = lib.splitString "-" slug;
      capitalize =
        w:
        let
          len = builtins.stringLength w;
        in
        if len == 0 then
          ""
        else
          lib.toUpper (builtins.substring 0 1 w) + builtins.substring 1 (len - 1) w;
    in
    concatStringsSep " " (map capitalize words);

  mkSkillFiles =
    name: skill:
    [
      {
        name = ".kiro/skills/${name}/SKILL.md";
        value.text = ''
          # ${name}
          ${skill.description}

          ${skill.content}
        '';
      }
    ]
    ++ (mapAttrsToList (refName: refContent: {
      name = ".kiro/skills/${name}/references/${refName}";
      value.text = refContent;
    }) skill.references)
    ++ (mapAttrsToList (scriptName: scriptContent: {
      name = ".kiro/skills/${name}/scripts/${scriptName}";
      value = {
        text = scriptContent;
        executable = true;
      };
    }) skill.scripts);

  mkDiscipline =
    name: d: {
      name = ".kiro/steering/${name}.md";
      value.text = ''
        # ${name}
        ${d.description}

        ${d.content}
      '';
    };

  kiroToolsFor =
    caps:
    [ "read" ]
    ++ (optionals caps.write [ "write" ])
    ++ (optionals caps.execute [ "shell" ])
    ++ (optionals caps.delegate [ "subagent" ])
    ++ (optionals caps.mcp [ "@mcp" ])
    ++ (optionals caps.web [ "web" ]);

  kiroRulesFor =
    name: agent:
    let
      caps = agent.capabilities;
      writeRules =
        if name == "orchestrator" then
          [ { capability = "fs_write"; match = [ "artifacts/plan.md" ]; effect = "allow"; } ]
        else
          [ { capability = "fs_write"; match = [ "artifacts/plan.md" ]; effect = "deny"; } ];
      noWriteRules = [ { capability = "fs_write"; match = [ "**" ]; effect = "deny"; } ];
      executeRules = [ { capability = "shell"; match = [ "**" ]; effect = "allow"; } ];
      delegateRules = optionals (agent.availableAgents != [ ]) [
        { capability = "subagent"; match = map slugToTitle agent.availableAgents; effect = "allow"; }
      ];
    in
    (if caps.write then writeRules else noWriteRules)
    ++ (optionals caps.execute executeRules)
    ++ (optionals caps.delegate delegateRules);

  preventOverwriteHook = pkgs.writeShellScript "prevent-overwrite.sh" ''
    PAYLOAD="$(cat)"
    CMD="$(echo "$PAYLOAD" | ${pkgs.jq}/bin/jq -r '.tool_input.command // empty')"
    PATH_VAL="$(echo "$PAYLOAD" | ${pkgs.jq}/bin/jq -r '.tool_input.file_path // .tool_input.path // empty')"
    if [ -n "$PATH_VAL" ] && [ -e "$PATH_VAL" ]; then
      echo "Overwriting existing files with create is denied by discipline. Use hunk editing instead." >&2
      exit 2
    fi
    exit 0
  '';

  mkKiroAgent =
    name: agent:
    let
      caps = agent.capabilities;
      readOnly = !caps.write && !caps.execute;
      skillResources = map (s: "skill://.kiro/skills/${s}/SKILL.md") agent.skills;
      repomapResource = optionals readOnly [ "file://artifacts/repomap.md" ];
      rules = kiroRulesFor name agent;
    in
    {
      name = ".kiro/agents/${name}.json";
      value.text = lib.generators.toJSON { } (
        {
          name = slugToTitle name;
          inherit (agent) description;
          prompt = agent.instructions;
          tools = kiroToolsFor caps;
          resources = skillResources ++ repomapResource;
          includeMcpJson = caps.mcp;
        }
        // (lib.optionalAttrs (agent.model != null) { inherit (agent) model; })
        // (lib.optionalAttrs (rules != [ ]) { permissions.rules = rules; })
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
      (builtins.concatLists (mapAttrsToList mkSkillFiles config.ai.skills))
      ++ (mapAttrsToList mkKiroAgent config.ai.agents)
      ++ (mapAttrsToList mkDiscipline config.ai.disciplines)
    )
    // {
      ".kiro/hooks/prevent-overwrite.json".text = lib.generators.toJSON { } {
        version = "v1";
        hooks = [
          {
            name = "prevent-overwrite";
            trigger = "PreToolUse";
            matcher = "fs_write|write";
            action = {
              type = "command";
              command = "${preventOverwriteHook}";
            };
            enabled = true;
          }
        ];
      };

      ".kiro/hooks/repomap-refresh.json".text = lib.generators.toJSON { } {
        version = "v1";
        hooks = [
          {
            name = "repomap-refresh";
            trigger = "SessionStart";
            action = {
              type = "command";
              command = "mkdir -p artifacts && ${pkgs.repomap}/bin/repomap > artifacts/repomap.md";
            };
            timeout = 30;
            enabled = true;
          }
        ];
      };
    }
  );
}
