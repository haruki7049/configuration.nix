{ config, lib, pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.enableContainers = false;

  networking = {
    hostName = "pana-chama";
    networkmanager.enable = true;
    #useDHCP = true;
    #wireless = {
    #  enable = true;
    #  environmentFile = "/run/secrets/wireless.env";
    #  networks = {
    #    "aterm-450699-g".psk = "@PSK_ATERM_450699_G@";
    #    "aterm-450699-a".psk = "@PSK_ATERM_450699_A@";
    #  };
    #};
  };

  time.timeZone = "Asia/Tokyo";

  i18n = {
    defaultLocale = "ja_JP.UTF-8";
    inputMethod = {
      uim = { toolbar = "gtk3-systray"; };
      type = "uim";
    };
  };

  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  hardware = {
    pulseaudio.enable = false;
    bluetooth.enable = true;
    steam-hardware.enable = true;
    joycond.enable = true;
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
        ExecStart =
          "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
    services.NetworkManager-wait-online.enable = false;
  };

  programs = {
    _1password = { enable = true; };
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ "haruki" ];
    };
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
    openssh.enable = true;
    asterisk.enable = true;
    blueman.enable = true;
    udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
    libinput.enable = true;
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
      displayManager.lightdm.enable = true;
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
      noto-fonts-cjk
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
    extraGroups = [ "wheel" "wireshark" ];
  };

  nixpkgs = {
    config = {
      permittedInsecurePackages = [ "electron-21.4.4" "electron-27.3.11" ];
      allowUnfree = true;
    };
  };


  nix.settings.experimental-features = [ "nix-command" "flakes" ];

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
    systemPackages = with pkgs; [
      mpc-cli
      acpi
    ] ++ [
      # for Hyprland
      wofi
      alacritty
    ];
  };

  virtualisation = {
    virtualbox.host = {
      enable = true;
      enableExtensionPack = true;
    };
    docker.enable = true;
    podman.enable = true;
  };

  system.stateVersion = "unstable";
}

