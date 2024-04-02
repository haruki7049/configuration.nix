{
  description = "My NixOS's configuration for haruki7049";

  inputs.nixos.url = "github:NixOS/nixpkgs/nixos-23.11";

  outputs = { self, nixos }:
  let
    eachSystem = f:
      nixpkgs.lib.genAttrs (import systems)
      (system: f nixpkgs.legacyPackages.${system});
    treefmtEval =
      eachSystem (pkgs: treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
  in
  {
    # "nixos-rebuild switch --flake .#tuf-chan"
    nixosConfigurations = {
      tuf-chan = nixos.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./src/tuf-chan/configuration.nix ];
      };
      pana-chama = nixos.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./src/pana-chama/configuration.nix ];
      };
      haruki7049-home = nixos.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./src/haruki7049-home/configuration.nix ];
      };
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
