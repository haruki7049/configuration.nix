{
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "the-hp";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Tokyo";

  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  qt = {
    enable = true;
    platformTheme = "gtk2";
    style = "adwaita-dark";
  };

  xdg.mime.enable = true;

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  hardware.bluetooth.enable = true;

  services = {
    xserver.enable = true;
    xserver.xkb.layout = "us";
    xserver.windowManager.i3.enable = true;
    libinput.enable = true;
    openssh.enable = true;
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  users.users.haruki = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
    ];
  };

  fonts = {
    packages = with pkgs; [
      ipafont
      ipaexfont
      noto-fonts
      noto-fonts-cjk-sans
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

  nixpkgs = {
    config = {
      permittedInsecurePackages = [
        "electron-21.4.4"
        "electron-27.3.11"
      ];
      allowUnfree = true;
    };
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.systemPackages = with pkgs; [
    git
    wget
    curl
  ];

  system.stateVersion = "25.05";
}
