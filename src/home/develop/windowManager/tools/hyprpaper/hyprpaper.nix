{ lib, ... }:
{
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;

      preload = [
        (builtins.toString ../../wallpapers/fanta-hhkb.jpg)
      ];

      wallpaper = [
        (lib.strings.concatStrings [
          ","
          (builtins.toString ../../wallpapers/fanta-hhkb.jpg)
        ])
      ];
    };
  };
}
