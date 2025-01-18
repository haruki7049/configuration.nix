{
  pkgs,
  lib ? pkgs.lib,
  stdenv ? pkgs.stdenv,
}:

let
  path = if stdenv.isLinux then ./linux else ./darwin;
in

import path {
  inherit pkgs;
}
