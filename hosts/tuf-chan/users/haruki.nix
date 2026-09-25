{ flake, ... }:

{
  imports = [ flake.homeModules.linux ];

  # Hyprland monitors for this host
  wayland.windowManager.hyprland.settings.monitor = [
    {
      output = "HDMI-A-1";
      mode = "1920x1080@60.0";
      position = "auto-right";
      scale = 1.0;
    }
    {
      output = "DP-2";
      mode = "1920x1080@60.00";
      position = "auto-left";
      scale = 1.0;
    }
  ];
}
