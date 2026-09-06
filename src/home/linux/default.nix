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
      mimeApps =
        let
          BROWSER_DESKTOP = "vivaldi-stable.desktop";
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

    programs = {
      # Enable home-manager
      home-manager.enable = true;
      git = {
        enable = true;
        lfs.enable = true;
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

          # Some ghq settings
          ghq.root = "~/program-dir";
        };
      };
      ssh = {
        enable = true;
        enableDefaultConfig = false;
        settings = {
          "*" = {
            IdentityFile = [ "~/.ssh/haruki7049" ];
          };
          "github.com" = {
            User = "git";
          };
          "gitlab.com" = {
            User = "git";
          };
        };
      };
    };

    # Nicely reload system units when changing configs
    systemd.user.startServices = "sd-switch";

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    home.stateVersion = "26.05";
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
    home.stateVersion = "26.05";
  };
}
