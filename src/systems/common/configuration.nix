{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Systemd-boot
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Locale / TimeZone
  time.timeZone = "Asia/Tokyo";
  i18n.defaultLocale = "en_US.UTF-8";

  # Networking
  networking.networkmanager.enable = true;

  # Security
  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  # Console (TTY)
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  # XDG mime
  xdg.mime.enable = true;

  # Graphics 32bit library
  hardware.graphics.enable32Bit = true;

  programs = {
    # Hyprland (Wayland)
    hyprland.enable = true;
    hyprlock.enable = true;
  };

  systemd = {
    user.services = {
      polkit-gnome-authentication-agent-1 = {
        description = "polkit-gnome-authentication-agent-1";
        wantedBy = [ "graphical-session.target" ];
        wants = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };
  };

  services = {
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

    # Display Manager
    displayManager.ly.enable = true;
  };

  users.users.haruki = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  environment.systemPackages = [
    pkgs.alsa-utils # ALSA
    pkgs.xdg-utils # xdg-open and etc
    pkgs.android-tools # adb (For Meta Quest connection via USB type-c cable)
    pkgs.wlx-overlay-s # WiVRN's overlay
  ];

  fonts = {
    packages = with pkgs; [
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
  };

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

  # AllowUnfree
  nixpkgs.config.allowUnfree = true;

  virtualisation = {
    docker.enable = true;
    podman.enable = true;
  };

  system.stateVersion = "25.11";
}
