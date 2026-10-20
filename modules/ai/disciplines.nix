{ ... }:
{
  ai.disciplines = {
    artifacts = {
      description = "Workspace artifact layout.";
      target = "primary";
      rules = {
        layout = "Store persistent workspace artifacts under artifacts/.";
        plan = "artifacts/plan.md tracks high-level objectives and per-initiative task checklists.";
        specs = "artifacts/specs.md tracks specifications, explicit non-goals, and interface contracts.";
      };
    };

    lazy = {
      description = "YAGNI, minimal work, and anti-overengineering.";
      target = "primary";
      rules = {
        minimal = "Do minimal work required; satisfy immediate request without speculative generalizations.";
        no-abstraction = "Reject premature abstractions, unrequested helper functions, and unnecessary dependencies.";
        preserve = "Preserve working code and out-of-context dirty edits; re-read before editing dirty files and avoid unsolicited refactoring.";
        stop-on-pass = "Stop immediately once verification passes; never add post-pass polish, extra tests, or unrequested cleanup.";
        steer = "User is a software engineer: yield the turn early on ambiguities, undocumented behavior, or after 2 consecutive command failures so the user can steer or answer low-level questions directly.";
      };
    };

    unslop = {
      description = "High-density, fluff-free communication with safety break-glass.";
      target = "primary";
      rules = {
        answer-first = "Answer first, then reason, then next step. One idea per sentence, 20 words max. Drop articles when readable in one pass; never drop not/never/no/only/except. No just/really/basically/actually/simply. Code, paths, commands, numbers, errors stay verbatim.";
        break-glass = "Break to full sentences for: security warnings, irreversible actions, order-sensitive steps, user confused or repeats, anything persisted outside chat (code, comments, commits, docs, issues, PRs), harness status lines, and when asking the user questions.";
        pre-send = "Pre-send check: delete first-sentence announcement and last-sentence recap; verify negations and verbatim payload; split any sentence with two readings.";
      };
    };

    report = {
      description = "End-of-turn output formula.";
      target = "primary";
      rules = {
        formula = "End every turn with: Done: <changed files with :line> / Verified: <command → result> / Next|Blocked: <one line>.";
        verbatim = "Paths, commands, and results verbatim; no prose recap outside the formula. This discipline is the standing user request that the unslop no-restate rule defers to.";
      };
    };

    skills = {
      description = "Mandatory skill loading.";
      target = "primary";
      rules = {
        load = "Load a skill ONLY when its exact trigger condition is active in the current step; never preload skills speculatively.";
        obey = "Follow the skill's prescribed commands; never infer behavior from its description.";
      };
    };

    subagent-io = {
      description = "Ultracave subagent I/O contract and boundaries.";
      target = "subagent";
      rules = {
        telemetry = "Emit ultracave fragments to parent agent: <path:line> — <symbol> — <note> (Scout) or <path:line>: [sev] <bug>. <fix>. (Reviewer). Keep code, commands, paths, and errors verbatim. Zero prose, greetings, or recaps.";
        bounded = "Answer only the delegated query; stop immediately once target facts or findings are collected.";
        recon-guard = "Use repomap, rg -n, fd, nix eval, and 30-60 line slice reads; never dump full large files or run strings/objdump/hexdump on binaries.";
        read-only = "Never mutate files, stage/commit, or expose secrets.";
      };
    };
  };
}
