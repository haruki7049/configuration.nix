{
  pkgs,
  lib,
  ...
}:

let
  wallpaper-path = "${pkgs.callPackage ../../wallpapers/use-nix_nixos.nix { }}";
in

{
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ wallpaper-path ];

      wallpaper = {
        monitor = "";
        path = wallpaper-path;
      };
    };
  };
}
