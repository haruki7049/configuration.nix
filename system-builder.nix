{
  inputs,
}:

{
  x86_64-linux-pc =
    {
      system ? "x86_64-linux",
      pkgs ? import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      },
      systemConfiguration,
      userhome-configs ? { },
    }:
    let
      users = builtins.mapAttrs (name: value: import value { inherit pkgs; }) userhome-configs;
      nixpkgs-overlay-settings = {
        nixpkgs.overlays = [
          inputs.emacs-overlay.overlays.emacs
        ];
      };
      home-manager-settings = {
        home-manager = {
          inherit users;
          useGlobalPkgs = true;
          useUserPackages = true;
        };
      };
    in
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        nixpkgs-overlay-settings
        home-manager-settings
        systemConfiguration
        inputs.home-manager.nixosModules.home-manager
      ];
    };

  aarch64-darwin-pc =
    {
      system ? "aarch64-darwin",
      pkgs ? import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      },
      systemConfiguration,
      userhome-configs ? { },
    }:
    let
      users = builtins.mapAttrs (name: value: import value { inherit pkgs; }) userhome-configs;
      nixpkgs-overlay-settings = {
        nixpkgs.overlays = [
          inputs.emacs-overlay.overlays.emacs
        ];
      };
      home-manager-settings = {
        home-manager = {
          inherit users;
          useGlobalPkgs = true;
          useUserPackages = true;
        };
      };
    in
    inputs.nix-darwin.lib.darwinSystem {
      inherit system;
      modules = [
        nixpkgs-overlay-settings
        home-manager-settings
        systemConfiguration
        inputs.home-manager.darwinModules.home-manager
      ];
    };
}
