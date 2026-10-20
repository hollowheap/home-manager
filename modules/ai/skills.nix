{ pkgs, ... }:
{
  ai.skills = {
    plan = {
      description = "Structured implementation planning in artifacts/plan.md. Load ONLY when a task needs 3+ steps, multi-file changes, or architectural coordination. Do NOT load for single trivial edits.";
      content = ''
        ## Workflow

        1. Read relevant target files, specifications, and options before drafting; never assume architecture.
        2. Write or update artifacts/plan.md with Objective, numbered Tasks, and explicit Verification per task.
        3. Keep exactly one task in progress; mark completed only after verification passes.
        4. Record discovered build, test, and lint commands plus failed assumptions in artifacts/ so knowledge persists.
        5. Update roadmap as milestones are achieved; append newly discovered follow-up tasks to the active section.

        ## Rules

        - Tasks are atomic: one action and one verifiable outcome each.
        - Every task names its exact check command (test suite, nix eval, nix build, nix flake check).
        - Never batch completions; update task checkboxes in real time.
        - Objectives are stable and high-level; append new work as Tasks sections, and move closed initiatives to artifacts/tasks/<slug>.md.
        - Maintainer ownership: engineer maintains plan.md; architect contributes specifications and roadmaps.
        - Verify: artifacts/plan.md exists with Objective, Tasks, and passing Verification for every checked box.
      '';
      references."template.md" = ''
        # Plan
        ## Objectives
        Stable high-level goals (see artifacts/tasks/overview.md); new initiatives append Tasks below.
        Closed initiatives move to artifacts/tasks/; this file keeps objectives and active work.
        ## Tasks
        - [ ] Action + file path + outcome
        - [ ] Next action + verification cmd
        ## Verification
        Exact commands: tests, nix eval, nix build, nix flake check.
      '';
      references."examples.md" = ''
        # Plan Examples

        ## Bad
        - Start editing files without a plan, keeping tasks in head and losing track mid-refactor.
        - Marking all tasks complete in a single batch without running individual verification checks.

        ## Good
        - Write plan.md with atomic `- [ ] Add pill helper`, `- [ ] Wire lualine sections`, `- [ ] nix flake check`, verify each step, and check off one at a time.
      '';
    };

    grill = {
      description = "Design-tree interview to resolve ambiguities. Load ONLY when requirements, architecture, or undocumented options have open decisions. Do NOT load for clear tasks.";
      content = ''
        ## Workflow

        1. Separate repo-verifiable facts from user decisions: check plain-text repo/docs once (or via Scout) for facts; never run strings/objdump/hexdump on compiled binaries or brute-force CLI flags.
        2. Ask every independent frontier question in one round: use the harness question tool with (Recommended) first when available; otherwise output numbered ❓ questions with ➡️ (Recommended) default in chat and end the turn to wait for user response.
        3. Advance frontier round-by-round until settled and confirm shared understanding before acting.

        ## Rules

        - Exhaust plain-text repo/docs lookup before asking; never ask questions the codebase answers directly.
        - Ask all independent questions in a single turn; avoid multi-turn interrogation when options are decoupled.
        - Put the recommended option first with clear rationale and trade-offs.
        - Precision beats brevity when formulating design decisions.
        - Verify: All frontier ambiguities resolved and confirmed before code edits begin.
      '';
      references."examples.md" = ''
        # Grill Examples

        ## Bad
        - Numbered CLI menu pasted into chat without recommendations.
        - Running strings on a binary to guess command-line flags instead of checking docs or asking.
        - Asking three sequential questions across three turns when all three were known upfront.

        ## Good
        - Single round with 2 decoupled questions, (Recommended) defaults marked, clear impact on architecture.
        - Checked plain-text Nix module options first; asked user only about chosen application behavior.
      '';
    };

    nav-repomap = {
      description = "Repository symbol navigation via repomap artifact and slice reads. Load ONLY when locating definitions or exact line ranges in unfamiliar code. Do NOT load for known file paths.";
      content = ''
        ## Workflow

        1. Run scripts/repomap.sh to generate or refresh artifacts/repomap.md when missing or outdated.
        2. Search artifacts/repomap.md for target identifiers, types, or function definitions to locate file paths.
        3. Read 30-60 line slices around target definitions; never dump entire large files into context.
        4. Fall back to targeted ripgrep (rg -n) or fd only if repomap does not index the symbol.

        ## Rules

        - Locate definitions first, read targeted slices second, search with ripgrep last.
        - Never dump full files when only a function or type definition is needed.
        - Bound slice reads to 30-60 lines around target symbols.
        - Verify: Target symbol located with exact file and line range confirmed.
      '';
      references."examples.md" = ''
        # Nav-Repomap Examples

        ## Bad
        - Reading a 1500-line file from line 1 to 1500 to find a 10-line function definition.
        - Running broad grep across the entire workspace without checking repomap first.

        ## Good
        - Search `artifacts/repomap.md` for `mk_pill`, identify line 150 of `modules/programs/nvim.nix`, and read lines 145-175.
      '';
      scripts."repomap.sh" = ''
        #!/usr/bin/env bash
        mkdir -p artifacts
        exec ${pkgs.repomap}/bin/repomap "$@"
      '';
    };

    git-commit = {
      description = "Stage paths and create a Conventional Commit. Load ONLY when the user explicitly asks to stage or commit. Do NOT load during planning, coding, or git status/diff checks.";
      content = ''
        ## Workflow

        1. Run git status, git diff, and git log --oneline -n 5 to inspect working tree state and foreign session edits.
        2. Check diffs for exposed secrets, API keys, tokens, or private credentials before staging.
        3. Stage intended task files explicitly by path; never run git add -A or git add .
        4. Commit with <type>(<scope>): <imperative summary> (<=50 chars, types: feat|fix|refactor|docs|test|chore|perf|ci|build|style).
        5. Map one verified plan.md task to one commit; never rewrite shared git history.

        ## Rules

        - Never commit unless explicitly requested by the user.
        - Always stage explicit file paths; never use blanket git add commands.
        - Check diffs for keys, tokens, and secrets before staging.
        - Never revert, amend, or reset changes made outside the current session.
        - Never force-push, delete remote branches, or rewrite history.
        - Verify: git log -n 1 shows conventional commit message and git diff --staged is clean.
      '';
      references."examples.md" = ''
        # Git-Commit Examples

        ## Bad
        - Committing without user request during a coding or planning turn.
        - Running `git add .` and accidentally staging `.env` or untracked secret keys.
        - Vague commit message like `update files` or `wip`.

        ## Good
        - User asks "commit changes", agent runs `git status`, stages `modules/programs/opencode.nix`, checks diff for secrets, and commits with `feat(ai): configure scout and code-reviewer subagents`.
      '';
    };

    layout-spacing-audit = {
      description = "Audit fully-rendered HTML for layout and spacing defects against a compact, comfortable, or spacious profile and emit a JSON report. Use after a build when checking visual rhythm, breathing room, or cramped and loose components. Do NOT use for color, typography, contrast, or unrendered source review.";
      content = ''
        Audit rendered spacing, not source CSS. Render in a real browser, compute boxes, and compare inward parent-to-child spacing to a target profile. Read references/profiles.md for component signals, spacing rules, the profile tables, and the output schema.

        ## Use / Do NOT use

        Use when: a build emits HTML and you must check padding, gaps, sidebar/main separation, or density against a spacing profile.
        Do NOT use when: reviewing color, typography, or contrast, or reading static CSS/JSX without rendering (declared spacing lies; invalid tokens only surface in the computed tree).

        ## Workflow

        1. Build first; stale bundles audit old styles.
        2. Capture desktop and mobile: scripts/render-metrics.mjs <html> <out.json> [width] [height] [waitSelector].
        3. Segment components, then evaluate inward spacing and profile conformance (references/profiles.md).
        4. Emit the JSON report; one entry per component, real issues only.
        5. After fixes, rebuild, re-capture, and re-report to confirm.

        ## Rules

        1. Audit the computed box, never the declared prop; invalid tokens collapse to 0.
        2. Always render a mobile viewport; drawers and sticky footers only surface there.
        3. Judge fixed-height controls by computed height (>= ~40px), not vertical padding.
        4. Report the pre-fix state; note applied fixes separately.

        ## Bad / Good

        Bad: read the CSS and pass pb="$28"; it computes to 0 and hides content under the footer.
        Good: capture both viewports, find the 0px bottom padding, cite the selector and target 96px.

        ## Verification

        Report cites computed values (padding, gap, width) and a unique selector per component; re-running shows the flagged css_target values.
      '';
      references."profiles.md" = ''
        # Layout spacing audit reference

        ## Component detection signals (priority order)

        - Sidebar: <aside>, role="complementary" or "navigation", or class/testid matching /sidebar|drawer|nav-rail|aside/i.
        - Main: <main>, role="main", or class matching /main|content-root|workspace|page-body/i.
        - Composite (card, modal, form, list, toolbar): <form>, <dialog>, <nav>, <header>, <footer>, <section>, <article>; data-component, data-testid, data-slot; class matching /card|panel|modal|dialog|toolbar|dropdown|form-group|menu/i.
        - Atomic controls: <button>, <input>, <select>, styled <a>.

        Prefer data-testid and data-component hooks over tag heuristics when present.

        ## Inward spacing rules

        1. Container breathing room: container padding must be at least the gap/margin between its own children. A container wrapping text or interactive children with padding 0 is a violation.
        2. Sibling gap vs boundary padding: spacing between two distinct child components must not exceed the parent's outer padding.
        3. Sidebar-to-main: an explicit gap or margin must separate them (a 1px border is not separation). Sidebar nav items need proportional vertical padding to be distinct targets without overflowing.
        4. Hierarchy inversion: a nested child container must not have larger internal padding than its enclosing parent container.

        ## Profile constraints

        Choose compact (dashboards/grids/IDEs), comfortable (default: standard SaaS), or spacious (editorial/marketing).

        | Metric | compact | comfortable | spacious |
        | --- | --- | --- | --- |
        | Sidebar width | 200-240px | 240-280px | 280-320px |
        | Sidebar internal padding | 8-12px | 16-20px | 24-32px |
        | Sidebar nav item gap | 4-6px | 8-10px | 12-16px |
        | Sidebar to main gap | 12-16px | 24-32px | 32-48px |
        | Container/card padding | 12-16px | 20-24px | 32-48px |
        | Container child gap | 8-12px | 16-20px | 24-32px |
        | Control padding (v/h) | 4-6 / 8-12px | 8-10 / 16-20px | 12-16 / 24-32px |
        | Label to control gap | 4px | 8px | 12px |

        ## Output schema

        Return only this JSON (write it to a report file as well as inline):

        {
          "profile_used": "compact | comfortable | spacious",
          "detected_components": [
            {
              "component_type": "sidebar | card | form | modal | main_layout | button",
              "selector": "<unique CSS selector or xpath of the parent>",
              "child_count": 0,
              "issues": [
                {
                  "type": "CONTAINER_PADDING_COLLAPSE | SIBLING_GAP_OVERFLOW | SIDEBAR_GAP_MISSING | TOUCH_DENSITY_MISMATCH | HIERARCHY_INVERSION",
                  "target_node": "<parent | child selector>",
                  "details": "<concise spatial explanation>",
                  "css_target": {
                    "padding": "<value or null>",
                    "margin": "<value or null>",
                    "gap": "<value or null>",
                    "width": "<value or null>"
                  }
                }
              ]
            }
          ]
        }

        ## Gotchas (from real audits)

        - Invalid design tokens silently zero out padding. A prop like pb="$28" on a token scale that jumps 24 to 32 computes to 0px, hiding content behind a sticky footer. Confirm the token exists in the resolved scale.
        - Fixed-height controls legitimately have padding 0 vertically. Component libraries (e.g. Gluestack Button) set a fixed height plus horizontal padding instead of vertical padding. Judge the touch target by computed height (>= ~40px), not by vertical padding; do not flag these.
        - Sticky or fixed footers need bottom padding on the scroll container of at least the footer height, or the last child is obscured.
        - gap and margin are separate. A flex row with gap 0 shows no separation even if children have borders.
        - Fixed or absolute sidebars leave the flow. A gap on the parent flex row has no effect when the sidebar is position fixed (single in-flow child), so a desktop gap fix is harmless on mobile but must be verified there.
        - Report the pre-fix state, then note applied fixes separately; the report is an audit, not a changelog.
      '';
      scripts."render-metrics.mjs" = ''
        #!/usr/bin/env node
        import { chromium } from "playwright";
        import fs from "node:fs/promises";
        import { existsSync, readdirSync } from "node:fs";
        import path from "node:path";
        import { pathToFileURL } from "node:url";

        function resolveChromium() {
          const env =
            process.env.CHROMIUM_PATH ||
            process.env.PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH ||
            process.env.CHROME_BIN;
          if (env && existsSync(env)) return env;

          const common = [
            "/usr/bin/chromium",
            "/usr/bin/chromium-browser",
            "/usr/bin/google-chrome",
            "/usr/bin/google-chrome-stable",
            "/run/current-system/sw/bin/chromium",
            "/run/current-system/sw/bin/google-chrome",
          ];
          for (const p of common) if (existsSync(p)) return p;

          try {
            for (const entry of readdirSync("/nix/store")) {
              if (!/-chromium-[0-9]/.test(entry)) continue;
              const bin = path.join("/nix/store", entry, "bin", "chromium");
              if (existsSync(bin)) return bin;
            }
          } catch {}
          return undefined;
        }

        const args = process.argv.slice(2);
        if (args.length < 2) {
          console.error("usage: render-metrics.mjs <html> <out.json> [width] [height] [waitSelector]");
          process.exit(1);
        }
        const [htmlPath, outPath, widthArg, heightArg, waitSelector] = args;
        const width = Number(widthArg || 1280);
        const height = Number(heightArg || 800);

        const launchOpts = {
          headless: true,
          args: ["--no-sandbox", "--disable-setuid-sandbox", "--disable-dev-shm-usage", "--disable-gpu"],
        };
        const exe = resolveChromium();
        if (exe) launchOpts.executablePath = exe;

        const browser = await chromium.launch(launchOpts);
        const context = await browser.newContext({ viewport: { width, height } });
        const page = await context.newPage();
        await page.goto(pathToFileURL(path.resolve(htmlPath)).href, { waitUntil: "load" });
        if (waitSelector) {
          await page.waitForSelector(waitSelector, { timeout: 15000 }).catch(() => {});
        }
        await page.waitForTimeout(500);

        const data = await page.evaluate(() => {
          const round = (v) => {
            const n = parseFloat(v);
            return Number.isFinite(n) ? Math.round(n * 100) / 100 : v;
          };
          const skip = new Set(["script", "style", "svg", "path", "defs", "symbol", "use", "g", "rect", "circle", "line", "polyline", "polygon", "meta", "link", "title"]);
          const nodes = Array.from(document.querySelectorAll("*")).filter((el) => {
            if (skip.has(el.tagName.toLowerCase())) return false;
            if (el.closest("svg")) return false;
            return true;
          });
          const metrics = nodes.map((el) => {
            const cs = getComputedStyle(el);
            const r = el.getBoundingClientRect();
            const parts = [];
            let cur = el;
            while (cur && cur.nodeType === 1 && parts.length < 8) {
              let part = cur.tagName.toLowerCase();
              if (cur.dataset && cur.dataset.testid) part += "[" + cur.dataset.testid + "]";
              else if (cur.id) part += "#" + cur.id;
              else if (typeof cur.className === "string" && cur.className.trim()) {
                part += "." + cur.className.trim().split(/\s+/).slice(0, 2).join(".");
              }
              parts.unshift(part);
              cur = cur.parentElement;
            }
            return {
              path: parts.join(">"),
              tag: el.tagName.toLowerCase(),
              testid: el.dataset ? el.dataset.testid || null : null,
              role: el.getAttribute("role"),
              childElementCount: el.childElementCount,
              display: cs.display,
              flexDirection: cs.flexDirection,
              position: cs.position,
              padding: [cs.paddingTop, cs.paddingRight, cs.paddingBottom, cs.paddingLeft].map(round).join(" "),
              margin: [cs.marginTop, cs.marginRight, cs.marginBottom, cs.marginLeft].map(round).join(" "),
              gap: cs.gap === "normal" ? "normal" : cs.gap,
              width: round(r.width),
              height: round(r.height),
              text: el.childNodes.length && el.textContent ? el.textContent.trim().slice(0, 40) : "",
            };
          });
          return { viewport: { width: window.innerWidth, height: window.innerHeight }, outerHTML: document.documentElement.outerHTML, metrics };
        });

        await fs.writeFile(outPath, JSON.stringify(data, null, 2), "utf-8");
        console.log("Wrote " + outPath + ": " + data.metrics.length + " nodes at " + width + "x" + height);
        await browser.close();
      '';
    };
  };
}
