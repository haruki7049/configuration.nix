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
      userhome-configs,
    }:
    let
      nixpkgs-overlay-settings = {
        nixpkgs.overlays = [
          inputs.emacs-overlay.overlays.emacs
        ];
      };
      home-manager-settings = {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users = userhome-configs { inherit pkgs; };
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
    }:
    let
      nixpkgs-overlay-settings = {
        nixpkgs.overlays = [
          inputs.emacs-overlay.overlays.emacs
        ];
      };
    in
    inputs.nix-darwin.lib.darwinSystem {
      inherit system;
      modules = [
        nixpkgs-overlay-settings
        systemConfiguration
      ];
    };
}
