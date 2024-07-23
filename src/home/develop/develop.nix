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
    nixpkgs-fmt
    brave
    google-chrome
    neovide
    discord
    element-desktop
    slack
    whalebird
    #(osu-lazer.overrideAttrs (oldAttrs: rec {
    #  version = "2024.625.3";
    #  src = fetchFromGitHub {
    #    owner = "ppy";
    #    repo = "osu";
    #    rev = version;
    #    hash = "sha256-yZBE1mW9ZekW1JwrsF1QoeNH+D3BOilyQkrg9XE+fnY=";
    #  };
    #}))
    anki
    thunderbird
    spotify
    #gns3-gui
    #gns3-server
    #ciscoPacketTracer8
    wireshark
    lutris
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

  nixpkgs = {
    config = {
      permittedInsecurePackages = [ "electron-21.4.4" "electron-27.3.11" ];
      allowUnfree = true;
    };
  };

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
    zellij = {
      enable = true;
      settings = {
        theme = "cyber-noir";
        themes = {
          cyber-noir = {
            bg = "#0b0e1a";
            fg = "#91f3e4";
            red = "#ff578d";
            green = "#00ff00";
            blue = "#3377ff";
            yellow = "#ffd700";
            magenta = "#ff00ff";
            orange = "#ff7f50";
            cyan = "#00e5e5";
            black = "#000000";
            white = "#91f3e4";
          };

          everforest-dark-medium = {
            fg = "#d3c6aa";
            bg = "#2f383e";
            black = "#4a555b";
            red = "#d6494d";
            green = "#a7c080";
            yellow = "#dbbc7f";
            blue = "#7fbbb3";
            magenta = "#d699b6";
            cyan = "#83c092";
            white = "#a7c080";
            orange = "#e69875";
          };
        };
      };
    };
  };
}
