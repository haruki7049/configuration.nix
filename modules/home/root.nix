{ lib, ... }:

{
  home = {
    username = "root";
    homeDirectory = lib.mkForce "/root";
  };

  # Git
  programs.git.settings = {
    # default branch on initializing is "main"
    init.defaultBranch = "main";

    # I want to use pull with rebasing
    pull.rebase = true;

    # Some ghq settings
    ghq.root = "~/program-dir";
  };
}
