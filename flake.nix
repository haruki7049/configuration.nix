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
    };
  };

  outputs = { self, systems, nixos, nixpkgs, nixos-wsl, home-manager, treefmt-nix, flake-utils, emacs-overlay, ... }:
    let
      eachSystem = f:
        nixpkgs.lib.genAttrs (import systems)
          (system: f nixpkgs.legacyPackages.${system});
      treefmtEval =
        eachSystem (pkgs: treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
      overlays = [ (import emacs-overlay) ];
    in
    {
      homeConfigurations = {
        "haruki7049" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { system = "x86_64-linux"; };
          modules = [ ./src/home/haruki.nix ];
        };
      };

      # "nixos-rebuild switch --flake .#tuf-chan"
      nixosConfigurations = {
        wsl-kun = nixos.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
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
            nixos-wsl.nixosModules.default
            {
              system.stateVersion = "24.05";
              wsl.enable = true;
              wsl.defaultUser = "haruki";

              nixpkgs = {
                config = {
                  permittedInsecurePackages = [ "electron-21.4.4" "electron-27.3.11" ];
                  allowUnfree = true;
                };
              };

              nix.settings.experimental-features = [ "nix-command" "flakes" ];


              services.openssh.enable = false;
            }
          ];
        };

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
        spectre-chan = nixos.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./src/spectre-chan/configuration.nix
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
        #raspi-chan = nixos.lib.nixosSystem {
        #  system = "aarch64-linux";
        #  modules = [
        #    ./src/raspi-chan/configuration.nix
        #    home-manager.nixosModules.home-manager
        #    {
        #      home-manager = {
        #        useGlobalPkgs = true;
        #        useUserPackages = true;
        #        users = {
        #          haruki = import ./src/home/haruki.nix;
        #          root = import ./src/home/root.nix;
        #        };
        #      };
        #    }
        #  ];
        #};
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

