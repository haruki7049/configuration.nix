{
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../common/configuration.nix
  ];

  # Host name
  networking.hostName = "pana-chama";

  # Time zone
  time.timeZone = "Asia/Tokyo";

  # Locale
  i18n.defaultLocale = "en_US.UTF-8";

  services = {
    # systemd-logind
    logind.settings.Login = {
      HandleLidSwitch = "ignore";
    };
  };

  environment.systemPackages = [
    pkgs.acpi # CLI Battery checker
    pkgs.alsa-utils # ALSA
  ];
}
