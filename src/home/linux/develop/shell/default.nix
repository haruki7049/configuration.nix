{
  pkgs,
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
        eval "$(${pkgs.direnv}/bin/direnv hook bash)"
      '';
    };
    fish.enable = true;
    zsh = {
      enable = true;
      dotDir = ".config/zsh";
    };
  };
}
