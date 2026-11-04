{
  lib,
  ...
}:

{
  programs.ashell = {
    enable = true;
    systemd.enable = true;

    settings = lib.trivial.importTOML ./config.toml;
  };
}
