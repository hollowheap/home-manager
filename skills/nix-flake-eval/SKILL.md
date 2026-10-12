---
name: nix-flake-eval
description: Flake evaluation hygiene for this workspace. Use when nix eval, build, or check returns empty or stale results for files just written. Do NOT use outside this repo.
---

New files are invisible to flake evaluation until tracked. Dirty trees evaluate tracked-worktree plus staged-new and nothing else.

## Use / Do NOT use

Use when: eval misses new files, results look stale, adding modules or skills.
Do NOT use when: outside this workspace, or eval shows real diagnostics (read those first).

## Workflow

1. `git status --porcelain` before evaluating; spot `??` files.
2. `git add <paths>` by name: stage, never commit unasked.
3. Re-run eval; redirect noisy output to /tmp files and read back.
4. Close with `nix flake check --no-build`.

## Rules

1. Never `git add -A`; stage explicit paths only.
2. Probe with `--apply` plus `--json` into /tmp; harness output truncates long runs.
3. One probe per surface (options, home.file, context); batch independent probes.

## Bad / Good

Bad: debug a renderer for three rounds before noticing the file is untracked.
Good: status shows `??`, add by name, eval renders, matrix check passes.

## Verification

Eval output changes after staging; flake check passes.
