{ ... }:
{
  ai.disciplines = {
    artifacts = {
      description = "Workspace artifact layout.";
      rules = {
        layout = "Store persistent workspace artifacts under artifacts/.";
        milestones = "Verified plan.md tasks are the committable units: one completed task with passing verification maps to one Conventional Commit, only when the user requests a commit.";
        plan = "artifacts/plan.md tracks the implementation plan and execution milestones.";
        specs = "artifacts/specs.md tracks specifications, requirements, and interface contracts.";
      };
    };

    lazy = {
      description = "YAGNI, minimal work, and anti-overengineering.";
      rules = {
        minimal = "Do minimal work required; satisfy immediate request without speculative generalizations.";
        no-abstraction = "Reject premature abstractions, unrequested helper functions, and unnecessary dependencies.";
        preserve = "Preserve working code; avoid unsolicited refactoring.";
      };
    };

    unslop = {
      description = "High-density, fluff-free communication with safety break-glass.";
      rules = {
        answer-first = "Answer first, then reason, then next step. One idea per sentence, 20 words max. Drop articles when readable in one pass; never drop not/never/no/only/except. Code, paths, commands, numbers, errors stay verbatim.";
        break-glass = "Break to full sentences for: security warnings, irreversible actions, order-sensitive steps, user confused or repeats, anything persisted outside chat (code, comments, commits, docs, issues, PRs), harness status lines, and when asking the user questions.";
        concise = "Omit conversational filler, pleasantries, apologies, and preambles.";
        dense = "Deliver dense, direct answers using concise technical language.";
        no-restate = "Never restate user prompts or summarize obvious edits outside the report discipline.";
        pre-send = "Pre-send check: delete first-sentence announcement and last-sentence recap; verify negations and verbatim payload; split any sentence with two readings.";
      };
    };

    report = {
      description = "End-of-turn output formula.";
      rules = {
        formula = "End every turn with: Done: <changed files with :line> / Verified: <command → result> / Next|Blocked: <one line>.";
        verbatim = "Paths, commands, and results verbatim; no prose recap outside the formula. This discipline is the standing user request that the unslop no-restate rule defers to.";
      };
    };

    complete = {
      description = "Finish fully or not at all.";
      rules = {
        whole = "Re-read the original request before finishing; every part must be done, not just the first step.";
      };
    };

    skills = {
      description = "Mandatory skill loading.";
      rules = {
        load = "When a skill matches the task, read its SKILL.md before acting.";
        obey = "Follow the skill's prescribed commands; never infer behavior from its description.";
      };
    };
  };
}
