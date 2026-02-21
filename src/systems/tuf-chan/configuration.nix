{
  pkgs,
  ...
}:
{
  imports = [ ./hardware-configuration.nix ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "tuf-chan";
    networkmanager.enable = true;
  };

  time.timeZone = "Asia/Tokyo";

  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  xdg.mime.enable = true;

  hardware = {
    amdgpu = {
      opencl.enable = true;
      initrd.enable = true;
    };
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    bluetooth.enable = true;
    steam-hardware.enable = true;
    xone.enable = true;
    xpadneo.enable = true;
    xpad-noone.enable = true;
  };

  qt = {
    enable = true;
    style = "adwaita-dark";
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
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
    # VR from Meta Quest series
    wivrn = {
      enable = true;
      defaultRuntime = true;
      openFirewall = true;
      steam.importOXRRuntimes = true;
      autoStart = true;
    };

    # Ollama
    ollama = {
      enable = true;
      loadModels = [
        "gemma3:12b-it-q4_K_M"
      ];
      rocmOverrideGfx = "10.3.0";
    };

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
    desktopManager.gnome.enable = true;
    gnome = {
      core-apps.enable = false;
      core-developer-tools.enable = false;
      games.enable = false;
    };
    xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];
      xkb.layout = "us";
      desktopManager.runXdgAutostartIfNone = true;
      windowManager.twm.enable = true;
      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          lutris
          arandr
          dunst
          rofi
          alacritty
          i3status
          i3blocks
          i3lock
          pwvucontrol
          pavucontrol
          scrot
          feh
          gimp
        ];
      };
    };
  };

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

  environment.systemPackages = [
    pkgs.alsa-utils # ALSA
    pkgs.xdg-utils # xdg-open and etc
    pkgs.android-tools # adb (For Meta Quest connection via USB type-c cable)
    pkgs.wayvr # A tool to access my Wayland/X11 desktop from OpenVR/OpenXR
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
