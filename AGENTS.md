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
| `tuf-chan` | x86_64-linux desktop (AMD GPU, multi-monitor) | `src/systems/tuf-chan/` |
| `pana-chama` | x86_64-linux laptop | `src/systems/pana-chama/` |
| `enmac` | aarch64-darwin (nix-darwin) | `src/systems/enmac/` |

The user applies configurations themselves (e.g. `sudo nixos-rebuild switch --flake .#tuf-chan --print-build-logs`).

### Layout

- `flake.nix` / `flake.lock`: Inputs (`nixpkgs` unstable, `home-manager`, `nix-darwin`, `flake-parts`, `treefmt-nix`) and outputs
  (`nixosConfigurations`, `darwinConfigurations`, `homeConfigurations`, `formatter`, `checks`, `devShells`).
- `src/utils/system-builder/`: `build-system` / `build-home-manager`. home-manager is wired in as a NixOS / nix-darwin module.
- `src/systems/common/`: System settings shared across Linux / Darwin hosts.
- `src/systems/<host>/configuration.nix`: Host-specific system settings.
- `src/home/`: home-manager settings, split into `linux/` and `darwin/`. `src/home/linux/default.nix` defines the users
  (`haruki`, `root`). Feature modules live under `src/home/linux/develop/` (`editor`, `shell`, `windowManager`, `xdg`, ...).
- `scripts/`: Nushell scripts used by CI (pushing to Cachix).
- `.github/workflows/`: `nix-checker.yml` (`nix flake check --all-systems` on every push), `cron-flake-update.yml`
  (commits `build: nix flake update` to `main` every 12 hours), `cachix-push.yml` (pushes closures on `main`).
- **Development Environment**: `nix develop` / direnv (`.envrc`) / `shell.nix`. Formatting is `nix fmt` (treefmt-nix:
  nixfmt, taplo, shellcheck, shfmt).

### Host-specific home-manager settings

Everything under `src/home/` is shared by all hosts and does not know the hostname. Values that should only apply
to a particular host (monitor layout, etc.) must not go into the shared modules; inject them from that host's
`configuration.nix` through the NixOS option instead:

```nix
# src/systems/tuf-chan/configuration.nix
home-manager.users.haruki.wayland.windowManager.hyprland.settings.monitor = [ ... ];
```

This leaves other hosts and the standalone `homeConfigurations` untouched.

### Hyprland

- NixOS side: `programs.hyprland.enable` in `src/systems/common/linux-configuration.nix`.
- home-manager side: `src/home/linux/develop/windowManager/hyprland/default.nix`, using `configType = "lua"`
  (generates `~/.config/hypr/hyprland.lua`).
  - `settings.<name>` → `hl.<name>(...)`. A list value produces one call per element.
  - `{ _var = ...; }` → `local <name> = ...`.
  - `{ _args = [ ... ]; }` → a multi-argument call.
  - `lib.generators.mkLuaInline "..."` → a raw Lua expression.
  - `systemd.enable` generates the start/shutdown hooks automatically.
- Related tools: `src/home/linux/develop/windowManager/tools/` (hypridle, hyprpaper).
- Do not guess option schemas; read the locked source (see [`investigate`](.agents/skills/investigate/SKILL.md)).

______________________________________________________________________

## 2. Strict Safety & Operational Rules (Always Enforced)

- **NEVER APPLY CONFIGURATIONS**: AI agents **MUST NEVER** run `nixos-rebuild switch|boot|test`, `darwin-rebuild switch`,
  `home-manager switch`, or anything else that activates a configuration on the machine. Applying is the user's job.
- **NEVER AUTO-MERGE TO MAIN**: AI agents **MUST NEVER** merge PRs, merge into `main`, or push commits directly to `main`.
  Merging `main` *into a topic branch* to pick up a newer `flake.lock` is allowed.
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
- **Explicit Milestone Assignment Only**: Never attach GitHub Milestones to PRs or Issues unless explicitly requested.

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
