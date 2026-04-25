{
  description = "My NixOS's configuration for haruki7049";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      utils = import ./src/utils { inherit inputs; };
      userhome-configs = ./src/home;
      overlays = [ ];
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      imports = [
        inputs.treefmt-nix.flakeModule
      ];

      flake = {
        darwinConfigurations = {
          enmac = utils.system-builder.aarch64-darwin-pc {
            systemConfiguration = ./src/systems/enmac/configuration.nix;
            inherit userhome-configs overlays;
          };
        };
        nixosConfigurations = {
          tuf-chan = utils.system-builder.x86_64-linux-pc {
            systemConfiguration = ./src/systems/tuf-chan/configuration.nix;
            inherit userhome-configs overlays;
          };
          pana-chama = utils.system-builder.x86_64-linux-pc {
            systemConfiguration = ./src/systems/pana-chama/configuration.nix;
            inherit userhome-configs overlays;
          };
        };

        homeConfigurations.x86_64-linux = utils.system-builder.home-configuration {
          system = "x86_64-linux";
          inherit userhome-configs;
        };
        homeConfigurations.aarch64-linux = utils.system-builder.home-configuration {
          system = "aarch64-linux";
          inherit userhome-configs;
        };
        homeConfigurations.aarch64-darwin = utils.system-builder.home-configuration {
          system = "aarch64-darwin";
          inherit userhome-configs;
        };
      };

      perSystem =
        { pkgs, ... }:
        {
          treefmt = {
            projectRootFile = "flake.nix";

            # Nix
            programs.nixfmt.enable = true;

            # Toml
            programs.taplo.enable = true;

            # ShellScripts
            programs.shellcheck.enable = true;
            programs.shfmt.enable = true;
          };

          devShells.default = pkgs.mkShell {
            packages = [
              # lsp
              pkgs.nil
            ];
          };
        };
    };
}
