{
  ...
}:

{
  programs.ashell = {
    enable = true;
    systemd.enable = true;

    settings = {
      modules = {
        left = [
          "Workspaces"
          "MediaPlayer"
        ];
        center = [ "WindowTitle" ];
        right = [
          "Tray"
          [
            "Clock"
            "Privacy"
            "Settings"
          ]
        ];
      };
    };
  };
}
