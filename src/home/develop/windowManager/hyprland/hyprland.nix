{ config, lib, pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      env = [
        "XCURSOR_SIZE, 24"
        "HYPRCURSOR_SIZE, 24"
      ];

      monitor = [
        "eDP-1, preferred, 0x0, 1"
        "HDMI-A-1, preferred, 0x0, 1"
        "DP-1, preferred, 1920x0, 1"
      ];
      dwindle = {
        preserve_split = true;
      };
      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        resize_on_border = false;
        allow_tearing = false;
      };
      decoration = {
        rounding = 10;
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };
      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };
      misc = {
        force_default_wallpaper = -1;
        disable_hyprland_logo = false;
      };
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        sensitivity = 0;
        touchpad.natural_scroll = false;
      };
      gestures.workspace_swipe = false;

      exec-once = [
        (builtins.toString ../tools/eww/start-eww.sh)
      ];

      "$mod" = "SUPER";
      "$terminal" = lib.getExe pkgs.alacritty;
      "$menu" = lib.getExe pkgs.fuzzel;

      bind = [
        "$mod, return, exec, $terminal"
        "$mod_SHIFT, Q, killactive,"
        "$mod_SHIFT, E, exit,"
        "$mod, SPACE, togglefloating,"
        "$mod, P, exec, $menu"

        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        "$mod_SHIFT, 1, movetoworkspace, 1"
        "$mod_SHIFT, 2, movetoworkspace, 2"
        "$mod_SHIFT, 3, movetoworkspace, 3"
        "$mod_SHIFT, 4, movetoworkspace, 4"
        "$mod_SHIFT, 5, movetoworkspace, 5"
        "$mod_SHIFT, 6, movetoworkspace, 6"
        "$mod_SHIFT, 7, movetoworkspace, 7"
        "$mod_SHIFT, 8, movetoworkspace, 8"
        "$mod_SHIFT, 9, movetoworkspace, 9"
        "$mod_SHIFT, 0, movetoworkspace, 10"

        "$mod, S, togglespecialworkspace, magic"
        "$mod_SHIFT, S, movetoworkspace, special:magic"

        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"

        "$mod, mouse:272, movewindow"
      ];
      windowrulev2 = "suppressevent maximize, class:.*";
    };
  };
}
