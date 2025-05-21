{
  pkgs,
  ...
}:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.enableContainers = false;

  networking = {
    hostName = "pana-chama";
    networkmanager.enable = true;
  };

  time.timeZone = "Asia/Tokyo";

  i18n.defaultLocale = "en_US.UTF-8";

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

  services = {
    pulseaudio.enable = false;
    joycond.enable = true;
    openssh.enable = true;
    blueman.enable = true;
    udev.packages = [ pkgs.gnome-settings-daemon ];
    libinput.enable = true;
    displayManager.ly.enable = true;
    xserver = {
      enable = true;
      xkb.layout = "us";
      windowManager.i3 = {
        enable = true;
        extraPackages = [
          pkgs.i3lock
          pkgs.i3status
          pkgs.i3blocks
          pkgs.rofi
          pkgs.dunst
          pkgs.pavucontrol
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
    ];
  };

  nixpkgs.config.allowUnfree = true;

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

  environment.systemPackages = [
    pkgs.acpi
  ];

  virtualisation = {
    docker.enable = true;
    podman.enable = true;
  };

  system.stateVersion = "25.05";
}
