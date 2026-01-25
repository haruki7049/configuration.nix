{
  pkgs,
  lib,
  ...
}:

{
  services.hyprpaper = {
    enable = true;
    settings.wallpaper = {
      path = "${pkgs.callPackage ../../wallpapers/use-nix_nixos.nix { }}";
    };
  };
}
