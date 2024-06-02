{ config, lib, pkgs, ... }:
{
  xdg = {
    userDirs = {
      enable = true;
      createDirectories = false;
    };
  };
}
