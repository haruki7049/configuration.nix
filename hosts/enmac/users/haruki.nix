{ flake, ... }:

{
  imports = [
    flake.homeModules.darwin
    flake.homeModules.haruki
    flake.homeModules.common
  ];
}
