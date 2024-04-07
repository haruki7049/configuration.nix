{
  description = "My NixOS's configuration for haruki7049";

  inputs = {
    nixos.url = "github:NixOS/nixpkgs";
    nixpkgs.url = "github:NixOS/nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs = { self, systems, nixos, nixpkgs, home-manager, treefmt-nix }:
    let
      eachSystem = f:
        nixpkgs.lib.genAttrs (import systems)
        (system: f nixpkgs.legacyPackages.${system});
      treefmtEval =
        eachSystem (pkgs: treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
    in {
      # "nixos-rebuild switch --flake .#tuf-chan"
      nixosConfigurations = {
        tuf-chan = nixos.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./src/tuf-chan/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users = {
                  haruki = import ./src/home/haruki.nix;
                  root = import ./src/home/root.nix;
                };
              };
            }
          ];
        };
        pana-chama = nixos.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./src/pana-chama/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users = {
                  haruki = import ./src/home/haruki.nix;
                  root = import ./src/home/root.nix;
                };
              };
            }
          ];
        };
        haruki7049-home = nixos.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./src/haruki7049-home/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users = {
                  haruki = import ./src/home/haruki.nix;
                  root = import ./src/home/root.nix;
                };
              };
            }
          ];
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

