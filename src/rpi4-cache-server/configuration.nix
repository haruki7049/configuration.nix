{ config, pkgs, lib, ... }: {
  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
    initrd.availableKernelModules = [ "xhci_pci" "usbhid" "usb_storage" ];
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
    hostName = "rpi4-cache-server";
    defaultGateway = "192.168.0.1";
    nameservers = [ "192.168.0.1" ];
    interfaces.end0.ipv4.addresses = [{
      address = "192.168.0.200";
      prefixLength = 24;
    }];
    wireless.enable = false;
  };

  environment.systemPackages = with pkgs; [ neovim git curl wget nixpkgs-fmt ];

  nixpkgs.config.allowUnfree = true;

  services.openssh.enable = true;

  systemd.services.cloudflared = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      Type = "notify";
      User = "cloudflare";
      ExecStart = "${pkgs.cloudflared} service install eyJhIjoiMzBiMzJiZGMyMWJlYWNkZWQ1NWNmOWIyZDNhNmEwZTciLCJ0IjoiZGQyYzBkYmEtNGExNy00Njg5LWJlNzQtMGFjYWZmOWE5NDllIiwicyI6Ik56UmlOalE1TlRRdFpXTXhaaTAwWkdOa0xXRXlNR010TWpJMVpUTTFOR0kzTWprMSJ9";
    };
  };

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

  virtualisation.podman.enable = true;

  security.sudo.wheelNeedsPassword = false;

  hardware.enableRedistributableFirmware = true;
  system.stateVersion = "23.11";
}
