{ ... }:
{
  ai.rules = [
    {
      name = "hunks";
      requires.write = true;
      text = ''
        Targeted hunk edits only; never rewrite a whole file for a small change.
        Anchor each Edit on 2 unchanged context lines; one logical change per Edit.
        Write is for brand-new files only. No drive-by formatting.
        Preserve headers, license markers, generated markers, and existing comments.
        Comments only if asked, except security or irreversible edges (explain those in full sentences).
        Verify with git diff: only intended files and hunks.
      '';
    }

    {
      name = "shell";
      requires.execute = true;
      text = ''
        Shell is for execution, not inspection: list with Glob, search with Grep, read with Read slices.
        Bound verbose output with head/tail; quote paths with spaces.
        Run independent calls in one block; chain dependent ones.
        Never pagers, interactive prompts, or full-file dumps.
      '';
    }

    {
      name = "commits";
      requires.execute = true;
      text = ''
        Shape commits; never order them. Committing happens only on explicit user request.
        Stage files explicitly by name; subject type(scope): imperative under 72 chars.
        One verified milestone per commit; passing checks required.
      '';
    }

    {
      name = "tests";
      requires.execute = true;
      text = ''
        Run the failing test or reproducer before touching implementation; capture the exact error line.
        Re-run the target to confirm pass, then the broader suite for regressions.
        Record the passing milestone.
      '';
    }

    {
      name = "logs";
      requires.execute = true;
      text = ''
        Redirect long or background output: stdout to artifacts/logs/<name>.log, stderr to artifacts/errors/<name>.log.
        Omit redirection for quick tests needing immediate feedback.
        Cite file:line for the decisive error, not full logs.
      '';
    }

    {
      name = "clean-hands";
      requires.write = true;
      text = ''
        Never revert, amend, or reset changes you did not make; work around unrelated diffs.
      '';
    }

    {
      name = "no-destroy";
      requires.execute = true;
      text = ''
        Never force-push, delete branches, or rewrite history.
      '';
    }

    {
      name = "no-secrets";
      requires.execute = true;
      text = ''
        Never commit secrets; check diffs for keys and tokens first.
      '';
    }

    {
      name = "record";
      requires.write = true;
      text = ''
        Record discovered build, test, and lint commands in artifacts/ for next time.
        When an assumption proves wrong, record the correction in artifacts/ so the fix persists.
      '';
    }

    {
      name = "delegate";
      requires.delegate = true;
      text = ''
        Fan-out independent subtasks in parallel; otherwise chain research → writer → reviewer.
        Verify each deliverable against its plan.md task before proceeding.
      '';
    }
  ];
}
