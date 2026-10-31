{ flake, ... }:

{
  imports = [
    flake.homeModules.linux
    flake.homeModules.haruki
    flake.homeModules.common
  ];

  # Hyprland monitors for this host
  wayland.windowManager.hyprland.settings.monitor = [
    {
      output = "eDP-1";
      mode = "preffered";
      position = "auto";
      scale = 1.0;
    }
  ];
}
