{ config, lib, pkgs, ... }:
{
  home-manager = {
    users.root = {
      home = {
        username = "root";
        homeDirectory = "/root";
      };

      # Enable home-manager
      programs = {
        home-manager.enable = true;
        neovim = {
          enable = true;
          defaultEditor = true;
        };
        emacs = {
          enable = true;
        };
      };

      # Nicely reload system units when changing configs
      systemd.user.startServices = "sd-switch";

      # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
      home.stateVersion = "23.11";
    };
  };
}
