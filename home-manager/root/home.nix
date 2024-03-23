# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ inputs
, lib
, config
, pkgs
, ...
}: {
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  home = {
    username = "root";
    homeDirectory = "/home/root";
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
      defaultEditor = false;
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
