{
  ...
}:

{
  programs.i3status-rust = {
    enable = true;
    bars.default = {
      #icons = "awesome4";
      #theme = "solarized-dark";
      settings = {
        icons = {
          icons = "awesome4";
          overrides = {
            bat = [
              "|E|"
              "|_|"
              "|=|"
              "|F|"
            ];
            bat_charging = "|^| ";
          };
        };
        theme = {
          theme = "solarized-dark";
          overrides = {
            idle_bg = "#123456";
            idle_fg = "#abcdef";
          };
        };
      };
      blocks = [
        {
          block = "cpu";
          info_cpu = 20;
          warning_cpu = 50;
          critical_cpu = 90;
        }
        {
          block = "memory";
          format = " $icon $mem_used_percents ";
          format_alt = " $icon $swap_used_percents ";
        }
        {
          block = "sound";
          click = [
            {
              button = "left";
              cmd = "pavucontrol";
            }
          ];
        }
        {
          block = "time";
          interval = 1;
          format = " $timestamp.datetime(f:'%c') ";
        }
      ];
    };
  };
}
