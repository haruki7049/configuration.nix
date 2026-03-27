{
  pkgs,
  lib,
  ...
}:

let
  wallpaper-path = "${pkgs.callPackage ../../wallpapers/beef-bowl.nix { }}";
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
