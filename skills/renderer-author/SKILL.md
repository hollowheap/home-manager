---
name: renderer-author
description: New-harness renderer authoring in modules/programs/. Load ONLY when adding or modifying an AI harness renderer. Do NOT load for general edits.
---

## Workflow

1. Confirm nixpkgs attr first; beware near-miss names like codex vs codex-cli.
2. Introspect upstream home-manager and nixpkgs module source before writing; never guess shapes.
3. Wire package, skills, agents, disciplines, rules, and drop lists into harness-native targets.
4. Consult references/matrices.md for renderer mapping, prompt overlap, and capabilities.
5. Stage new files with git add and verify with nix flake check --no-build.

## Rules

- Use shared rendering from config.ai.render (modelFor, effortFor, agentBodyFor, context, mkSkillDir); keep harness-specific tool and model mapping in the program module.
- Per-agent prompt bodies receive matched rules; global surfaces receive disciplines only.
- Author skills with strict trigger descriptions ("Load ONLY when... Do NOT load for..."), active-verb workflows without label prefixes, and bulleted rules ending in a Verify constraint.
- Stage new module files before evaluating per nix-flake-eval.
- Verify: Each rendered surface evals to expected content and nix flake check passes.
