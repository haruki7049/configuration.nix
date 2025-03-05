{ config, pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.slack
    pkgs.element-desktop
    pkgs.discord
    pkgs.spotify

    pkgs.utm

    # TODO: Blender is broken on aarch64-darwin
    #pkgs.blender
    pkgs.gimp

    pkgs.alacritty
    pkgs.kitty
    pkgs.wezterm

    pkgs.google-chrome
    # TODO: Firefox on aarch64-darwin require pipewire...
    #pkgs.firefox
    pkgs.brave
  ];

  services.nix-daemon.enable = true;

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

  system = {
    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 5;

    defaults = {
      NSGlobalDomain = {
        "com.apple.keyboard.fnState" = true;
      };
      dock = {
        orientation = "bottom";
        tilesize = 40;
      };
      WindowManager = {
        GloballyEnabled = true;
      };
    };
  };
}
