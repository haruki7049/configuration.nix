{
  ...
}:

{
  programs.ashell = {
    enable = true;
    systemd.enable = true;

    settings = {
      modules = {
        left = ["Workspaces"];
        center = ["WindowTitle"];
        right = ["Tray" ["Clock" "Privacy" "Settings"]];
      };
    };
  };
}
