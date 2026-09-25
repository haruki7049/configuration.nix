# Pull Request & Commit Workflow for `configuration.nix`

This skill defines the procedures for verification, commit creation, and pull request submission.

## 1. Mandatory Verification Steps

Before committing or opening a PR, execute the following commands and ensure all pass cleanly:

| Task | Command | Description |
| :--- | :--- | :--- |
| **Check Formatting** | `nix fmt -- --fail-on-change` | treefmt check (nixfmt, taplo, shellcheck, shfmt) |
| **Format All Files** | `nix fmt` | Auto-formats the repository |
| **Evaluate tuf-chan** | `nix build .#nixosConfigurations.tuf-chan.config.system.build.toplevel --dry-run` | Evaluates the desktop without building |
| **Evaluate pana-chama** | `nix build .#nixosConfigurations.pana-chama.config.system.build.toplevel --dry-run` | Evaluates the laptop without building |
| **Evaluate enmac** | `nix eval .#darwinConfigurations.enmac.config.system.build.toplevel.drvPath` | Darwin host; evaluation only when on Linux |
| **Nix Flake Check** | `nix flake check --all-systems` | Mirrors `nix-checker.yml` CI; run when `flake.nix`/`flake.lock`/`src/utils` change |

Evaluate every host the change can reach: a change under `src/home/` or `src/systems/common/` affects all hosts of that platform. See `.agents/skills/verify/SKILL.md` for inspecting generated files.

## 2. Commit & PR Title Conventions

Use Conventional Commits style prefixes, optionally with a scope:

- `feat:` New program, service, or setting.
- `fix:` Fixes to broken or wrong settings.
- `build:` Updates to `flake.nix`, `flake.lock`, `src/utils`, CI workflows, or `scripts/`.
- `refactor:` Restructuring without changing the resulting configuration.
- `docs:` Updates to README, AGENTS.md, skills, or comments.
- `style:` Formatting only (`nix fmt`).

**Do NOT include issue numbers (e.g., `(#24)` or `#24`) in commit messages or PR titles.** Issue linkage must be done exclusively in the PR description using explicit issue-closing keywords (e.g. `Closes #24`).

**Language**: Write all commit messages, PR titles, PR descriptions, and repository documentation in English.

## 3. PR Description Requirements

Ensure the PR description includes:

- **Summary**: Concise overview of changes.
- **Affected hosts**: Which of `tuf-chan`, `pana-chama`, `enmac`, and standalone `homeConfigurations` are affected.
- **Linked Issue / Closes Statement**: Always include an explicit issue-closing keyword (e.g. `Closes #16`) when resolving an open issue.
- **Verification**: Explicitly list executed verification commands and their success status. State that nothing was activated (`nixos-rebuild switch` is left to the user).
- **Manual steps**: Anything the user must do when switching (e.g. move a hand-placed file out of `~/.config` so home-manager can take it over).

## 4. Strict Safety & Approval Rules

- **NEVER AUTO-MERGE TO MAIN**: AI agents **MUST NEVER** merge PRs, merge into `main`, or push commits directly to `main`.
- **NEVER PROPOSE COMMITS OR PUSHES UNPROMPTED**: AI agents **MUST NEVER** prompt the user to commit or push unprompted. When instructed by the user or when preparing pull requests on topic branches, agents may execute `git commit` and `git push` directly.
- **NEVER APPLY CONFIGURATIONS**: No `nixos-rebuild switch` / `darwin-rebuild switch` / `home-manager switch`.
- **Mandatory Human Approval**: AI agents may create branches, create commits, push topic branches, propose PRs, format code, and evaluate configurations, but merging into `main` and activating configurations rest strictly with the human maintainer.
- **Explicit Milestone Assignment Only**: AI agents **MUST NEVER** automatically attach or set GitHub Milestones on Pull Requests or Issues unless explicitly requested or instructed by the user.
