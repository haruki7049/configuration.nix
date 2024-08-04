{ pkgs, emacs-src, ... }:
let
  emacs-drv = import ./emacs-drv/drv.nix {
    inherit pkgs emacs-src;
    version = "29.4";
  };
  emacsConfig = builtins.readFile ./init.el;
  emacsExtraPackages = epkgs: with epkgs; [
    ef-themes
    eglot
    treemacs
    slime
    rust-mode
    zig-mode
    nix-mode
    envrc
    ddskk
  ];
in
{
  programs.emacs = {
    enable = true;
    extraConfig = emacsConfig;
    extraPackages = emacsExtraPackages;
    package = emacs-drv;
  };
}
