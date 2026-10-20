---
name: nix-flake-eval
description: Flake evaluation hygiene for this workspace. Load ONLY when evaluating new or untracked files. Do NOT load for syntax or option shape errors.
---

## Workflow

1. Run git status --porcelain before evaluating; spot ?? untracked files.
2. Run git add <path> by name to stage untracked files; never commit unasked.
3. Re-run nix eval or build; redirect noisy output to /tmp when inspecting.
4. Close with nix flake check --no-build.

## Rules

- Never git add -A or git add .; stage explicit paths only.
- Probe with --apply plus --json into /tmp; harness output truncates long runs.
- One probe per surface (options, home.file, context); batch independent probes.
- Verify: Eval output reflects newly added files and nix flake check passes.
