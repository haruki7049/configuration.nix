{
  description = "My NixOS's configuration for haruki7049";

  inputs = {
    nixos.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos-wsl.url = "github:nix-community/nixos-wsl";
    home-manager.url = "github:nix-community/home-manager";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    flake-utils.url = "github:numtide/flake-utils";
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixos.follows = "nixos";
    };
  };

  outputs =
    { self
    , systems
    , nixos
    , nixpkgs
    , home-manager
    , treefmt-nix
    , emacs-overlay
    , ...
    }:
    let
      eachSystem = f:
        nixpkgs.lib.genAttrs (import systems)
          (system: f nixpkgs.legacyPackages.${system});
      treefmtEval =
        eachSystem (pkgs: treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
    in
    {
      nixosConfigurations =
        let
          x86_64-linux-pc = { system ? "x86_64-linux", systemConfiguration, userhome-configs }:
            nixos.lib.nixosSystem {
              inherit system;
              modules = [
                systemConfiguration
                home-manager.nixosModules.home-manager
                {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  users = userhome-configs;
                }
              ];
            };
        in
        {
          tuf-chan = x86_64-linux-pc {
            systemConfiguration = ./src/systems/tuf-chan/configuration.nix;
            userhome-configs = {
              haruki = import ./src/home/haruki.nix;
              root = import ./src/home/root.nix;
            };
          };
          pana-chama = x86_64-linux-pc {
            systemConfiguration = ./src/systems/pana-chama/configuration.nix;
            userhome-configs = {
              haruki = import ./src/home/haruki.nix;
              root = import ./src/home/root.nix;
            };
          };
          spectre-chan = x86_64-linux-pc {
            systemConfiguration = ./src/systems/spectre-chan/configuration.nix;
            userhome-configs = {
              haruki = import ./src/home/haruki.nix;
              root = import ./src/home/root.nix;
            };
          };
        };

      # Use `nix fmt`
      formatter =
        eachSystem (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);

      # Use `nix flake check`
      checks = eachSystem (pkgs: {
        formatting = treefmtEval.${pkgs.system}.config.build.check self;
      });
    };
}

