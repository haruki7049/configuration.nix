# Fails `nix flake check` when the tree is not formatted
{
  pkgs,
  inputs,
  flake,
  ...
}:

(inputs.treefmt-nix.lib.evalModule pkgs ../treefmt.nix).config.build.check flake
