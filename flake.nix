{
  description = "My NixOS's configuration for haruki7049";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos-wsl.url = "github:nix-community/nixos-wsl";
    home-manager.url = "github:nix-community/home-manager";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      inherit (import ./system-builder.nix { inherit (inputs) nixpkgs emacs-overlay home-manager; }) x86_64-linux-pc;
    in
    {
      nixosConfigurations = {
        tuf-chan = x86_64-linux-pc {
          systemConfiguration = ./src/systems/tuf-chan/configuration.nix;
          userhome-configs = import ./src/home/users/default.nix;
        };
        pana-chama = x86_64-linux-pc {
          systemConfiguration = ./src/systems/pana-chama/configuration.nix;
          userhome-configs = import ./src/home/users/default.nix;
        };
        spectre-chan = x86_64-linux-pc {
          systemConfiguration = ./src/systems/spectre-chan/configuration.nix;
          userhome-configs = import ./src/home/users/default.nix;
        };
        latitude-chan = x86_64-linux-pc {
          systemConfiguration = ./src/systems/latitude-chan/configuration.nix;
          userhome-configs = import ./src/home/users/default.nix;
        };
      };
    } //
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;
      imports = [
        inputs.treefmt-nix.flakeModule
      ];
      perSystem = { pkgs, ... }: {
        treefmt = {
          projectRootFile = "flake.nix";
          programs.nixpkgs-fmt.enable = true;
          programs.taplo.enable = true;
          programs.stylua.enable = true;
          programs.actionlint.enable = true;
          settings.formatter = {
            "stylua".options = [
              "--indent-type"
              "Spaces"
            ];
          };
        };

        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.lua-language-server
            pkgs.nil
            pkgs.sops
          ];
        };
      };
    };
}
