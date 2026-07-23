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
    # AMD
    amdgpu = {
      opencl.enable = true;
      initrd.enable = true;
    };

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
    ollama.loadModels = [ "deepseek-coder:6.7b" ];
    ollama.syncModels = true;

    # nextjs-ollama-llm-ui
    nextjs-ollama-llm-ui.enable = true;
  };

  environment.systemPackages = [
    pkgs.lutris # Open Source gaming platform for GNU/Linux
    pkgs.android-tools # adb (For Meta Quest connection via USB type-c cable)
    pkgs.wayvr # A tool to access my Wayland/X11 desktop from OpenVR/OpenXR
  ];
}
