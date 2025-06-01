{
  config,
  pkgs,
  lib,
  ...
}:
{
  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
    initrd.availableKernelModules = [
      "xhci_pci"
      "usbhid"
      "usb_storage"
    ];
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  networking = {
    hostName = "raspi-chan";
    networkmanager.enable = true;
  };

  sound.enable = true;

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
    pulseaudio.enable = true;
    bluetooth.enable = true;
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  programs = {
    dconf.enable = true;
    _1password.enable = true;
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ "haruki" ];
    };
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
  };

  services = {
    openssh.enable = true;
    xserver = {
      enable = true;
      libinput = {
        enable = true;
        mouse.accelProfile = "flat";
      };
      displayManager.startx.enable = true;
      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          dunst
          rofi
          i3status
          i3blocks
          i3lock
          pavucontrol
          obs-studio
          scrot
          feh
          gimp
        ];
      };
    };
  };

  nixpkgs.config.allowUnfree = true;

  users = {
    mutableUsers = false;
    users.haruki = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG7Rjpnf4kB6UIILl8fohRn0Gz1aBYM59OHlEjdPd/gS"
      ];
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

  virtualisation.podman.enable = true;

  security.sudo.wheelNeedsPassword = false;

  hardware.enableRedistributableFirmware = true;
  system.stateVersion = "25.11";
}
