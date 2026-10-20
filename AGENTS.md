# Workspace Conventions: Home Manager

Standalone Home Manager configuration for user `hollowheap` on `nixpkgs-unstable`. Everything is user-space: desktop session (Hyprland + UWSM), shell, editor, secrets, theming, and multi-harness AI configuration.

## Essential Commands

```bash
# Evaluation gate (run after every change; cheap, no build)
nix flake check --no-build

# Build activation package without activating
nix build .#homeConfigurations.hollowheap.activationPackage

# Apply generation (manual user acceptance step)
home-manager switch --flake .#hollowheap
```

## Repository Layout

- `flake.nix` / `home.nix` - Flake inputs, toolchains, outputs, and top-level module import.
- `modules/` - Auto-discovered HM modules: `core/`, `options/`, `ai/`, `programs/`, `services/`, `environment/`, `shell/`, `styles/`.
- `pkgs/` - Custom package derivations auto-discovered into package overlay.
- `skills/` - Repo-local workspace skills (`nix-flake-eval`, `renderer-author`, `upstream-recon`, `overlap-check`).
- `artifacts/` - Mutable workspace state: `plan.md`, `specs.md`, `matrix.md`, logs, and errors.

## Workspace Skills

- [nix-flake-eval](file:///home/hollowheap/repos/home-manager/skills/nix-flake-eval/SKILL.md): Flake evaluation hygiene and staging untracked files before check.
- [renderer-author](file:///home/hollowheap/repos/home-manager/skills/renderer-author/SKILL.md): Harness mapping, option shapes, and matrix reference.
- [upstream-recon](file:///home/hollowheap/repos/home-manager/skills/upstream-recon/SKILL.md): Store source declarations and option introspection.
- [overlap-check](file:///home/hollowheap/repos/home-manager/skills/overlap-check/SKILL.md): Base prompt overlap audit before dropping rules.
