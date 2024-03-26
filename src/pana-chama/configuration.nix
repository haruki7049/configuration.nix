# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:
let
  home-manager = fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz";
    sha256 = "0g51f2hz13dk953i501fmc6935difhz60741nypaqwz127hy5ldk";
  };
in
{
  imports =
    [
      (import "${home-manager}/nixos")
      ../home/haruki/home.nix
      ../home/root/home.nix
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "pana-chama";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Tokyo";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
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

  hardware = {
    pulseaudio.enable = false;
    bluetooth.enable = true;
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

  programs = {
    _1password = {
      enable = true;
    };
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ "haruki" ];
    };
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };

  services = {
    openssh.enable = true;
    asterisk.enable = true;
    blueman.enable = true;
    udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
    mpd = {
      enable = true;
      extraConfig = ''
        audio_output {
          type "pipewire"
          name "My pipewire output"
        }
      '';
    };
    xserver = {
      enable = true;
      xkb.layout = "us";
      libinput.enable = true;
      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          i3lock
          i3status
          i3blocks
          rofi
          dunst
          chromium
          alacritty
          pwvucontrol
          pavucontrol
          microsoft-edge
          google-chrome
          firefox
          opera
          vivaldi
          element-desktop
          discord
          anki-bin
          vscode
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
    extraGroups = [ "wheel" ];
  };

  home-manager = {
    users.haruki = { pkgs, ... }: {
      home.packages = [ ];
      programs = {
        bash.enable = true;
        neovim = {
          enable = true;
          defaultEditor = true;
        };
      };
      home.stateVersion = "23.11";
    };
  };

  nixpkgs = {
    config = {
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
      neovim
      emacs
      helix
      powershell
      gnupg
      git
      wget
      curl
      acpi
      zellij
      deno
      mpc-cli

      clang
      cargo
      rustc
      rustfmt
      rust-analyzer
      clippy
    ];
  };

  system.stateVersion = "23.11";
}

