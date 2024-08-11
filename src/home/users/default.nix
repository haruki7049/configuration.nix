{ pkgs, emacs-overlay }:

{
  haruki = import ./haruki.nix { inherit pkgs emacs-overlay; };
  root = import ./root.nix { inherit pkgs emacs-overlay; };
}
