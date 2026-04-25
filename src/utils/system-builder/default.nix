{
  inputs,
}:

let
  build-x86_64-linux-system =
    {
      system,
      overlays,
      pkgs,
      system-configuration,
      userhome-configuration,
    }:
    let
      users = import userhome-configuration {
        inherit pkgs overlays;
      };
      system-overlay-settings = {
        nixpkgs.overlays = overlays;
      };
      home-manager-settings = {
        home-manager = {
          inherit users;
          useUserPackages = true;
        };
      };
    in
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        home-manager-settings
        system-configuration
        system-overlay-settings
        inputs.home-manager.nixosModules.home-manager
      ];
    };

  build-aarch64-darwin-system =
    {
      system,
      overlays,
      pkgs,
      system-configuration,
      userhome-configuration,
    }:
    let
      users = import userhome-configuration {
        inherit pkgs overlays;
      };
      system-overlay-settings = {
        nixpkgs.overlays = overlays;
      };
      home-manager-settings = {
        home-manager = {
          inherit users;
          useUserPackages = true;
        };
      };
    in
    inputs.nix-darwin.lib.darwinSystem {
      inherit system;
      modules = [
        home-manager-settings
        system-configuration
        system-overlay-settings
        inputs.home-manager.darwinModules.home-manager
      ];
    };

in

{
  build-system =
    {
      system,
      overlays ? [ ],
      config ? { },
      pkgs ? import inputs.nixpkgs {
        inherit system overlays config;
      },

      system-configuration,
      userhome-configuration,
    }:
    if system == "x86_64-linux" then
      build-x86_64-linux-system {
        inherit
          system
          overlays
          pkgs
          system-configuration
          userhome-configuration
          ;
      }
    else if system == "aarch64-darwin" then
      build-aarch64-darwin-system {
        inherit
          system
          overlays
          pkgs
          system-configuration
          userhome-configuration
          ;
      }
    else
      throw "Unsupported system: " + system;

  build-home-manager =
    {
      system,
      overlays ? [ ],
      configs ? { },
      pkgs ? import inputs.nixpkgs {
        inherit system overlays configs;
      },
      userhome-configuration,
    }:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [ userhome-configuration ];
    };
}
