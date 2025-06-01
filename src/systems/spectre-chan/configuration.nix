{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.enableContainers = false;

  networking.hostName = "spectre-chan";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Tokyo";

  i18n = {
    defaultLocale = "ja_JP.UTF-8";
    inputMethod = {
      fcitx5 = {
        addons = with pkgs; [
          fcitx5-mozc
          fcitx5-skk
          fcitx5-gtk
        ];
        waylandFrontend = true;
      };
      type = "fcitx5";
      enable = true;
    };
  };

  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  hardware = {
    bluetooth.enable = true;
    steam-hardware.enable = true;
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  qt = {
    enable = true;
    platformTheme = "gtk2";
    style = "adwaita-dark";
  };

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
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
    services.NetworkManager-wait-online.enable = false;
  };

  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
  };

  services = {
    pulseaudio.enable = false;
    joycond.enable = true;
    openssh.enable = true;
    asterisk.enable = true;
    blueman.enable = true;
    udev.packages = with pkgs; [ gnome-settings-daemon ];
    libinput.enable = true;
    displayManager = {
      ly = {
        enable = true;
        settings = { };
      };
    };
    xserver = {
      enable = true;
      xkb.layout = "us";
      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          i3lock
          i3status
          i3blocks
          rofi
          dunst
          pwvucontrol
          pavucontrol
        ];
      };
      desktopManager.runXdgAutostartIfNone = true;
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    logind = {
      extraConfig = ''
        HandleLidSwitch=ignore
      '';
    };
    clamav = {
      updater.enable = true;
      daemon.enable = true;
    };
  };

  fonts = {
    packages = with pkgs; [
      ipafont
      ipaexfont
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      mplus-outline-fonts.githubRelease
      dina-font
      proggyfonts
      udev-gothic-nf
      dejavu_fonts
    ];
  };

  users.users.haruki = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "wireshark"
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

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment = {
    etc = {
      "1password/custom_allowed_browsers" = {
        text = ''
          microsoft-edge-stable
          google-chrome-stable
        '';
        mode = "0755";
      };
    };
    systemPackages =
      with pkgs;
      [
        mpc-cli
        acpi
      ]
      ++ [
        # for Hyprland
        wofi
        alacritty
      ];
  };

  virtualisation = {
    docker.enable = true;
    podman.enable = true;
  };

  system.stateVersion = "25.11";
}
