{ pkgs }:

{
  haruki = import ./haruki.nix { inherit pkgs; };
  root = import ./root.nix { inherit pkgs; };
}
