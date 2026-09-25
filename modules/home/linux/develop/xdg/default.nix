{
  pkgs,
  ...
}:

{
  xdg = {
    portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    };

    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };
}
