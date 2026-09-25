# Verify

Read this after making code, config, or documentation changes.

## Goal

Confirm the change with the smallest useful check.
Do not run broad, slow, or destructive verification without approval. Never activate a configuration to verify it.

## Choose verification

Prefer the narrowest check that matches the change:

- Any `.nix` change: `nix fmt -- --fail-on-change`, then evaluate the affected hosts
- Host config (`src/systems/<host>/`): evaluate that host
- Shared config (`src/home/`, `src/systems/common/`): evaluate every host of that platform
- Generated config file (Hyprland Lua, dotfiles via `xdg.configFile` / `home.file`): build that single file and read it
- Behaviour change: compare the generated output before and after, not only that evaluation succeeds
- Documentation change: check that commands and paths in the text exist and are correct

If the repo has documented verification commands (e.g. `.agents/skills/pr-workflow/SKILL.md`), prefer those.

## Commands

```bash
# Evaluate a whole host without building (lists derivations that would be built)
nix build .#nixosConfigurations.<host>.config.system.build.toplevel --dry-run
nix eval  .#nixosConfigurations.<host>.config.system.build.toplevel.drvPath
nix eval  .#darwinConfigurations.enmac.config.system.build.toplevel.drvPath

# Read one option's final value
nix eval .#nixosConfigurations.<host>.config.home-manager.users.haruki.<option.path>

# Build and read one generated file (cheap: a single text derivation)
nix build '.#nixosConfigurations.<host>.config.home-manager.users.haruki.xdg.configFile."hypr/hyprland.lua".source' -o result-hypr
cat result-hypr
```

Put `-o` output links in a scratch/temporary directory, or delete them afterwards — do not leave `result*` links in the repository.

Evaluation warnings (`trace: warning: ...`) count as findings: report them, especially deprecations and renamed options.

## Ask before running

Follow `.agents/skills/irreversible/SKILL.md` before broad, slow, state-changing, or unclear checks. A full `nix build` of a system toplevel (not `--dry-run`) can take a long time and a lot of disk; ask first.

If only a risky check can verify the change, explain the risk and ask.

## When verification is not possible

Do not pretend verification was done.

State:

- what was checked
- what was not checked (e.g. runtime behaviour after `switch`, Darwin build on Linux)
- why it was not checked
- the smallest useful next check

Use "Unverified" for anything not verified.

## Report format

End with:

- **Changed**: 1–3 lines
- **Verified**: command or check performed
- **Not verified**: unverified items, if any
- **Risk**: remaining risk, if any

## Do not

- run `nixos-rebuild switch` or any activation to "test" a change
- run broad builds just to look thorough
- claim success from unrelated checks
- hide failed checks or evaluation warnings
