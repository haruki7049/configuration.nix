{ pkgs, ... }:
let
  sshConfig = ''
    Host *
      IdentityAgent ~/.1password/agent.sock

    Host github.com
      User git

    Host gitlab.com
      User git
            
    Host keyserver
      HostName keyserver.haruki7049.dev
      User haruki
      ProxyCommand ${pkgs.cloudflared}/bin/cloudflared access ssh --hostname keyserver.haruki7049.dev
  '';
in
{
  imports = [ ../develop/develop.nix ];

  home = {
    username = "haruki";
    homeDirectory = "/home/haruki";
  };

  xdg = {
    enable = true;
    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/about" = "google-chrome.desktop";
        "x-scheme-handler/unknown" = "google-chrome.desktop";
        "text/html" = "firefox.desktop";
        "application/x-extension-htm" = "firefox.desktop";
        "application/x-extension-html" = "firefox.desktop";
        "application/x-extension-shtml" = "firefox.desktop";
        "application/xhtml+xml" = "firefox.desktop";
        "application/x-extension-xhtml" = "firefox.desktop";
        "application/x-extension-xht" = "firefox.desktop";
      };

      associations = {
        added = {
          "x-scheme-handler/http" = "firefox.desktop";
          "x-scheme-handler/https" = "firefox.desktop";
          "x-scheme-handler/about" = "google-chrome.desktop";
          "x-scheme-handler/unknown" = "google-chrome.desktop";
          "text/html" = "firefox.desktop";
          "application/x-extension-htm" = "firefox.desktop";
          "application/x-extension-html" = "firefox.desktop";
          "application/x-extension-shtml" = "firefox.desktop";
          "application/xhtml+xml" = "firefox.desktop";
          "application/x-extension-xhtml" = "firefox.desktop";
          "application/x-extension-xht" = "firefox.desktop";
        };

        removed = { };
      };
    };
  };

  programs = {
    # Enable home-manager
    home-manager.enable = true;
    git = {
      enable = true;
      userName = "haruki7049";
      userEmail = "tontonkirikiri@gmail.com";
      extraConfig = {
        user.signingkey =
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG7Rjpnf4kB6UIILl8fohRn0Gz1aBYM59OHlEjdPd/gS";
        init.defaultBranch = "main";
        gpg.format = "ssh";
        gpg."ssh".program = "${pkgs._1password-gui}/bin/op-ssh-sign";
        commit.gpgsign = true;
        pull.rebase = true;
      };
    };
    ssh = {
      enable = true;
      extraConfig = sshConfig;
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
