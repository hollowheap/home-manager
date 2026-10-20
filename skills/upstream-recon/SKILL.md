---
name: upstream-recon
description: Upstream module archaeology via store source and option eval. Load ONLY when adding or changing a renderer. Do NOT load for verified surfaces.
---

## Workflow

1. Read option descriptions via nix eval (`.description` on option path).
2. Follow `.declarations` into /nix/store source; read the module file.
3. Confirm package attrs (`meta.description`, `meta.mainProgram`) by eval.
4. Write the renderer against verified shapes only.

## Rules

- Near-miss names burn: verify exact attr (`codex`, not `codex-cli`).
- Declarations path first; web search only when store lookup fails.
- Record verified shapes in artifacts/ for the next reader.
- Verify: Every referenced option and package evals; renderer writes no guesswork.
