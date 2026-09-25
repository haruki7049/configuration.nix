# `nix develop`
{ pkgs, inputs, ... }:

pkgs.mkShell {
  nativeBuildInputs = [
    pkgs.nil # Nix LSP
    pkgs.nushell # Script runner
    pkgs.cachix # cachix CLI
  ];
  inputsFrom = [ (inputs.treefmt-nix.lib.evalModule pkgs ./treefmt.nix).config.build.devShell ];
}
