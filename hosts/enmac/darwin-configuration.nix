{ flake, ... }:

{
  imports = [ flake.darwinModules.common ];

  nixpkgs.hostPlatform = "aarch64-darwin";
}
