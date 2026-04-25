{
  pkgs,
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
    zsh.initContent = ''
      ${pkgs.any-nix-shell}/bin/any-nix-shell zsh --info-right | source /dev/stdin
    '';
  };
}
