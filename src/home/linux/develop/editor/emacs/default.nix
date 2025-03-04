{
  pkgs,
  lib,
  ...
}:

{
  programs.emacs = {
    enable = true;
    package = pkgs.emacsWithPackagesFromUsePackage {
      package = pkgs.emacs-nox;
      config = ./init.el;
      defaultInitFile = true;
      alwaysEnsure = true;

      override = final: prev: {
        typst-mode = final.trivialBuild {
          pname = "typst-mode";
          version = "0-unstable-2023-09-25";

          src = pkgs.fetchFromGitHub {
            owner = "Ziqi-Yang";
            repo = "typst-mode.el";
            rev = "5776fd4f3608350ff6a2b61b118d38165d342aa3";
            hash = "sha256-mqkcNDgx7lc6kUSFFwSATRT+UcOglkeu+orKLiU9Ldg=";
          };

          packageRequires = [
            prev.polymode
          ];

          patches = [ ];

          meta = {
            description = "Emacs support for Typst";
            license = lib.licenses.gpl3;
            platforms = lib.platforms.all;
          };
        };
      };
    };
  };
}
