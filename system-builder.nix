{
  nixpkgs,
  nix-darwin,
  home-manager,
  emacs-overlay,
}:

{
  x86_64-linux-pc =
    {
      system ? "x86_64-linux",
      pkgs ? import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      },
      systemConfiguration,
      userhome-configs,
    }:
    let
      nixpkgs-overlay-settings = {
        nixpkgs.overlays = [
          emacs-overlay.overlays.emacs
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
    nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        nixpkgs-overlay-settings
        home-manager-settings
        systemConfiguration
        home-manager.nixosModules.home-manager
      ];
    };

  aarch64-darwin-pc =
    {
      system ? "aarch64-darwin",
      pkgs ? import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      },
      systemConfiguration,
    }:
    let
      nixpkgs-overlay-settings = {
        nixpkgs.overlays = [
          emacs-overlay.overlays.emacs
        ];
      };
    in
    nix-darwin.lib.darwinSystem {
      inherit system;
      modules = [
        nixpkgs-overlay-settings
        systemConfiguration
      ];
    };
}
