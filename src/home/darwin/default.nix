{
  pkgs,
  overlays ? [ ],
  lib ? pkgs.lib,
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
      homeDirectory = lib.mkForce "/Users/haruki";
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

          # Some ghq settings
          ghq.root = "~/program-dir";
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

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    home.stateVersion = "25.11";
  };
}
