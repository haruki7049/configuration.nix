{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../common/configuration.nix
  ];

  hardware = {
    amdgpu = {
      opencl.enable = true;
      initrd.enable = true;
    };
    bluetooth.enable = true;
    steam-hardware.enable = true;
    xone.enable = true;
    xpadneo.enable = true;
    xpad-noone.enable = true;
  };

  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  services = {
    # VR from Meta Quest series
    wivrn = {
      enable = true;
      defaultRuntime = true;
      openFirewall = true;
      steam.importOXRRuntimes = true;
      autoStart = true;
    };

    # Ollama
    ollama = {
      enable = true;
      loadModels = [
        "gemma3:12b-it-q4_K_M"
      ];
      rocmOverrideGfx = "10.3.0";
    };

    # Devices
    udev.enable = true;
    joycond.enable = true;

    # Bluetooth manager
    blueman.enable = true;
  };

  users.users.haruki.extraGroups = [
    "wheel"
    "audio"
    "input"
  ];

  virtualisation.virtualbox = {
    host.enable = true;
    host.enableExtensionPack = true;
  };
}
