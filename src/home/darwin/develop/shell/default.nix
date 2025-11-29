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
    bash.enable = true;
    fish.enable = true;
    zsh.enable = true;
  };
}
