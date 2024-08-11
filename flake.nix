{
  description = "My NixOS's configuration for haruki7049";

  inputs = {
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
          x86_64-linux-pc = { system ? "x87_64-linux", systemConfiguration, userhome-configs }:
            let
              overlays = [
                (import emacs-overlay)
              ];
              pkgs = import nixpkgs {
                inherit system overlays;
                config.allowUnfree = true;
              };
            in
            nixpkgs.lib.nixosSystem {
              inherit system;
              modules = [
                systemConfiguration
                home-manager.nixosModules.home-manager
                {
                  home-manager = {
                    useGlobalPkgs = true;
                    useUserPackages = true;
                    users = userhome-configs {
                      inherit pkgs;
                    };
                  };
                }
              ];
            };
        in
        {
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

