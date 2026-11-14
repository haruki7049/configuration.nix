{ lib, ... }:

{
  home = {
    username = "root";
    homeDirectory = lib.mkForce "/root";
  };
}
