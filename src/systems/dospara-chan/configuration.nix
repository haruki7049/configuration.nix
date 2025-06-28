{
  pkgs,
  ...
}:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "dospara-chan";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Tokyo";

  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  qt = {
    enable = true;
    platformTheme = "gtk2";
    style = "adwaita-dark";
  };

  xdg.mime.enable = true;

  hardware = {
    bluetooth.enable = true;
    steam-hardware.enable = true;
    xone.enable = true;
    xpadneo.enable = true;
    xpad-noone.enable = true;
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  systemd = {
    user.services = {
      monado.environment = {
        STEAMVR_LH_ENABLE = "1";
        XRT_COMPOSITOR_COMPUTE = "1";
      };
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
    dconf.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
    gnupg = {
      agent = {
        enable = true;
        enableSSHSupport = true;
      };
    };
    sway = {
      enable = true;
      extraPackages = with pkgs; [
        swaylock
        swayidle
        alacritty
        rofi
      ];
      wrapperFeatures.base = true;
      wrapperFeatures.gtk = true;
    };
    waybar.enable = false;
  };

  services = {
    pulseaudio.enable = false;
    monado = {
      enable = true;
      defaultRuntime = true;
    };
    joycond.enable = true;
    pcscd.enable = true;
    blueman.enable = true;
    openssh.enable = true;
    picom = {
      enable = true;
      vSync = true;
    };
    printing = {
      enable = true;
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    libinput = {
      enable = true;
      mouse = {
        accelProfile = "flat";
      };
    };
    displayManager = {
      ly = {
        enable = true;
        settings = { };
      };
    };
    xserver = {
      enable = true;
      xkb.layout = "us";
      desktopManager.runXdgAutostartIfNone = true;
      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
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
        "wireshark"
        "audio"
      ];
    };
  };

  environment.systemPackages = [
    pkgs.alsa-utils
    pkgs.xdg-utils
  ];

  fonts = {
    packages = with pkgs; [
      ipafont
      ipaexfont
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
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

  nixpkgs = {
    config = {
      permittedInsecurePackages = [
        "electron-21.4.4"
        "electron-27.3.11"
      ];
      allowUnfree = true;
    };
  };

  virtualisation = {
    docker.enable = true;
    podman.enable = true;
  };

  system.stateVersion = "25.11";
}
