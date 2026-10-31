{ ... }:

{
  # Shell integration settings
  home.shell = {
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
  };

  programs = {
    # Enable home-manager
    home-manager.enable = true;

    # man
    man.man-db.enable = true;

    # Git
    git.enable = true;
    git.lfs.enable = true;

    # SSH
    ssh.enable = true;
    ssh.enableDefaultConfig = false;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "26.11";
}
