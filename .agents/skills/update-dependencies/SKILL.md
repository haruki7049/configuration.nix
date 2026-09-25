# Update Workflow: Nix Inputs and State Versions

All dependencies of `configuration.nix` are flake inputs pinned in `flake.lock`. CI (`cron-flake-update.yml`) already runs `nix flake update` on `main` every 12 hours, so manual updates are rarely needed.

## Picking up the latest `flake.lock` on a topic branch

Prefer merging `main` into the branch over running `nix flake update` yourself — it avoids a conflicting `flake.lock` later.

1. `git fetch origin && git merge origin/main` (never rebase a branch that exists on the remote).
1. Re-run the checks in `.agents/skills/pr-workflow/SKILL.md`.

## Updating inputs manually

Only when the user asks, or when a fix exists upstream that CI has not picked up yet.

1. Update the narrowest scope: `nix flake update <input>` (e.g. `nix flake update home-manager`) instead of all inputs.
1. Evaluate every host (`.agents/skills/verify/SKILL.md`). Read evaluation warnings — renamed/deprecated options show up there first.
1. Commit with `build: nix flake update` (or `build(flake.lock): update <input>`).

## Adding or removing an input

1. Edit `inputs` in `flake.nix`. Add `inputs.nixpkgs.follows = "nixpkgs";` when the input takes `nixpkgs`, matching existing inputs.
1. Run `nix flake lock` to add only the new entry.
1. Run `nix flake check --all-systems` (mirrors CI).

## `stateVersion`

`home.stateVersion` (`modules/home/linux/default.nix`, `modules/home/darwin/default.nix`, `modules/home/root.nix`) and `system.stateVersion` (`modules/nixos/common.nix`, `modules/darwin/common.nix`) are **not** routine updates. Changing them switches option defaults (e.g. home-manager's `mkStateVersionOptionDefault`) and may trigger data migrations. Treat as irreversible (`.agents/skills/irreversible/SKILL.md`): list the defaults that change, and confirm with the user first.
