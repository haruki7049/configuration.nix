# Agent Guidelines for `configuration.nix`

This document defines core principles, repository layout, and non-negotiable safety rules for AI agents working on
the personal NixOS / nix-darwin / home-manager configuration of haruki7049. The entry point is `flake.nix`.

Rules shared by all of haruki7049's repositories (language, Git & GitHub, working principles, status assessment) live
in [`modules/home/claude-code/CLAUDE.md`](modules/home/claude-code/CLAUDE.md), installed as `~/.claude/CLAUDE.md`.
Agents that do not load that file automatically must read it before working here. This document adds the rules
specific to this repository; where the two overlap, this document wins.

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

- `flake.nix` / `flake.lock`: Inputs (`nixpkgs` unstable, `blueprint`, `home-manager`, `nix-darwin`, `treefmt-nix`).
  `outputs` only calls blueprint (and drops the per-host closures blueprint adds to `checks`).
- `hosts/<host>/configuration.nix` (NixOS) / `hosts/<host>/darwin-configuration.nix` (nix-darwin): Host-specific system
  settings → `nixosConfigurations.<host>` / `darwinConfigurations.<host>`. Modules receive `flake`, `inputs`, `perSystem`
  and `hostName`.
- `hosts/<host>/users/<user>.nix`: home-manager configuration of `<user>` on `<host>`. blueprint wires home-manager in as a
  NixOS / nix-darwin module and also exposes each user as a standalone `legacyPackages.<system>.homeConfigurations."<user>@<host>"`.
- `modules/nixos/common.nix`, `modules/darwin/common.nix` → `nixosModules.common` / `darwinModules.common`: System settings
  shared across Linux / Darwin hosts.
- `modules/home/` → `homeModules.*`: home-manager settings shared by all hosts: `linux/` and `darwin/` (user `haruki`),
  `root.nix` (user `root`), `claude-code/` (Claude Code with the global `~/.claude/CLAUDE.md`, imported by `linux/`
  and `darwin/`). Feature modules live under `modules/home/linux/develop/` (`editor`, `shell`, `windowManager`,
  `xdg`, ...).
- `treefmt.nix`: treefmt-nix configuration, used by `formatter.nix` (`nix fmt`), `devshell.nix` (`nix develop`) and
  `checks/treefmt.nix` (`checks.<system>.treefmt`).
- `scripts/`: Nushell scripts used by CI (pushing to Cachix).
- `.github/workflows/`: `nix-checker.yml` (`nix flake check --all-systems` on every push), `cachix-push.yml`
  (pushes closures on `main`), `dependabot-auto-merge.yml` (enables auto-merge on Dependabot pull requests).
- `.github/dependabot.yml`: Dependabot opens a daily `build(deps):` pull request per outdated `flake.lock` input,
  which GitHub squash-merges once `nix-checker` passes.
- **Development Environment**: `nix develop` / direnv (`.envrc`). Formatting is `nix fmt` (treefmt-nix:
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
- **NEVER MERGE PULL REQUESTS**: Merging PRs, including enabling auto-merge (`gh pr merge --auto`), rests strictly with
  the human maintainer. Only Dependabot pull requests are auto-merged, by `dependabot-auto-merge.yml`.
- **Verification Before Submitting**: All changes must pass `nix fmt -- --fail-on-change` and evaluate for every affected
  host (see [`verify`](.agents/skills/verify/SKILL.md)).
- **Irreversible operations**: See [`irreversible`](.agents/skills/irreversible/SKILL.md) for what is never run by an
  agent here (activation, garbage collection, Cachix pushes) and what needs confirmation.

______________________________________________________________________

## 3. Status Assessment Workflow

Follow the status assessment in the shared rules, with these repository specifics:

- **Local Git State**: Note how far the current branch is behind `origin/main` (merged Dependabot `flake.lock` updates
  land there).
- **Environment Health**: `nix fmt -- --fail-on-change` and evaluation of each host (see
  [`verify`](.agents/skills/verify/SKILL.md)).

______________________________________________________________________

## 4. Workspace Skills

Detailed runbooks and procedural workflows are maintained as workspace skills under `.agents/skills/`:

| Trigger / Context | Skill to Read | Purpose |
| :--- | :--- | :--- |
| Deep investigation, option schema lookup, complex code search | [`investigate`](.agents/skills/investigate/SKILL.md) | Non-destructive investigation guidelines |
| Commit conventions & policies | [`git-commit`](.agents/skills/git-commit/SKILL.md) | Commit scopes, examples and handling of stale branches |
| Deleting files, overwriting, git push/reset, activating configs | [`irreversible`](.agents/skills/irreversible/SKILL.md) | Pre-checks and confirmation prompts |
| Testing, verifying evaluation or generated files | [`verify`](.agents/skills/verify/SKILL.md) | Minimal, high-signal verification steps |
| Bumping `flake.lock`, adding inputs, `stateVersion` | [`update-dependencies`](.agents/skills/update-dependencies/SKILL.md) | Procedures for Nix input updates |
| Preparing PRs, formatting, pre-submission checks | [`pr-workflow`](.agents/skills/pr-workflow/SKILL.md) | Verification command table, commit rules, and PR requirements |
| "Fresh eyes" sweep for issues not already tracked, sanity-checking a batch of fixes | [`fresh-eyes-audit`](.agents/skills/fresh-eyes-audit/SKILL.md) | Parallel, context-free repo audits to surface gaps a single continuously-informed reviewer would miss |
