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
  fonts.packages = with pkgs; [
    ipafont
    ipaexfont
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    udev-gothic-nf
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
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
