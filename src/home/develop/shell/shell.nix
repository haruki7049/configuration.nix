{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs = {
    bash = {
      enable = true;
      bashrcExtra = ''
        eval "$(${pkgs.direnv}/bin/direnv hook bash)"
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
