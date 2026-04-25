{
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../common/configuration.nix
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
    ollama = {
      enable = true;
      loadModels = [
        "gemma3:12b-it-q4_K_M"
      ];
      rocmOverrideGfx = "10.3.0";
    };

    # open-webui (For ollama instance)
    open-webui.enable = true;
    open-webui.environment = {
      OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";
      WEBUI_AUTH = "False";
    };
  };

  environment.systemPackages = [
    pkgs.lutris # Open Source gaming platform for GNU/Linux
    pkgs.android-tools # adb (For Meta Quest connection via USB type-c cable)
    pkgs.wayvr # A tool to access my Wayland/X11 desktop from OpenVR/OpenXR
  ];
}
