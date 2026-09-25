# Git Commit Policy & Conventions

Read this to understand the commit policy and message conventions for `configuration.nix`.

## Prohibition on Unprompted Commit/Push Proposals

- **Execution is allowed**: When instructed by the user, or when creating and updating pull requests on topic branches, AI agents may execute `git commit` and `git push` directly.
- **Do NOT propose or prompt for commits or pushes**: AI agents must never prompt the user to commit or push unprompted, nor ask for confirmation (e.g., do NOT ask "Would you like me to commit and push?").
- **Do NOT include unprompted commit message proposals**: Do NOT append "Proposed commit message" or commit/push suggestion sections at the end of a response unless explicitly asked by the user.
- **Stale branches**: CI commits `build: nix flake update` to `main` every 12 hours. If a topic branch needs a newer `flake.lock`, merge `main` into it. Never rebase + force-push a branch that exists on the remote.

## Commit Message Conventions

Follow the repository convention (see `.agents/skills/pr-workflow/SKILL.md`):

- Use Conventional Commits style prefixes (`feat:`, `fix:`, `build:`, `refactor:`, `docs:`, `style:`), optionally with a scope such as `feat(hyprland):` or `fix(tuf-chan):`.
- English, imperative mood, short summary, under 72 characters, no trailing period.
- **Do NOT include issue numbers (e.g., `(#24)` or `#24`) in the commit summary.** Issue linkage must be done exclusively in the PR description using explicit issue-closing keywords (e.g. `Closes #24`).
- Stage only the files you changed for the task (`git add <path>`), never `git add -A` — the user may keep untracked reference files in the working tree.

Examples:

- `feat(hyprland): move monitor settings to tuf-chan host config`
- `fix(pana-chama): enable fprintd`
- `build: nix flake update`
- `style: nix fmt`
