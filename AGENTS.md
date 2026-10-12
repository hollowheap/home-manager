# Workspace Conventions: Home Manager

## Nix & Architecture Guidelines
- **Declarative Purity**: Adhere to pure declarative patterns without inline scripts where native module options exist.
- **Store Hygiene**: Avoid unmanaged runtime files in store locations.
- **Evaluation Boundaries**: Maintain standalone Home Manager evaluation boundaries; rely strictly on `nixpkgs-unstable`.
- **System Integration**: Binary application launches wrap through `uwsm app --` where applicable.
- **Module Discovery**: Submodules under `modules/` are recursively imported via `modules/default.nix`.

## Workspace Skills
SKILL.md procedures live in `skills/` (agentskills.io format). Load the matching skill before task work:
- **nix-flake-eval**: before any nix eval, build, or check touching new files.
- **renderer-author**: before adding or changing a renderer in `modules/programs/`.
