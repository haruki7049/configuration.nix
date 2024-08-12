{ nixpkgs, home-manager, emacs-overlay }:

{
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
}
