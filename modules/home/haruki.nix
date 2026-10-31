{
  lib,
  pkgs,
  ...
}:

let
  username = "haruki";
  homeDirectory = mkHomeDirectory username;
  mkHomeDirectory =
    usrName:
    if pkgs.stdenv.hostPlatform.isDarwin then
      lib.strings.concatStringsSep "/" [
        "/Users"
        usrName
      ]
    else
      lib.strings.concatStringsSep "/" [
        "/home"
        usrName
      ];
in

{
  home = {
    inherit username homeDirectory;
  };

  programs = {
    # Git
    git.settings = {
      # User's settings
      user.name = "haruki7049";
      user.email = "haruki7049+git@mail.haruki7049.dev";

      # default branch on initializing is "main"
      init.defaultBranch = "main";

      pull.rebase = true; # I want to use pull with rebasing
      commit.gpgsign = true; # Signing (GPG/SSH)
      user.signingKey = "~/.ssh/haruki7049"; # Signing key (This is a SSH key)
      gpg.format = "ssh"; # I use SSH key
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers"; # This file contains public keys

      credential."https://github.com" = {
        helper = "${pkgs.gh}/bin/gh auth git-credential";
      };

      credential."https://gist.github.com" = {
        helper = "${pkgs.gh}/bin/gh auth git-credential";
      };

      # Some ghq settings
      ghq.root = "~/program-dir";
    };

    # SSH
    ssh.settings = {
      "*" = {
        IdentityFile = [ "~/.ssh/haruki7049" ];
      };
      "github.com" = {
        User = "git";
      };
      "gitlab.com" = {
        User = "git";
      };
    };
  };
}
