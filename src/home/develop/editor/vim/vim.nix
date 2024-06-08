{ config, lib, pkgs, ... }:
{
  programs.vim = {
    enable = true;
    extraConfig = ''
      set number
      syntax on
      colorscheme desert
    '';
  };
}
