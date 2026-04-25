{
  pkgs,
  ...
}:

{
  # Time zone
  time.timeZone = "Asia/Tokyo";

  # Fonts
  fonts.packages = [
    pkgs.ipafont
    pkgs.ipaexfont
    pkgs.noto-fonts
    pkgs.noto-fonts-cjk-sans
    pkgs.noto-fonts-color-emoji
    pkgs.udev-gothic-nf
    pkgs.liberation_ttf
    pkgs.fira-code
    pkgs.fira-code-symbols
    pkgs.mplus-outline-fonts.githubRelease
    pkgs.dina-font
    pkgs.proggyfonts
    pkgs.dejavu_fonts
  ];

  # Shells
  programs.bash.enable = true;
  programs.zsh.enable = true;
  programs.fish.enable = true;

  # Nix settings
  nix.package = pkgs.nix;
  nix.settings = {
    trusted-users = [
      "root"
      "@wheel"
    ];
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  # AllowUnfree for nixpkgs
  nixpkgs.config.allowUnfree = true;

  # ----- Darwin options -----

  system = {
    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 5;
  };
}
