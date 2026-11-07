{
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./develop
  ];

  programs = {
    # Enable home-manager
    home-manager.enable = true;

    # man
    man.man-db.enable = true;

    # SSH
    ssh.settings = {
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

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "26.11";
}
