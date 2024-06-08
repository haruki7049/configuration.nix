{ config, lib, pkgs, ... }:
{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-nox;
  };
  services.emacs = {
    enable = true;
    socketActivation.enable = true;
    defaultEditor = false;
    client.enable = true;
  };
}
