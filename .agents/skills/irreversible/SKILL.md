# Irreversible operations

Read this before running risky, destructive, or hard-to-revert operations.

## Goal

Prevent data loss, unwanted history changes, broken machines, and broad side effects.

## Never do (user-only)

These are never run by an agent, even with a confirmation prompt. Tell the user the command instead.

- `nixos-rebuild switch|boot|test`, `darwin-rebuild switch`, `home-manager switch`, or any other activation
- `nix-collect-garbage`, `nix store gc`, deleting generations or boot entries
- `cachix push` or anything that needs `CACHIX_AUTH_TOKEN`

## Treat as risky

Confirm before operations that may:

- delete or overwrite user-authored files
- change git history or push to remote (other than topic-branch pushes allowed by `.agents/skills/git-commit/SKILL.md`)
- modify files outside the repository (e.g. `~/.config/**`, `/etc/**`)
- change `home.stateVersion` / `system.stateVersion` (can change defaults and migrate data)
- touch secrets, SSH keys, or credentials referenced by the config
- change boot loader, file systems, `hardware-configuration.nix`, or networking of a host (a mistake can make it unbootable or unreachable)
- update `flake.lock` or add/remove flake inputs (see `.agents/skills/update-dependencies/SKILL.md`)
- apply broad formatting or auto-fixes outside the task scope

Judge deletion and overwrite risk by impact and recoverability, not by command name alone.

## Pre-check

Before asking for confirmation, check:

- current state, such as `git status`
- existing diff, such as `git diff`
- whether the target is tracked, generated, or user-authored
- whether a dry-run (`--dry-run`, `nix eval`), backup, narrower target, or single-host trial is available

## Confirmation format

Ask once, using this format:

- Action:
- Impact:
- Command:

`Proceed?`

Include recovery notes in `Impact` when relevant.

## Refuse to proceed

Do not proceed if:

- the target is unclear
- the impact cannot be explained
- recovery is unknown for a hard-to-restore target
- the command affects files outside the task scope
- unrelated user changes may be overwritten

Report the current status instead.
