{
  pkgs,
  ...
}:

{
  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.bash.enable = true;
  programs.zsh.enable = true; # default shell on catalina
  programs.fish.enable = true;

  fonts.packages = [
    pkgs.udev-gothic-nf
    pkgs.udev-gothic
  ];

  environment.systemPackages = [
    pkgs.audacity
    pkgs.prismlauncher
    pkgs.kitty

    #pkgs.google-chrome
  ];

  system = {
    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 5;
  };
}
