{
  lib,
  ...
}:

{
  # Hyprlock
  programs.hyprlock.enable = true;
  programs.hyprlock.settings = {
    general = {
      hide_cursor = true;
      ignore_empty_input = true;
    };

    animations = {
      enabled = true;
      fade_in = {
        duration = 300;
        bezier = "easeOutQuint";
      };
      fade_out = {
        duration = 300;
        bezier = "easeOutQuint";
      };
    };

    background = [
      {
        path = "screenshot";
        blur_passes = 3;
        blur_size = 8;
      }
    ];

    input-field = [
      {
        size = "200, 50";
        position = "0, -80";
        monitor = "";
        dots_center = true;
        fade_on_empty = false;
        font_color = "rgb(202, 211, 245)";
        inner_color = "rgb(91, 96, 120)";
        outer_color = "rgb(24, 25, 38)";
        outline_thickness = 5;
        placeholder_text = "\'Password...'\'";
        shadow_passes = 2;
      }
    ];
  };

  # Hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    systemd.enableXdgAutostart = true;

    settings = {
      config = {
        animations.enabled = false;

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

        dwindle = {
          preserve_split = true;
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
      };

      mod._var = "SUPER";
      terminal._var = "alacritty";
      menu._var = "fuzzel";

      bind = [
        {
          #"$mod_SHIFT, Q, killactive,"
          _args = [
            (lib.generators.mkLuaInline "mod .. \"+ SHIFT + Q\"")
            (lib.generators.mkLuaInline "hl.dsp.window.close()")
            { locked = true; }
          ];
        }

        {
          #"$mod_SHIFT, E, exit,"
          _args = [
            (lib.generators.mkLuaInline "mod .. \"+ SHIFT + E\"")
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(\"command -v hyprshutdown >/dev/null 2>&1 && || hyprctl dispatch 'hl.dsp.exit()'\")")
            { locked = true; }
          ];
        }

        {
          # "$mod, return, exec, $terminal"
          _args = [
            (lib.generators.mkLuaInline "mod .. \"+ return\"")
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(terminal)")
            { locked = true; }
          ];
        }

        {
          # "$mod, P, exec, $menu"
          _args = [
            (lib.generators.mkLuaInline "mod .. \"+ P\"")
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd(menu)")
            { locked = true; }
          ];
        }

        # "$mod, SPACE, togglefloating,"

        # # Move focus
        # "$mod, left, movefocus, l"
        # "$mod, right, movefocus, r"
        # "$mod, up, movefocus, u"
        # "$mod, down, movefocus, d"

        # # Move active
        # "$mod_SHIFT, left, swapwindow, l"
        # "$mod_SHIFT, right, swapwindow, r"
        # "$mod_SHIFT, up, swapwindow, u"
        # "$mod_SHIFT, down, swapwindow, d"

        # "$mod, 1, workspace, 1"
        # "$mod, 2, workspace, 2"
        # "$mod, 3, workspace, 3"
        # "$mod, 4, workspace, 4"
        # "$mod, 5, workspace, 5"
        # "$mod, 6, workspace, 6"
        # "$mod, 7, workspace, 7"
        # "$mod, 8, workspace, 8"
        # "$mod, 9, workspace, 9"
        # "$mod, 0, workspace, 10"

        # "$mod_SHIFT, 1, movetoworkspacesilent, 1"
        # "$mod_SHIFT, 2, movetoworkspacesilent, 2"
        # "$mod_SHIFT, 3, movetoworkspacesilent, 3"
        # "$mod_SHIFT, 4, movetoworkspacesilent, 4"
        # "$mod_SHIFT, 5, movetoworkspacesilent, 5"
        # "$mod_SHIFT, 6, movetoworkspacesilent, 6"
        # "$mod_SHIFT, 7, movetoworkspacesilent, 7"
        # "$mod_SHIFT, 8, movetoworkspacesilent, 8"
        # "$mod_SHIFT, 9, movetoworkspacesilent, 9"
        # "$mod_SHIFT, 0, movetoworkspacesilent, 10"

        {
          # "$mod, mouse:272, movewindow"
          _args = [
            (lib.generators.mkLuaInline "mod .. \" + mouse:272\"")
            (lib.generators.mkLuaInline "hl.dsp.window.drag()")
            { mouse = true; }
          ];
        }

        {
          # "$mod, mouse:273, resizewindow"
          _args = [
            (lib.generators.mkLuaInline "mod .. \" + mouse:273\"")
            (lib.generators.mkLuaInline "hl.dsp.window.resize()")
            { mouse = true; }
          ];
        }
      ];
      window_rule = {
        name = "suppress windows' event";
        match.class = "*";
        suppress_event = "maximize";
      };
    };
  };
}
