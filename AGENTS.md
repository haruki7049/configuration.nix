# AGENTS.md

haruki7049 個人の NixOS / nix-darwin / home-manager 設定リポジトリ。エントリポイントは `flake.nix`。

## ホスト

| 名前 | 種別 | 設定 |
| --- | --- | --- |
| `tuf-chan` | x86_64-linux デスクトップ (AMD GPU, マルチモニタ) | `src/systems/tuf-chan/` |
| `pana-chama` | x86_64-linux ノートPC | `src/systems/pana-chama/` |
| `enmac` | aarch64-darwin (nix-darwin) | `src/systems/enmac/` |

適用はユーザーが行う（例: `sudo nixos-rebuild switch --flake .#tuf-chan --print-build-logs`）。
エージェントは `nixos-rebuild switch` / `darwin-rebuild switch` を実行しないこと。

## ディレクトリ構成

- `src/utils/system-builder/` — `build-system` / `build-home-manager`。home-manager は NixOS / nix-darwin モジュールとして組み込まれる。
- `src/systems/common/` — Linux / Darwin 共通のシステム設定。
- `src/systems/<host>/configuration.nix` — ホスト固有のシステム設定。
- `src/home/` — home-manager 設定。`linux/` と `darwin/` に分かれ、`src/home/linux/default.nix` がユーザー (`haruki`, `root`) を定義する。
  - `src/home/linux/develop/` 以下に機能ごとのモジュール (`editor`, `shell`, `windowManager`, `xdg` など)。
- `scripts/` — CI 用 Nushell スクリプト（Cachix へのプッシュ）。

## ホスト固有の home-manager 設定

`src/home/` の設定は全ホスト共通で、ホスト名を知らない。特定ホストだけに効かせたい値（モニター構成など）は
共通モジュールに書かず、そのホストの `configuration.nix` から NixOS オプション経由で注入する:

```nix
# src/systems/tuf-chan/configuration.nix
home-manager.users.haruki.wayland.windowManager.hyprland.settings.monitor = [ ... ];
```

こうすると他のホストや standalone の `homeConfigurations` には影響しない。

## Hyprland

- NixOS 側: `src/systems/common/linux-configuration.nix` の `programs.hyprland.enable`。
- home-manager 側: `src/home/linux/develop/windowManager/hyprland/default.nix`。
- 周辺ツール: `src/home/linux/develop/windowManager/tools/` (hypridle, hyprpaper)。
- home-manager の Hyprland モジュールは `configType = "lua"` で `~/.config/hypr/hyprland.lua` を生成できる。
  - `settings.<name>` → `hl.<name>(...)`。リストは要素ごとに 1 呼び出し。
  - `{ _var = ...; }` → `local <name> = ...`。
  - `{ _args = [ ... ]; }` → 複数引数呼び出し。
  - `lib.generators.mkLuaInline "..."` → 生の Lua 式。
  - `systemd.enable` で起動/終了フックが自動生成される。
- スキーマは推測せず、ロックされた home-manager のソースを読んで確認する:

```bash
nix flake archive --json | nix run nixpkgs#jq -- -r '.inputs["home-manager"].path'
# → <path>/modules/services/window-managers/hyprland/{default.nix,lib.nix}
```

- 既存の手書き設定を移植するときは、生成物を実際にビルドして元ファイルと突き合わせる（下記「検証」）。

## 検証

変更後は少なくとも以下を実行する。すべて副作用なし。

```bash
nix fmt   # nixfmt / taplo / shellcheck / shfmt (treefmt)

# システム全体の評価
nix build .#nixosConfigurations.tuf-chan.config.system.build.toplevel --dry-run
nix eval  .#nixosConfigurations.pana-chama.config.system.build.toplevel.drvPath

# home-manager が生成する個別ファイルの中身を確認する例
nix build '.#nixosConfigurations.tuf-chan.config.home-manager.users.haruki.xdg.configFile."hypr/hyprland.lua".source' -o result-hypr
cat result-hypr
```

共通モジュールを変更した場合は全ホストで評価すること。Darwin (`enmac`) は Linux 上では評価しか確認できない。

## Git

- `main` には CI (`cron-flake-update`) が 12 時間ごとに `build: nix flake update` をコミットする。作業ブランチは古くなりやすいので、
  最新の `flake.lock` が必要なら `main` をマージする（リモートにあるブランチは rebase + force push しない）。
- コミットメッセージは Conventional Commits 風 (`feat(hyprland): ...`, `fix: ...`, `style: nix fmt`, `build: ...`)。
- ブランチを切ってコミットする。`main` へ直接コミットしない。プッシュは指示されたときだけ。
- ユーザーが参照用に置いたファイル（リポジトリ直下の未追跡ファイルなど）は変更・コミットしない。
