# Git Commit Conventions

Read this for the commit conventions specific to `configuration.nix`. The general commit and push policy (no unprompted
proposals, Conventional Commits, staging only the files you changed, never rewriting pushed history) is in
[`modules/home/claude-code/CLAUDE.md`](../../../modules/home/claude-code/CLAUDE.md).

## Stale Branches

Dependabot `flake.lock` updates are merged into `main` regularly. If a topic branch needs a newer `flake.lock`, merge
`main` into it.

## Commit Messages

- Prefixes and what they cover are listed in `.agents/skills/pr-workflow/SKILL.md`. Scope with the program or host
  where it helps, such as `feat(hyprland):` or `fix(tuf-chan):`.
- **Do NOT include issue numbers (e.g., `(#24)` or `#24`) anywhere in the commit message**, summary or body. Squash
  merges copy every commit message into `main`, so a `Closes #24` in a commit body can close the wrong issue. Link
  issues only from the PR description.

Examples:

- `feat(hyprland): move monitor settings to tuf-chan host config`
- `fix(pana-chama): enable fprintd`
- `build: nix flake update`
- `style: nix fmt`
