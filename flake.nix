{
  description = "My NixOS's configuration for haruki7049";

  nixConfig = {
    extra-substituters = [ "https://haruki7049.cachix.org" ];
    extra-trusted-public-keys = [
      "haruki7049.cachix.org-1:Hd6hnIsYnpDDNhg/ZX06QkLBaCgDoatgNPqrFnUqhMk="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    blueprint = {
      url = "github:numtide/blueprint";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # The outputs are generated from the directory layout by blueprint:
  # https://github.com/numtide/blueprint
  outputs =
    inputs:
    let
      inherit (inputs.nixpkgs) lib;
      outputs = inputs.blueprint {
        inherit inputs;
        systems = [
          "x86_64-linux"
          "aarch64-darwin"
        ];
      };
    in
    outputs
    // {
      # blueprint adds every host's system closure to `checks` (`nixos-<host>`, `darwin-<host>`),
      # which would make `nix flake check` build them. The closures are built by cachix-push.yml
      # instead, and `nix flake check` still evaluates nixosConfigurations / darwinConfigurations.
      checks = lib.mapAttrs (
        _: lib.filterAttrs (name: _: !(lib.hasPrefix "nixos-" name || lib.hasPrefix "darwin-" name))
      ) outputs.checks;
    };
}
