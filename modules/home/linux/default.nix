{
  flake,
  ...
}:

{
  imports = [
    flake.homeModules.nyxt
    flake.homeModules.fluidsynth
    ./develop
  ];

  xdg = {
    enable = true;
    mime.enable = true;
    mimeApps =
      let
        BROWSER_DESKTOP = "com.google.Chrome.desktop";
      in
      {
        enable = true;
        defaultApplications = {
          "x-scheme-handler/http" = BROWSER_DESKTOP;
          "x-scheme-handler/https" = BROWSER_DESKTOP;
          "x-scheme-handler/about" = BROWSER_DESKTOP;
          "x-scheme-handler/unknown" = BROWSER_DESKTOP;
          "text/html" = BROWSER_DESKTOP;
          "application/x-extension-htm" = BROWSER_DESKTOP;
          "application/x-extension-html" = BROWSER_DESKTOP;
          "application/x-extension-shtml" = BROWSER_DESKTOP;
          "application/xhtml+xml" = BROWSER_DESKTOP;
          "application/x-extension-xhtml" = BROWSER_DESKTOP;
          "application/x-extension-xht" = BROWSER_DESKTOP;
        };

        associations = {
          added = {
            "x-scheme-handler/http" = BROWSER_DESKTOP;
            "x-scheme-handler/https" = BROWSER_DESKTOP;
            "x-scheme-handler/about" = BROWSER_DESKTOP;
            "x-scheme-handler/unknown" = BROWSER_DESKTOP;
            "text/html" = BROWSER_DESKTOP;
            "application/x-extension-htm" = BROWSER_DESKTOP;
            "application/x-extension-html" = BROWSER_DESKTOP;
            "application/x-extension-shtml" = BROWSER_DESKTOP;
            "application/xhtml+xml" = BROWSER_DESKTOP;
            "application/x-extension-xhtml" = BROWSER_DESKTOP;
            "application/x-extension-xht" = BROWSER_DESKTOP;
          };

          removed = { };
        };
      };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
