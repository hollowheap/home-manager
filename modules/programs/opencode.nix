{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) concatStringsSep filterAttrs mapAttrs mapAttrsToList optionalString;

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

  opencodeModelFor =
    model:
    if model == "low" then
      "opencode/mimo-v2.6-flash-free"
    else if model == "flash" || model == "medium" then
      "opencode/muse-spark-1.3-contributor-free"
    else if model == "high" || model == "pro" || model == "xhigh" || model == "max" then
      "opencode/step-5-preview-free"
    else
      model;

  modeFor =
    agent:
    if agent.mainAgent && agent.subagent then
      "all"
    else if agent.mainAgent then
      "primary"
    else
      "subagent";

  rulesText =
    agent:
    let
      matches =
        rule:
        lib.all (cap: !rule.requires.${cap} || agent.capabilities.${cap}) [
          "read"
          "write"
          "execute"
          "delegate"
          "mcp"
          "web"
        ];
      kept = lib.filter matches config.ai.rules;
    in
    lib.optionalString (kept != [ ]) ("\n\n" + concatStringsSep "\n\n" (map (rule: rule.text) kept));

  mkAgent =
    _name: agent:
    # TODO: Map agent.effort to Opencode reasoning effort
    let
      resolvedModel = if agent.model != null then opencodeModelFor agent.model else "opencode/muse-spark-1.3-contributor-free";
      model = "model: ${builtins.toJSON resolvedModel}\n";
      tools = toolsFor agent.capabilities // {
        # Built-in question tool exists; gate it on the question skill like antigravity's ask_question.
        question = builtins.elem "question" agent.skills;
      };
    in
    ''
      ---
      description: ${builtins.toJSON agent.description}
      mode: ${modeFor agent}
      ${model}tools:
      ${concatStringsSep "\n" (mapAttrsToList (tool: enabled: "  ${tool}: ${if enabled then "true" else "false"}") tools)}
      ---

      ${agent.instructions}${rulesText agent}
    '';

  mkSkill =
    name: skill:
    pkgs.runCommandLocal "opencode-skill-${name}" { } ''
      mkdir -p "$out/references" "$out/scripts"
      cp ${
        pkgs.writeText "${name}-SKILL.md" ''
          ---
          name: ${name}
          description: ${skill.description}
          ---

          ${skill.content}
        ''
      } "$out/SKILL.md"
      ${concatStringsSep "\n" (mapAttrsToList (fileName: content: ''
        cp ${pkgs.writeText "${name}-reference-${fileName}" content} "$out/references/${fileName}"
      '') skill.references)}
      ${concatStringsSep "\n" (mapAttrsToList (fileName: content: ''
        install -m0755 ${pkgs.writeText "${name}-script-${fileName}" content} "$out/scripts/${fileName}"
      '') skill.scripts)}
    '';

  # Discipline lines the opencode built-in prompt already covers (concise style guide,
  # no-dump file refs, single targeted questions): drop them here, keep the rest.
  droppedDisciplineRules = {
    hygiene = [
      "clean-hands"
      "no-destroy"
    ];
    unslop = [
      "concise"
      "no-restate"
      "dense"
    ];
  };

  renderDiscipline =
    name: discipline:
    let
      dropped = droppedDisciplineRules.${name} or [ ];
      kept = filterAttrs (rule: text: text != null && !(builtins.elem rule dropped)) discipline.rules;
    in
    ''
      # ${name}
      ${discipline.description}

      ${concatStringsSep "\n\n" (mapAttrsToList (_: text: text) kept)}
    '';

  context = concatStringsSep "\n\n" (mapAttrsToList renderDiscipline config.ai.disciplines);
in
{
  programs.opencode = {
    enable = true;
    agents = mapAttrs mkAgent config.ai.agents;
    skills = mapAttrs mkSkill config.ai.skills;
    inherit context;
  };
}
