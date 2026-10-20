{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) concatStringsSep mapAttrs mapAttrsToList;

  aiRender = config.ai.render;

  # No nix package for Hermes Agent (curl installer only, MIT, NousResearch/hermes-agent):
  # install the binary upstream, then `hermes import-agent` can bootstrap from the
  # managed Codex setup. This module manages skills + config declaratively.
  # Hermes scans external skill dirs alongside ~/.hermes/skills, keeping managed
  # skills separate from agent-created ones.
  mkSkillDir = aiRender.mkSkillDir { prefix = "hermes"; };

  skillDrvs = mapAttrs mkSkillDir config.ai.skills;

  skillsRoot = pkgs.runCommandLocal "hermes-skills" { } (
    ''
      mkdir -p "$out"
    ''
    + concatStringsSep "\n" (
      mapAttrsToList (name: _: ''
        ln -s ${skillDrvs.${name}} "$out/${name}"
      '') config.ai.skills
    )
  );

in
{
  home.file.".hermes/config.yaml".text = lib.generators.toYAML { } {
    skills = {
      external_dirs = [ "${skillsRoot}" ];
    };
  };
}
