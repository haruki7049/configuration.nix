{
  pkgs,
  overlays ? [ ],
}:

let
  path = if pkgs.stdenv.isLinux then ./linux else ./darwin;
in

import path {
  inherit pkgs overlays;
}
