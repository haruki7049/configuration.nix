{
  ...
}:

{
  services.spotifyd = {
    enable = true;
    settings = {
      global.use-mpris = true;
    };
  };
}
