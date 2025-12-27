{
  pkgs,
  overlays ? [ ],
  ...
}:

{
  haruki = {
    imports = [
      ./develop
    ];

    nixpkgs = {
      inherit overlays;
    };

    home = {
      shell = {
        enableBashIntegration = true;
        enableFishIntegration = true;
        enableZshIntegration = true;
        enableNushellIntegration = true;
      };
      username = "haruki";
      homeDirectory = "/home/haruki";
    };

    xdg = {
      enable = true;
      mime.enable = true;
      mimeApps = {
        enable = true;
        defaultApplications = {
          "x-scheme-handler/http" = "google-chrome.desktop";
          "x-scheme-handler/https" = "google-chrome.desktop";
          "x-scheme-handler/about" = "google-chrome.desktop";
          "x-scheme-handler/unknown" = "google-chrome.desktop";
          "text/html" = "google-chrome.desktop";
          "application/x-extension-htm" = "google-chrome.desktop";
          "application/x-extension-html" = "google-chrome.desktop";
          "application/x-extension-shtml" = "google-chrome.desktop";
          "application/xhtml+xml" = "google-chrome.desktop";
          "application/x-extension-xhtml" = "google-chrome.desktop";
          "application/x-extension-xht" = "google-chrome.desktop";
        };

        associations = {
          added = {
            "x-scheme-handler/http" = "google-chrome.desktop";
            "x-scheme-handler/https" = "google-chrome.desktop";
            "x-scheme-handler/about" = "google-chrome.desktop";
            "x-scheme-handler/unknown" = "google-chrome.desktop";
            "text/html" = "google-chrome.desktop";
            "application/x-extension-htm" = "google-chrome.desktop";
            "application/x-extension-html" = "google-chrome.desktop";
            "application/x-extension-shtml" = "google-chrome.desktop";
            "application/xhtml+xml" = "google-chrome.desktop";
            "application/x-extension-xhtml" = "google-chrome.desktop";
            "application/x-extension-xht" = "google-chrome.desktop";
          };

          removed = { };
        };
      };
    };

    programs = {
      # Enable home-manager
      home-manager.enable = true;
      git = {
        enable = true;
        settings = {
          user.name = "haruki7049";
          user.email = "tontonkirikiri@gmail.com";
          init.defaultBranch = "main";
          pull.rebase = true;
          commit.gpgsign = true;
          gpg.format = "ssh";
          user.signingkey = "~/.ssh/haruki7049";
        };
      };
      ssh = {
        enable = true;
        enableDefaultConfig = false;
        matchBlocks = {
          "*" = {
            identityFile = [ "~/.ssh/haruki7049" ];
          };
          "github.com" = {
            user = "git";
          };
          "gitlab.com" = {
            user = "git";
          };
        };
      };
    };

    # Nicely reload system units when changing configs
    systemd.user.startServices = "sd-switch";

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    home.stateVersion = "25.11";
  };

  root = {
    home = {
      username = "root";
      homeDirectory = "/root";
    };

    programs = {
      home-manager.enable = true;
      git.enable = true;
    };

    # Nicely reload system units when changing configs
    systemd.user.startServices = "sd-switch";

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    home.stateVersion = "25.11";
  };
}
