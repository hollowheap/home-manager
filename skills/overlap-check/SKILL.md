---
name: overlap-check
description: Built-in prompt overlap audit for shared text. Load ONLY when adding disciplines or rules. Do NOT load for per-agent text.
---

## Workflow

1. Fetch harness base prompt (store source, docs, or repo file).
2. Matrix candidate lines against built-in coverage.
3. Drop only verified overlap; empty map plus comment otherwise.
4. Re-verify rendered output per harness after wiring drops.

## Rules

- Closed prompts are unverifiable: no drops, ever.
- Partial coverage keeps the line; drops need full coverage.
- One harness's proof never transfers to another.
- Measure the same prompt before and after; never trust vendor percentages. Audit rendered context size (chars/4 ≈ tokens per harness) before claiming any win.
- Verify: Rendered contexts show drops exactly where proven, full text elsewhere.
