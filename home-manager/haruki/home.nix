# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ inputs
, lib
, config
, pkgs
, ...
}:
let
  fromGitHub = ref: repo: pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "${lib.strings.sanitizeDerivationName repo}";
    version = ref;
    src = builtins.fetchGit {
      url = "https://github.com/${repo}.git";
      ref = ref;
    };
  };
in
{
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  home = {
    username = "haruki";
    homeDirectory = "/home/haruki";
  };

  # Enable home-manager
  programs = {
    home-manager.enable = true;
    bash = {
      enable = true;
    };
    fish = {
      enable = true;
    };
    zsh = {
      enable = true;
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      plugins = with pkgs.vimPlugins; [
        (fromGitHub "HEAD" "numToStr/Comment.nvim")
      ];
      extraPackages = with pkgs; [
        deno
        rust-analyzer
      ];
    };
    emacs = {
      enable = true;
      defaultEditor = false;
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
