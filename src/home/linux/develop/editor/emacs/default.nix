{
  pkgs,
  lib,
  ...
}:

{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-nox;
  };
}
