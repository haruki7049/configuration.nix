# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{ inputs
, config
, lib
, pkgs
, ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    kernelModules = [
      "v4l2loopback"
    ];
    extraModulePackages = with pkgs; [
      linuxPackages.v4l2loopback
    ];
    extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=1 cardlabel="OBS_Camera" exclusive_caps=1
    '';
    initrd.kernelModules = [
      "amdgpu"
    ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking.hostName = "tuf-chan";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Tokyo";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      fcitx5 = {
        addons = with pkgs; [
          fcitx5-mozc
          fcitx5-skk
          fcitx5-gtk
        ];
      };
      uim = {
        toolbar = "gtk3-systray";
      };
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
      extraPackages = with pkgs; [
        amdvlk
      ];
      extraPackages32 = with pkgs; [
        driversi686Linux.amdvlk
      ];
      driSupport = true;
      driSupport32Bit = true;
    };
    pulseaudio.enable = false;
    bluetooth = {
      enable = true;
    };
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  programs = {
    dconf = {
      enable = true;
    };
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
    _1password = {
      enable = true;
    };
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ "haruki" ];
    };
  };

  services = {
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
    xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];
      xkb.layout = "us";
      libinput = {
        enable = true;
        mouse = {
          accelProfile = "flat";
        };
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
          emacs
          brave
          google-chrome
          pwvucontrol
          pavucontrol
          (wrapOBS {
            plugins = with pkgs.obs-studio-plugins; [
              wlrobs
              obs-backgroundremoval
              obs-pipewire-audio-capture
            ];
          })
          neovide
          discord
          element-desktop
          whalebird
          scrot
          feh
          gimp
          osu-lazer
          anki
          thunderbird
        ];
      };
    };
  };

  users.users = {
    haruki = {
      # TODO: You can set an initial password for your user.
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      initialPassword = "correcthorsebatterystaple";
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
    systemPackages = with pkgs; [
      your-editor
      neovim
      htop
      wget
      curl
      unzip
      gzip
      git
      alsa-utils
      nixpkgs-fmt
      powershell
      nushell
      guile
      google-cloud-sdk
    ];
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

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-public-keys = [
        "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
      ];
      substituters = [
        "https://cache.iog.io"
      ];
      extra-trusted-substituters = [ "https://cache.flox.dev" ];
      extra-trusted-public-keys = [ "flox-cache-public-1:7F4OyH7ZCnFhcze3fJdfyXYLQw/aV7GEed86nQ7IsOs=" ];
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "electron-21.4.4"
      ];
    };
  };

  system.stateVersion = "23.05";
}
