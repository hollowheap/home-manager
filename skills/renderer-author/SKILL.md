---
name: renderer-author
description: New-harness renderer checklist for modules/programs/ in this workspace. Use when adding or changing a harness renderer. Do NOT use for edits inside existing renderers that change no surface.
---

Mirror the closest existing renderer; wire package, skills, agents, disciplines, rules, and drops; prove each surface with eval.

## Use / Do NOT use

Use when: new harness module, new option surface, changing what a renderer emits.
Do NOT use when: editing text inside one surface (just verify that surface).

## Workflow

1. Package: confirm the nixpkgs attr first (beware near-miss names: `codex`, not `codex-cli`).
2. Options: introspect the upstream module (store source declarations, option descriptions) before writing; never guess shapes.
3. Surfaces: map skills, agents, disciplines plus rules, and drop-lists to harness-native paths.
4. Drops: fetch the base prompt; drop only verified overlap, empty map plus comment otherwise.
5. Matrix: eval per-agent rule and tool presence (full/partial/none caps); flake check to close.

## Rules

1. Structure mirrors modules/programs/<closest>.nix: mkSkill or mkSkillDir, mkAgent or agent files, renderDiscipline, rulesText.
2. Per-agent prompt bodies get matched rules; global surfaces get disciplines only.
3. Follow nix-flake-eval: stage the new file before evaluating anything.

## Bad / Good

Bad: hand-write TOML strings and discover lib has no toTOML at eval time.
Good: formats module or store-source check first, then write, stage, eval matrix.

## Verification

Skills list, agent file, context, and drops each eval to expected content; flake check passes.
