{
  pkgs,
  ...
}:

{
  xdg = {
    portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-gnome
        pkgs.xdg-desktop-portal-hyprland
      ];
    };

    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };
}
