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
    };
  };

  outputs =
    { self
    , systems
    , nixpkgs
    , home-manager
    , flake-utils
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
          x86_64-linux-pc =
            { system ? "x86_64-linux"
            , pkgs ? import nixpkgs {
                inherit system;
                config.allowUnfree = true;
              }
            , systemConfiguration
            , userhome-configs
            }:
            let
              nixpkgs-overlay-settings = {
                nixpkgs.overlays = [
                  emacs-overlay.overlays.emacs
                ];
              };
            in
            nixpkgs.lib.nixosSystem {
              inherit system;
              modules = [
                nixpkgs-overlay-settings
                systemConfiguration
                home-manager.nixosModules.home-manager
                {
                  home-manager = {
                    useGlobalPkgs = true;
                    useUserPackages = true;
                    users = userhome-configs { inherit pkgs; };
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
    } //
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
      treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
    in
    {
      # Use `nix fmt`
      formatter =
        treefmtEval.config.build.wrapper;

      # Use `nix flake check`
      checks = {
        formatting = treefmtEval.config.build.check self;
      };
    });
}

