{
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../common/linux-configuration.nix
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

  # Hyprland monitors for this host
  home-manager.users.haruki.wayland.windowManager.hyprland.settings.monitor = [
    {
      output = "HDMI-A-1";
      mode = "1920x1080@60.0";
      position = "auto-right";
      scale = 1.0;
    }
    {
      output = "DP-2";
      mode = "1920x1080@60.00";
      position = "auto-left";
      scale = 1.0;
    }
  ];

  environment.systemPackages = [
    pkgs.lutris # Open Source gaming platform for GNU/Linux
    pkgs.android-tools # adb (For Meta Quest connection via USB type-c cable)
    pkgs.wayvr # A tool to access my Wayland/X11 desktop from OpenVR/OpenXR
  ];
}
