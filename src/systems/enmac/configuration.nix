{ config, pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.vim
    pkgs.neovim
    pkgs.git
    pkgs.emacs-nox
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

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.bash.enable = true;
  programs.zsh.enable = true; # default shell on catalina
  programs.fish.enable = true;

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      cleanup = "uninstall";
    };
    casks = [
      # SNS
      "slack"
      "element"
      "discord"

      # Music player
      "spotify"

      # Keyboard inputs
      "aquaskk"
      "programmer-dvorak"

      # Password manager
      "bitwarden"

      # Virtual machine manager
      "utm"

      # Editor
      #"emacs"
      "visual-studio-code"

      # IDE
      "r"

      # Multi media editor
      "blender"
      "gimp"

      # Terminal
      "kitty"
      "wezterm"

      # Browser
      "google-chrome"
      "firefox"
      "brave-browser"

      # Game
      "steam"
      "osu"
    ];
  };

  fonts.packages = [
    pkgs.udev-gothic-nf
    pkgs.udev-gothic
  ];

  system = {
    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 5;

    defaults = {
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
