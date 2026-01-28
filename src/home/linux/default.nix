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
          # User's settings
          user.name = "haruki7049";
          user.email = "tontonkirikiri@gmail.com";

          # default branch on initializing is "main"
          init.defaultBranch = "main";

          pull.rebase = true; # I want to use pull with rebasing
          commit.gpgsign = true; # Signing (GPG/SSH)
          user.signingKey = "~/.ssh/haruki7049"; # Signing key (This is a SSH key)
          gpg.format = "ssh"; # I use SSH key
          gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers"; # This file contains public keys

          credential."https://github.com" = {
            helper = "${pkgs.gh}/bin/gh auth git-credential";
          };

          credential."https://gist.github.com" = {
            helper = "${pkgs.gh}/bin/gh auth git-credential";
          };
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
