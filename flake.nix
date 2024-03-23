{
  description = "My NixOS's configuration for haruki7049";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/23.11";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    # "nixos-rebuild switch --flake .#tuf-chan"
    nixosConfigurations = {
      tuf-chan = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [./tuf-chan/configuration.nix];
      };
    };

    homeConfigurations = {
      "haruki@tuf-chan" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [./home-manager/home.nix];
      };
    };
  };
}
