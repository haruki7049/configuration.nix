{
  pkgs,
  overlays ? [ ],
}:

let
  path = if pkgs.stdenv.hostPlatform.isLinux then ./linux else ./darwin;
in

import path {
  inherit pkgs overlays;
}
