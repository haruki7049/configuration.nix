{
  pkgs,
  ...
}:

let
  emacsConfig = builtins.readFile ./init.el;
  emacsExtraPackages =
    epkgs: with epkgs; [
      dracula-theme
      eglot
      neotree
      slime
      rust-mode
      zig-mode
      nix-mode
      envrc
      ddskk
      vertico
    ];
in
{
  programs.emacs = {
    enable = true;
    extraConfig = emacsConfig;
    extraPackages = emacsExtraPackages;
    package = pkgs.emacs-nox;
  };
}
