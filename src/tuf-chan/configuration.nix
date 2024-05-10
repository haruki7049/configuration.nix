{ config, lib, pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];

  boot = {
    kernelModules = [ "v4l2loopback" ];
    extraModulePackages = with pkgs; [ linuxPackages.v4l2loopback ];
    extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=1 cardlabel="OBS_Camera" exclusive_caps=1
    '';
    initrd.kernelModules = [ "amdgpu" ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    hostName = "tuf-chan";
    useDHCP = true;
    nameservers = [ "192.168.0.1" ];
  };

  time.timeZone = "Asia/Tokyo";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      fcitx5 = { addons = with pkgs; [ fcitx5-mozc fcitx5-skk fcitx5-gtk ]; };
      uim = { toolbar = "gtk3-systray"; };
      enabled = "uim";
    };
  };

  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  qt = {
    enable = true;
    platformTheme = "gtk2";
    style = "adwaita-dark";
  };

  hardware = {
    opengl = {
      enable = true;
      extraPackages = with pkgs; [ amdvlk ];
      extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];
      driSupport = true;
      driSupport32Bit = true;
    };
    pulseaudio.enable = false;
    bluetooth = { enable = true; };
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
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
  };

  programs = {
    dconf = { enable = true; };
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
    _1password = { enable = true; };
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ "haruki" ];
    };
    gnupg = {
      agent = {
        enable = true;
        enableSSHSupport = true;
      };
    };
  };

  services = {
    pcscd.enable = true;
    blueman.enable = true;
    openssh.enable = true;
    picom = {
      enable = true;
      vSync = true;
    };
    printing = { enable = true; };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];
      xkb.layout = "us";
      libinput = {
        enable = true;
        mouse = { accelProfile = "flat"; };
      };
      displayManager.lightdm.enable = true;
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
          immersed-vr
          (wrapOBS {
            plugins = with pkgs.obs-studio-plugins; [
              wlrobs
              obs-backgroundremoval
              obs-pipewire-audio-capture
            ];
          })
        ];
      };
    };
  };

  users.users = {
    haruki = {
      hashedPassword =
        "$y$j9T$gBae4PJgExCJFPlTGHHjk0$N9iA8TQMV/Y51x86oirBJjsDHn4bI5Wn1nYVo1ZViX8";
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  };

  environment = {
    etc = {
      "1password/custom_allowed_browsers" = {
        text = ''
          microsoft-edge
          google-chrome-stable
        '';
        mode = "0755";
      };
    };
    systemPackages = with pkgs; [ alsa-utils ];
  };

  fonts = {
    packages = with pkgs; [
      ipafont
      ipaexfont
      noto-fonts
      noto-fonts-cjk
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

  nix = { settings = { experimental-features = [ "nix-command" "flakes" ]; }; };

  nixpkgs = {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [ "electron-21.4.4" ];
    };
  };

  virtualisation = {
    virtualbox.host = {
      enable = true;
      enableExtensionPack = true;
    };
  };

  system.stateVersion = "23.11";
}
