{
  pkgs,
  ...
}:

{
  # Network manager
  networking.networkmanager.enable = true;

  # Time zone
  time.timeZone = "Asia/Tokyo";

  # Locale
  i18n.defaultLocale = "en_US.UTF-8";

  # Console
  console.font = "Lat2-Terminus16";
  console.useXkbConfig = true;

  hardware = {
    # Bluetooth
    bluetooth.enable = true;

    # Controllers
    steam-hardware.enable = true;
    xone.enable = true;
    xpadneo.enable = true;
    xpad-noone.enable = true;
  };

  # Polkit & rtkit
  security.polkit.enable = true;
  security.rtkit.enable = true;

  programs = {
    # Steam
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };

    # Hyprland (Wayland)
    hyprland.enable = true;
    hyprlock.enable = true;
  };

  services = {
    # Devices
    udev.enable = true;
    joycond.enable = true;

    # Bluetooth manager
    blueman.enable = true;

    # OpenSSH
    openssh.enable = true;

    # Audio (PulseAudio & PipeWire)
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    # Libinput
    libinput = {
      enable = true;
      mouse.accelProfile = "flat";
    };

    # Desktop environments
    displayManager.ly.enable = true;
    xserver.enable = true;
    xserver.xkb.layout = "us";
    xserver.windowManager.i3.enable = true;
  };

  # Users settings
  users.users = {
    haruki = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "audio"
        "input"
      ];
    };
  };

  environment.pathsToLink = [
    # For xdg.portal.enable option in home-manager
    "/share/xdg-desktop-portal"
    "/share/applications"
  ];

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

  # Nix settings
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

  # Container runtime
  virtualisation.docker.enable = true;
  virtualisation.podman.enable = true;

  system.stateVersion = "25.11";
}
