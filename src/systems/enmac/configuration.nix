{ config, pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.vim
    pkgs.neovim
    pkgs.git
  ];

  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.bash.enable = true;
  programs.zsh.enable = true; # default shell on catalina
  programs.fish.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;
}
