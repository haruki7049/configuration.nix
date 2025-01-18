{
  pkgs,
  lib,
  ...
}:

{
  programs = {
    bash = {
      enable = true;
      bashrcExtra = ''
        eval "$(${lib.getExe pkgs.direnv} hook bash)"
      '';
    };
    nushell.enable = true;
    fish.enable = true;
    zsh = {
      enable = true;
      dotDir = ".config/zsh";
    };
  };
}
