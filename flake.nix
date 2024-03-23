{
  description = "My NixOS's configuration for haruki7049";

  inputs = {
    # NixOS
    nixos.url = "github:NixOS/nixpkgs/nixos-23.11";

    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixos, nixpkgs, home-manager }: {
    # "nixos-rebuild switch --flake .#tuf-chan"
    nixosConfigurations = {
      tuf-chan = nixos.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./tuf-chan/configuration.nix ];
      };
    };

    homeConfigurations = {
      haruki = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [ ./home-manager/haruki/home.nix ];
      };
      root = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [ ./home-manager/root.nix ];
      };
    };
  };
}
