# Fresh-Eyes Audit

Launch several independent, context-free code-review agents in parallel to audit the current
repository for bugs, misconfigurations, and gaps that existing tracked issues don't cover. Use this
procedure when asked for a "fresh eyes" sweep, to double-check nothing was missed after closing a
batch of issues, or to repeat a blank-slate repo check N times.

Repeatedly re-reading a codebase with full memory of what you already fixed causes anchoring: you
stop noticing problems adjacent to (or independent of) the ones you already know about. This skill
works around that by spawning several **independent agents with zero prior context**, each auditing
the repo from a blank slate, then reconciling their findings.

## When to use

- The user asks to "look for issues again" after a round of fixes, especially phrased as wanting a
  fresh/blank-slate perspective, or asks to repeat a check N times.
- Before closing out a body of work, as a final sanity sweep.

## Inputs

- `count` (optional, default **5**): how many independent audit passes to run. Take this from the
  user's phrasing (e.g. "5回", "three passes") or default to 5.
- Repo root: the current working directory's git repository, unless the user names another path.

## Procedure

1. **Orient once, briefly.** Confirm you're in a git repo (`git status`) and identify the GitHub
   remote (`gh repo view --json nameWithOwner` or `git remote -v`) so each subagent prompt can name
   the exact repo path and issue tracker to check. Do not read the source yourself first — this
   skill's value comes from the *subagents'* blank-slate read, not yours combined with theirs.

1. **Launch N parallel, fresh subagents in a single message.** Use the Agent tool with
   `subagent_type: "general-purpose"` (never `"fork"` — a fork inherits your context, which defeats
   the point) once per pass, all in one message so they run concurrently. Give every agent the same
   self-contained prompt — they must not see each other's results or your prior findings:

   > You are doing an independent, first-look audit of the repository at `<absolute path>`
   > (GitHub: `<owner/repo>`). It is a personal NixOS / nix-darwin / home-manager flake. You have no
   > prior context — investigate it as if you just cloned it.
   >
   > 1. Explore the repo structure (`flake.nix`, `src/utils`, `src/systems`, `src/home`) and read the
   >    modules relevant to how hosts and users are assembled.
   > 1. Confirm the current state without side effects: `nix fmt -- --fail-on-change` and, for each
   >    host in `nixosConfigurations`, `nix eval .#nixosConfigurations.<host>.config.system.build.toplevel.drvPath`.
   >    Record evaluation warnings. NEVER run `nixos-rebuild`, `darwin-rebuild`, `home-manager switch`,
   >    garbage collection, or anything that changes the machine.
   > 1. Run `gh issue list --state all --limit 50 --json number,title,state` and
   >    `gh pr list --state all --limit 50 --json number,title,state,headRefName` so you don't
   >    re-report something already tracked or already fixed via a merged PR.
   > 1. Independently look for real problems: deprecated or renamed options, settings that silently
   >    have no effect, host-specific values leaking into shared modules (or vice versa), duplicated
   >    or conflicting definitions between NixOS and home-manager, inconsistencies between hosts that
   >    look unintentional, packages installed twice, secrets or personal data committed in plain text,
   >    CI workflows that don't match the local commands, and documentation that doesn't match the code.
   >    Check option semantics against the locked sources (`nix flake archive --json` gives store paths),
   >    not memory.
   > 1. For each finding not already covered by an existing issue/PR, give a concrete file:line
   >    reference and a specific, reproducible scenario (which host, which evaluated value). If you can
   >    cheaply verify it with `nix eval`, do so and say so.
   >
   > Do NOT create issues or modify files — read-only research. Report findings in under 400 words,
   > or state plainly that you found nothing new.

1. **Wait for all N to report**, then reconcile in your own context:

   - Group findings that multiple passes independently surfaced — agreement across independent,
     zero-context runs is a strong confidence signal, much stronger than one pass's opinion.
   - Drop anything that turns out to already be covered by a tracked issue/PR (verify with `gh`
     yourself before dropping — a subagent can be wrong).
   - Discard anything that isn't a concrete, reproducible problem (style opinions, hypothetical
     concerns with no trigger, or things already fixed on `main`).

1. **Report to the user** (in Japanese, per `AGENTS.md`): a short deduped list of candidate issues,
   each with file:line, the scenario, and how many passes independently found it. Do not open GitHub
   issues, PRs, or write changes from these findings yourself — ask the user whether to file issues /
   fix them, unless they've already said to do so in the same request.

## Notes

- 5 passes is a reasonable default: enough to catch agent-to-agent variance without excessive cost.
  Scale down if the user asks.
- Each pass typically costs on the order of tens of thousands of tokens in its own isolated context;
  only its short final report lands in your context, so the orchestrating conversation stays cheap
  even as N grows.
- This skill is intentionally read-only. Creating issues, opening PRs, or editing code from its
  findings is a separate, explicit step — never bundle it into the audit itself.
