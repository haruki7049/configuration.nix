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
      users = import userhome-configs { inherit pkgs; };
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
      userhome-configs ? null,
    }:
    let
      users = import userhome-configs { inherit pkgs; };
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
        home-manager-settings
        systemConfiguration
        inputs.home-manager.darwinModules.home-manager
      ];
    };
}
