{ flake, ... }:

{
  imports = [ flake.homeModules.linux ];

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
