{
  flake,
  lib,
  pkgs,
  ...
}:

let
  cli-apps = [
    pkgs.htop
    pkgs.wget
    pkgs.curl
    pkgs.unzip
    pkgs.gzip
    pkgs.git
    pkgs.ghq # Local git repository management CLI tool
    pkgs.gh # GitHub CLI
    pkgs.antigravity-cli
    pkgs.deno # For Vim denops
    pkgs.vim-full
    pkgs.cyanrip # CD ripping tool
  ];

  browsers = [
    pkgs.google-chrome
    pkgs.brave
  ];

  communication = [
    # pkgs.discord # 2026-09-27: launching shows "Discord is damaged and can't be
    # opened" on enmac (aarch64-darwin). `codesign --verify --deep --strict` reports
    # the bundle as valid, so this isn't a local signature corruption; it's likely
    # caused by nixpkgs' fixDistroSymlinks step during the darwin build altering the
    # bundle enough that Gatekeeper flags the stapled notarization ticket as tampered.
    # Re-signing ad-hoc (codesign --remove-signature && codesign --force --deep --sign -)
    # did not fix it. Re-enable once this is resolved upstream in nixpkgs.
    pkgs.slack
  ];

  productivity = [
    pkgs.obsidian
    pkgs.bitwarden-desktop
    pkgs.kitty
  ];

  media-and-games = [
    pkgs.audacity
    pkgs.spotify
    pkgs.prismlauncher
  ];
in

{
  imports = [
    flake.homeModules.claude-code
    ./editor
    ./tools
    ./shell
  ];

  home.packages = cli-apps ++ browsers ++ communication ++ productivity ++ media-and-games;

  # Inside NixOS / nix-darwin, home-manager sets nix.package from the system; this default only
  # applies to the standalone homeConfigurations, where nix.settings would otherwise have no package.
  nix.package = lib.mkDefault pkgs.nix;
  nix.settings = {
    accept-flake-config = true;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  nixpkgs.config.allowUnfree = true;

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;

      # Shell integration
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
    };
    zellij = {
      enable = true;
      settings = {
        theme = "cyber-noir";
        themes = {
          cyber-noir = {
            bg = "#0b0e1a";
            fg = "#91f3e4";
            red = "#ff578d";
            green = "#00ff00";
            blue = "#3377ff";
            yellow = "#ffd700";
            magenta = "#ff00ff";
            orange = "#ff7f50";
            cyan = "#00e5e5";
            black = "#000000";
            white = "#91f3e4";
          };

          everforest-dark-medium = {
            fg = "#d3c6aa";
            bg = "#2f383e";
            black = "#4a555b";
            red = "#d6494d";
            green = "#a7c080";
            yellow = "#dbbc7f";
            blue = "#7fbbb3";
            magenta = "#d699b6";
            cyan = "#83c092";
            white = "#a7c080";
            orange = "#e69875";
          };
        };
      };
    };
  };
}
