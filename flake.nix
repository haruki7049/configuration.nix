{
  description = "My NixOS's configuration for haruki7049";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
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
      inherit
        (import ./system-builder.nix {
          inherit inputs;
        })
        x86_64-linux-pc
        aarch64-darwin-pc
        ;

      userhome-configs = ./src/home;
      overlays = [ ];
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;

      imports = [
        inputs.treefmt-nix.flakeModule
      ];

      flake = {
        darwinConfigurations = {
          enmac = aarch64-darwin-pc {
            systemConfiguration = ./src/systems/enmac/configuration.nix;
            inherit userhome-configs overlays;
          };
        };
        nixosConfigurations = {
          tuf-chan = x86_64-linux-pc {
            systemConfiguration = ./src/systems/tuf-chan/configuration.nix;
            inherit userhome-configs overlays;
          };
          dospara-chan = x86_64-linux-pc {
            systemConfiguration = ./src/systems/dospara-chan/configuration.nix;
            inherit userhome-configs overlays;
          };
          pana-chama = x86_64-linux-pc {
            systemConfiguration = ./src/systems/pana-chama/configuration.nix;
            inherit userhome-configs overlays;
          };
          spectre-chan = x86_64-linux-pc {
            systemConfiguration = ./src/systems/spectre-chan/configuration.nix;
            inherit userhome-configs overlays;
          };
          latitude-chan = x86_64-linux-pc {
            systemConfiguration = ./src/systems/latitude-chan/configuration.nix;
            inherit userhome-configs overlays;
          };
          the-hp = x86_64-linux-pc {
            systemConfiguration = ./src/systems/the-hp/configuration.nix;
            inherit userhome-configs overlays;
          };
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

            # Lua
            programs.stylua.enable = true;

            # ShellScripts
            programs.shellcheck.enable = true;
            programs.shfmt.enable = true;

            # GitHub Actions
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
              # lsp
              pkgs.nil
            ];
          };
        };
    };
}
