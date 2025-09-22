{
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./nushell
  ];

  programs = {
    bash = {
      enable = true;
      bashrcExtra = ''
        eval "$(${lib.getExe pkgs.direnv} hook bash)"
      '';
    };
    fish.enable = true;
    zsh.enable = true;
  };
}
