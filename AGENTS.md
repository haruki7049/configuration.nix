# Agent Guidelines for `configuration.nix`

This document defines core principles, repository layout, and non-negotiable safety rules for AI agents working on
the personal NixOS / nix-darwin / home-manager configuration of haruki7049. The entry point is `flake.nix`.

______________________________________________________________________

## 0. Language

- Always respond to the user in **Japanese**, regardless of the language of this file or of the user's message,
  because the owner of this repository, [@haruki7049](https://github.com/haruki7049), is a Japanese speaker.
  If you clone or reuse this repository, change this rule to suit yourself.
- Repository documentation, agent skills, code comments, commit messages, and PR descriptions are written in English.

______________________________________________________________________

## 1. Project Overview & Architecture

### Hosts

| Name | Kind | Config |
| --- | --- | --- |
| `tuf-chan` | x86_64-linux desktop (AMD GPU, multi-monitor) | `hosts/tuf-chan/` |
| `pana-chama` | x86_64-linux laptop | `hosts/pana-chama/` |
| `enmac` | aarch64-darwin (nix-darwin) | `hosts/enmac/` |

The user applies configurations themselves (e.g. `sudo nixos-rebuild switch --flake .#tuf-chan --print-build-logs`).

### Layout

The flake outputs are generated from the directory layout by [numtide/blueprint](https://github.com/numtide/blueprint)
(see its `docs/content/getting-started/folder_structure.md` in the locked source for the full mapping).

- `flake.nix` / `flake.lock`: Inputs (`nixpkgs` unstable, `blueprint`, `home-manager`, `nix-darwin`, `treefmt-nix`,
  `flake-compat`). `outputs` only calls blueprint (and drops the per-host closures blueprint adds to `checks`).
- `hosts/<host>/configuration.nix` (NixOS) / `hosts/<host>/darwin-configuration.nix` (nix-darwin): Host-specific system
  settings → `nixosConfigurations.<host>` / `darwinConfigurations.<host>`. Modules receive `flake`, `inputs`, `perSystem`
  and `hostName`.
- `hosts/<host>/users/<user>.nix`: home-manager configuration of `<user>` on `<host>`. blueprint wires home-manager in as a
  NixOS / nix-darwin module and also exposes each user as a standalone `legacyPackages.<system>.homeConfigurations."<user>@<host>"`.
- `modules/nixos/common.nix`, `modules/darwin/common.nix` → `nixosModules.common` / `darwinModules.common`: System settings
  shared across Linux / Darwin hosts.
- `modules/home/` → `homeModules.*`: home-manager settings shared by all hosts: `linux/` and `darwin/` (user `haruki`),
  `root.nix` (user `root`). Feature modules live under `modules/home/linux/develop/` (`editor`, `shell`, `windowManager`,
  `xdg`, ...).
- `treefmt.nix`: treefmt-nix configuration, used by `formatter.nix` (`nix fmt`), `devshell.nix` (`nix develop`) and
  `checks/treefmt.nix` (`checks.<system>.treefmt`).
- `scripts/`: Nushell scripts used by CI (pushing to Cachix).
- `.github/workflows/`: `nix-checker.yml` (`nix flake check --all-systems` on every push), `cron-flake-update.yml`
  (commits `build: nix flake update` to `main` every 12 hours), `cachix-push.yml` (pushes closures on `main`).
- **Development Environment**: `nix develop` / direnv (`.envrc`) / `shell.nix`. Formatting is `nix fmt` (treefmt-nix:
  nixfmt, taplo, shellcheck, shfmt).

### Host-specific home-manager settings

Everything under `modules/home/` is shared by all hosts and does not know the hostname. Values that should only apply
to a particular host (monitor layout, etc.) must not go into the shared modules; put them in that host's user file,
next to the import of the shared module:

```nix
# hosts/tuf-chan/users/haruki.nix
{ flake, ... }:
{
  imports = [ flake.homeModules.linux ];
  wayland.windowManager.hyprland.settings.monitor = [ ... ];
}
```

This leaves other hosts untouched.

Do not guess option schemas; read the locked source (see [`investigate`](.agents/skills/investigate/SKILL.md)).

______________________________________________________________________

## 2. Strict Safety & Operational Rules (Always Enforced)

- **NEVER APPLY CONFIGURATIONS**: AI agents **MUST NEVER** run `nixos-rebuild switch|boot|test`, `darwin-rebuild switch`,
  `home-manager switch`, or anything else that activates a configuration on the machine. Applying is the user's job.
- **NEVER MERGE PULL REQUESTS**: Merging PRs rests strictly with the human maintainer.
- **NEVER PROPOSE COMMITS OR PUSHES UNPROMPTED**: Do not prompt the user to commit or push, nor propose commit messages
  unprompted. When instructed by the user or when creating/updating pull requests on topic branches, agents may execute
  `git commit` and `git push` directly without seeking confirmation.
- **Never rewrite pushed history**: No rebase + force-push on branches that exist on the remote.
- **Verification Before Submitting**: All changes must pass `nix fmt -- --fail-on-change` and evaluate for every affected
  host (see [`verify`](.agents/skills/verify/SKILL.md)).
- **Conventional Commits**: Use conventional commit prefixes (`feat:`, `fix:`, `refactor:`, `docs:`, `build:`, `style:`),
  optionally with a scope (e.g. `feat(hyprland):`).
- **Evidence First**: Base all answers and actions on actual file contents and command output. Never speculate or assume.
- **Non-Destructive**: Never perform irreversible actions without explicit user approval
  (see [`irreversible`](.agents/skills/irreversible/SKILL.md)).
- **Targeted Edits**: Make minimal, logical changes strictly necessary for the request. Do not modify unrelated files,
  and do not modify or commit files the user placed for reference (e.g. untracked files in the repository root).

______________________________________________________________________

## 3. Status Assessment Workflow

When asked to check status, assess the situation, or understand workspace context:

1. **Local Git State**: Inspect working tree (`git status -s -b`) and recent commits (`git log -n 5 --oneline`).
   Note how far the current branch is behind `origin/main` (CI commits flake updates there every 12 hours).
1. **GitHub PRs (always display)**: List **all** open PRs (`gh pr list`) and check the current branch's PR (`gh pr status`).
   Never skip this step, even when the local state is clean.
1. **GitHub Issues (always display)**: List **all** open issues (`gh issue list`). Never skip this step.
1. **Environment Health**: `nix fmt -- --fail-on-change` and evaluation of each host (see [`verify`](.agents/skills/verify/SKILL.md)).
1. **Synthesis**: Report a concise, structured status covering local state, remote GitHub state, and environment health.
   The report **must** include the open PR and Issue lists (number, title, and state), or explicitly state that there are none.

______________________________________________________________________

## 4. Workspace Skills

Detailed runbooks and procedural workflows are maintained as workspace skills under `.agents/skills/`:

| Trigger / Context | Skill to Read | Purpose |
| :--- | :--- | :--- |
| Deep investigation, option schema lookup, complex code search | [`investigate`](.agents/skills/investigate/SKILL.md) | Non-destructive investigation guidelines |
| Commit conventions & policies | [`git-commit`](.agents/skills/git-commit/SKILL.md) | Commit conventions and prohibition of unprompted commit/push proposals |
| Deleting files, overwriting, git push/reset, activating configs | [`irreversible`](.agents/skills/irreversible/SKILL.md) | Pre-checks and confirmation prompts |
| Testing, verifying evaluation or generated files | [`verify`](.agents/skills/verify/SKILL.md) | Minimal, high-signal verification steps |
| Bumping `flake.lock`, adding inputs, `stateVersion` | [`update-dependencies`](.agents/skills/update-dependencies/SKILL.md) | Procedures for Nix input updates |
| Preparing PRs, formatting, pre-submission checks | [`pr-workflow`](.agents/skills/pr-workflow/SKILL.md) | Verification command table, commit rules, and PR requirements |
| "Fresh eyes" sweep for issues not already tracked, sanity-checking a batch of fixes | [`fresh-eyes-audit`](.agents/skills/fresh-eyes-audit/SKILL.md) | Parallel, context-free repo audits to surface gaps a single continuously-informed reviewer would miss |
