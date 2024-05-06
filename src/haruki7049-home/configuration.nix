{ config, lib, pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "haruki7049-home";
    firewall.enable = false;
    nameservers = [ "192.168.0.1" ];
    defaultGateway = {
      address = "192.168.0.1";
      interface = "enp4s0";
    };
    interfaces = {
      enp4s0 = {
        ipv6.addresses = [{
          address = "240f:3c:196e:1:8ad9:8731:1b45:61fd";
          prefixLength = 64;
        }];
        ipv4.addresses = [{
          address = "192.168.0.200";
          prefixLength = 24;
        }];
      };
    };
  };

  time.timeZone = "Asia/Tokyo";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  security.polkit.enable = true;

  nixpkgs.config.allowUnfree = true;

  users = {
    mutableUsers = false;
    users = {
      haruki = {
        hashedPassword =
          "$y$j9T$A2FjmBevK/oLEqTCfU27M0$Q.Y0e3/gr3fCC/FAPv5tIGHP89TrB9IjBtnLTiYETh3";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG7Rjpnf4kB6UIILl8fohRn0Gz1aBYM59OHlEjdPd/gS"
        ];
        isNormalUser = true;
        extraGroups = [ "wheel" ];
      };
      root = {
        hashedPassword =
          "$y$j9T$CToL.EUZAxPYjn.Fu7IfC1$LBNmqPVyqyLwujDyecwlVkIxCJr4NOmRV.DAGJrt5d8";
        isSystemUser = true;
        extraGroups = [ "root" ];
      };
    };
  };

  environment.systemPackages = with pkgs; [ cyanrip ];

  services = {
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
    };
    nfs.server = {
      enable = true;
      exports = ''
        /nfs 192.168.0.200/24(ro,insecure,no_subtree_check)
      '';
    };
  };

  system.stateVersion = "23.11";
}
