{
  pkgs,
  ...
}:

{
  programs.zsh = {
    enable = true;
    initContent = ''
      ${pkgs.any-nix-shell}/bin/any-nix-shell zsh --info-right | source /dev/stdin
    '';
  };
}
