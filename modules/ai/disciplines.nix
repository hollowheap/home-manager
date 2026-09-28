{ ... }:
{
  ai.disciplines = {
    diff = {
      description = "Editing rules enforcing minimal, human-reviewable diffs without full-file rewrites.";
      kiro = ''
        - NEVER rewrite an entire existing file to apply a change, even when the edit is large; use targeted replacements only.
        - Restrict file creation to brand-new files that do not yet exist.
      '';
      antigravity = ''
        - NEVER rewrite an entire existing file when applying edits; use the smallest targeted hunk that achieves the change.
        - Preserve surrounding context, whitespace, and unchanged code.
        - Use file-creation tools strictly for brand-new files that do not yet exist.
      '';
    };

    comment = {
      description = "Rules governing when code comments may be written.";
      kiro = ''
        - Do NOT add code comments unless the user explicitly requests them; this overrides the default of adding explanatory comments for complex code.
        - Never remove existing comments as a side effect of an unrelated edit.
        - Exception: preserve comments the file's convention requires, such as license headers or generated-file markers.
      '';
      antigravity = ''
        - Do NOT add code comments unless the user explicitly requests them.
        - Prefer self-documenting code: clear names and structure over explanatory comments.
        - Never remove existing comments as a side effect of an unrelated edit.
        - Exception: preserve comments the file's convention requires, such as license headers or generated-file markers.
      '';
    };
  };
}
