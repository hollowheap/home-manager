# Workspace Conventions: Home Manager

## Nix & Architecture Guidelines
- **Declarative Purity**: Adhere to pure declarative patterns without inline scripts where native module options exist.
- **Store Hygiene**: Avoid unmanaged runtime files in store locations.
- **Evaluation Boundaries**: Maintain standalone Home Manager evaluation boundaries; rely strictly on `nixpkgs-unstable`.
- **System Integration**: Binary application launches wrap through `uwsm app --` where applicable.
- **Module Discovery**: Submodules under `modules/` are recursively imported via `modules/default.nix`.

## Editing & Diff Discipline (Strict)
- **Zero Full-File Rewrites**: NEVER rewrite an entire existing file to apply changes. Full file rewrites destroy git diff reviewability and waste tokens.
- **Minimal Hunk Replacement**: ALWAYS use targeted hunk replacements (`replace_file_content`) targeting the precise lines needing modification.
- **New Files Only for `write_to_file`**: `write_to_file` is strictly prohibited on existing files. It must only be used to create brand new files that do not yet exist in the repository.
- **Reviewable Diffs**: Keep diff hunks minimal, atomic, and human-scannable.
