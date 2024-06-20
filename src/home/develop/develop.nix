{ config, lib, pkgs, ... }:
{
  imports = [
    ./windowManager/i3wm/i3.nix
    ./windowManager/hyprland/hyprland.nix
    ./editor/neovim/neovim.nix
    ./editor/vim/vim.nix
    ./editor/emacs/emacs.nix
    ./editor/vscode/vscode.nix
    ./mpd/mpd.nix
    ./xdg/xdg.nix
    ./shell/shell.nix
  ];
  home.packages = with pkgs; [
    mg
    your-editor
    helix
    bash
    htop
    wget
    curl
    unzip
    gzip
    git
    zellij
    nixpkgs-fmt
    brave
    google-chrome
    neovide
    discord
    element-desktop
    slack
    whalebird
    osu-lazer
    anki
    thunderbird
    spotify
    gns3-gui
    gns3-server
    #ciscoPacketTracer8
  ];
  home.pointerCursor =
    let
      getFrom = url: sha256: name: size: {
        gtk.enable = true;
        x11.enable = true;
        name = name;
        size = size;
        package = pkgs.runCommand "moveUp" { } ''
          mkdir -p $out/share/icons
          ln -s ${
            builtins.fetchTarball {
              url = url;
              sha256 = sha256;
            }
          } $out/share/icons/${name}
        '';
      };
    in
    getFrom
      "https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.6/Bibata-Modern-Classic.tar.xz"
      "sha256-jpEuovyLr9HBDsShJo1efRxd21Fxi7HIjXtPJmLQaCU=" "bibata" 24;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };
    alacritty = {
      enable = true;
      settings = {
        font.size = 8.0;
        font.normal.family = "UDEV Gothic NF";
      };
    };
  };
}
