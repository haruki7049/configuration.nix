{ config, lib, pkgs, ... }:
{
  home-manager = {
    users.haruki = {
      home = {
        username = "haruki";
        homeDirectory = "/home/haruki";
      };

      programs = {
        # Enable home-manager
        home-manager.enable = true;
        bash = {
          enable = true;
        };
        fish = {
          enable = true;
        };
        zsh = {
          enable = true;
        };
        git = {
          enable = true;
          userName = "haruki7049";
          userEmail = "tontonkirikiri@gmail.com";
          extraConfig = {
            init.defaultBranch = "main";
          };
        };
        alacritty = {
          enable = true;
          settings = {
            font.size = 12.0;
            font.normal.family = "UDEV Gothic NF";
          };
        };
        neovim = {
          enable = true;
          defaultEditor = true;
          extraPackages = with pkgs; [
            deno
            rust-analyzer
          ];
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
