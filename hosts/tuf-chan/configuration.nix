{
  flake,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    flake.nixosModules.common
  ];

  # Systemd-boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Host name
  networking.hostName = "tuf-chan";

  hardware = {
    # Firmwares
    enableAllFirmware = true;

    # AMD GPU
    amdgpu = {
      opencl.enable = true;
      initrd.enable = true;
    };

    # AMD CPU
    cpu.amd.updateMicrocode = true;

    # OpenGL
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  programs = {
    # OBS studio
    obs-studio = {
      enable = true;
      enableVirtualCamera = true;
      plugins = [ pkgs.obs-studio-plugins.wlrobs ];
    };
  };

  # WayVR: OpenXR / OpenVR desktop overlay
  systemd.user.services.wayvr = {
    description = "WayVR desktop overlay for OpenXR/OpenVR";
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.wayvr}/bin/wayvr --replace";
      Restart = "on-failure";
    };
  };

  services = {
    # VR from Meta Quest series
    wivrn = {
      enable = true;
      openFirewall = true;
      steam.importOXRRuntimes = true;
      steam.enable = true;
      autoStart = true;
    };

    # Ollama
    ollama.enable = true;
    ollama.package = pkgs.ollama-vulkan;

    # nextjs-ollama-llm-ui
    nextjs-ollama-llm-ui.enable = true;
  };

  environment.systemPackages = [
    pkgs.lutris # Open Source gaming platform for GNU/Linux
    pkgs.android-tools # adb (For Meta Quest connection via USB type-c cable)
    pkgs.wayvr # A tool to access my Wayland/X11 desktop from OpenVR/OpenXR
  ];
}
