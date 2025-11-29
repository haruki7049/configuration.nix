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

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    home.stateVersion = "25.11";
  };
}
