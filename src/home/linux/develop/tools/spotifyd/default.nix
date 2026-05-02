{
  ...
}:

{
  services.spotifyd = {
    enable = true;
    settings = {
      global.use_mpris = true;
      global.initial_volume = 100;
      global.device_type = "computer";
    };
  };
}
