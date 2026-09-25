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
  wayland.windowManager.hyprland =
    let
      inherit (lib.generators) mkLuaInline;

      # Renders `hl.bind(mod .. "<keys>", <dispatcher>[, <opts>])`
      mkBind =
        keys: dispatcher:
        {
          opts ? null,
        }:
        {
          _args = [
            (mkLuaInline "mod .. ${builtins.toJSON " + ${keys}"}")
            (mkLuaInline dispatcher)
          ]
          ++ lib.optional (opts != null) opts;
        };

      bind = keys: dispatcher: mkBind keys dispatcher { };

      directions = [
        "left"
        "right"
        "up"
        "down"
      ];

      # Workspaces 1..10, workspace 10 is mapped to key 0
      workspaces = lib.genList (i: i + 1) 10;
      workspaceKey = i: toString (lib.mod i 10);
    in
    {
      enable = true;
      configType = "lua";
      systemd = {
        enable = true;
        enableXdgAutostart = true;
        extraCommands = [ "systemctl --user start hyprland-session.target" ];
      };

      settings = {
        terminal._var = "alacritty";
        menu._var = "fuzzel";
        mod._var = "SUPER";
        lock_cmd._var = "hyprlock";

        # Monitors are host specific, see hosts/<host>/users/haruki.nix

        config = {
          animations = {
            enabled = false;
          };

          decoration = {
            blur = {
              enabled = true;
              passes = 1;
              size = 3;
              vibrancy = 0.15;
            };

            active_opacity = 1.0;
            inactive_opacity = 1.0;
            rounding = 10;
          };

          dwindle = {
            preserve_split = true;
          };

          general = {
            allow_tearing = false;
            border_size = 1;
            gaps_in = 5;
            gaps_out = 5;
            resize_on_border = false;
          };

          input = {
            touchpad = {
              natural_scroll = false;
            };

            follow_mouse = 1;
            kb_layout = "us";
            sensitivity = 0;
          };

          misc = {
            disable_hyprland_logo = false;
            force_default_wallpaper = -1;
          };
        };

        bind = [
          (bind "return" "hl.dsp.exec_cmd(terminal)")
          (bind "SHIFT + Q" "hl.dsp.window.close()")
          (bind "SHIFT + E" ''hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")'')
          (bind "space" ''hl.dsp.window.float({ action = "toggle" })'')
          (bind "P" "hl.dsp.exec_cmd(menu)")
          (bind "L" "hl.dsp.exec_cmd(lock_cmd)")
        ]
        # Move focus
        ++ map (dir: bind dir ''hl.dsp.focus({ direction = "${dir}" })'') directions
        # Swap windows
        ++ map (dir: bind "SHIFT + ${dir}" ''hl.dsp.window.swap({ direction = "${dir}" })'') directions
        # Switch workspaces
        ++ lib.concatMap (i: [
          (bind (workspaceKey i) "hl.dsp.focus({ workspace = ${toString i} })")
          (bind "SHIFT + ${workspaceKey i}" "hl.dsp.window.move({ workspace = ${toString i} })")
        ]) workspaces
        # Mouse dragging
        ++ [
          (mkBind "mouse:272" "hl.dsp.window.drag()" { opts.mouse = true; })
          (mkBind "mouse:273" "hl.dsp.window.resize()" { opts.mouse = true; })
        ];
      };
    };
}
