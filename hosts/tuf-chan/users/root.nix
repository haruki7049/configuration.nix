{ flake, ... }:

{
  imports = [
    flake.homeModules.linux
    flake.homeModules.root
    flake.homeModules.common
  ];
}
