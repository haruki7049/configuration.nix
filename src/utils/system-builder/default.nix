{
  inputs,
}:

{
  x86_64-linux-pc =
    {
      system ? "x86_64-linux",
      overlays ? [ ],
      pkgs ? import inputs.nixpkgs {
        inherit system overlays;
        config.allowUnfree = true;
      },
      systemConfiguration,
      userhome-configs,
    }:
    let
      users = import userhome-configs { inherit pkgs overlays; };
      system-overlay-settings = {
        nixpkgs = { inherit overlays; };
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
        systemConfiguration
        system-overlay-settings
        inputs.home-manager.nixosModules.home-manager
      ];
    };

  aarch64-darwin-pc =
    {
      system ? "aarch64-darwin",
      overlays ? [ ],
      pkgs ? import inputs.nixpkgs {
        inherit system overlays;
        config.allowUnfree = true;
      },
      systemConfiguration,
      userhome-configs,
    }:
    let
      users = import userhome-configs { inherit pkgs overlays; };
      system-overlay-settings = {
        nixpkgs = { inherit overlays; };
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
        systemConfiguration
        system-overlay-settings
        inputs.home-manager.darwinModules.home-manager
      ];
    };

  home-configuration =
    {
      system,
      overlays ? [ ],
      pkgs ? import inputs.nixpkgs {
        inherit system overlays;
        config.allowUnfree = true;
      },
      userhome-configs,
    }:
    let
      system-overlay-settings = {
        nixpkgs = { inherit overlays; };
      };
    in
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        userhome-configs
        system-overlay-settings
      ];
    };
}
