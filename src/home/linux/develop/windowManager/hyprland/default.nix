{ ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enableXdgAutostart = true;

    settings = {
      dwindle = {
        preserve_split = true;
      };
      general = {
        gaps_in = 5;
        gaps_out = 5;
        border_size = 1;
        resize_on_border = false;
        allow_tearing = false;
      };
      decoration = {
        rounding = 10;
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };
      animations.enabled = false;
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

      "$mod" = "SUPER";
      "$terminal" = "alacritty";
      "$menu" = "fuzzel";

      bind = [
        "$mod, return, exec, $terminal"
        "$mod_SHIFT, Q, killactive,"
        "$mod_SHIFT, E, exit,"
        "$mod, SPACE, togglefloating,"
        "$mod, P, exec, $menu"

        # Move focus
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        # Move active
        "$mod_SHIFT, left, swapwindow, l"
        "$mod_SHIFT, right, swapwindow, r"
        "$mod_SHIFT, up, swapwindow, u"
        "$mod_SHIFT, down, swapwindow, d"

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

        "$mod_SHIFT, 1, movetoworkspacesilent, 1"
        "$mod_SHIFT, 2, movetoworkspacesilent, 2"
        "$mod_SHIFT, 3, movetoworkspacesilent, 3"
        "$mod_SHIFT, 4, movetoworkspacesilent, 4"
        "$mod_SHIFT, 5, movetoworkspacesilent, 5"
        "$mod_SHIFT, 6, movetoworkspacesilent, 6"
        "$mod_SHIFT, 7, movetoworkspacesilent, 7"
        "$mod_SHIFT, 8, movetoworkspacesilent, 8"
        "$mod_SHIFT, 9, movetoworkspacesilent, 9"
        "$mod_SHIFT, 0, movetoworkspacesilent, 10"
      ];
      windowrulev2 = "suppressevent maximize, class:.*";
    };
  };
}
