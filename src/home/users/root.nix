{ ... }:
{
  home = {
    username = "root";
    homeDirectory = "/root";
  };

  programs = {
    home-manager.enable = true;
    neovim.enable = true;
    git.enable = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
