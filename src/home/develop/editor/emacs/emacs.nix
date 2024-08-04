{ pkgs
, emacs-src
, emacs-drv ? import ./emacs-drv/drv.nix
, ...
}:
let
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
