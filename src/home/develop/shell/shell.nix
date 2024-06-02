{ config, lib, pkgs, ... }:
{
  programs = {
    bash.enable = true;
    nushell.enable = true;
    fish.enable = true;
    zsh = {
      enable = true;
      dotDir = ".config/zsh";
    };
  };
}
