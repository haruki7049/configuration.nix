{
  ...
}:

{
  programs.git = {
    enable = true;
    lfs.enable = true;

    # Settings shared by every user. User specific settings (identity, signing and so on)
    # live in the user's own module, e.g. modules/home/haruki.nix.
    settings = {
      # default branch on initializing is "main"
      init.defaultBranch = "main";

      # I want to use pull with rebasing
      pull.rebase = true;

      # Some ghq settings
      ghq.root = "~/program-dir";
    };
  };
}
