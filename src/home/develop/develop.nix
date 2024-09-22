{ pkgs, ... }:
{
  imports = [
    ./windowManager/i3wm/i3.nix
    ./windowManager/hyprland/hyprland.nix
    ./windowManager/tools/fuzzel/fuzzel.nix
    ./windowManager/tools/waybar/waybar.nix
    ./windowManager/tools/i3status-rust/i3status-rust.nix
    #./windowManager/tools/eww/eww.nix
    ./windowManager/tools/hyprpaper/hyprpaper.nix
    ./browser/firefox/firefox.nix
    ./editor/neovim/neovim.nix
    ./editor/vim/vim.nix
    ./editor/helix/helix.nix
    ./editor/emacs/emacs.nix
    ./editor/vscode/vscode.nix
    ./tools/fzf/fzf.nix
    ./mpd/mpd.nix
    ./xdg/xdg.nix
    ./shell/shell.nix
  ];
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-skk fcitx5-mozc fcitx5-gtk ];
  };
  home.packages = with pkgs; [
    mg
    your-editor
    #helix # Use github:helix-editor/helix 's flakes for master build
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
    nyxt
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
    bitwarden-cli
    bitwarden-desktop
    zulip
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

  xresources = {
    properties = {
      # Dracula palette
      "*.foreground" = "#F8F8F2";
      "*.background" = "#282A36";
      "*.color0" = "#000000";
      "*.color8" = "#4D4D4D";
      "*.color1" = "#FF5555";
      "*.color9" = "#FF6E67";
      "*.color2" = "#50FA7B";
      "*.color10" = "#5AF78E";
      "*.color3" = "#F1FA8C";
      "*.color11" = "#F4F99D";
      "*.color4" = "#BD93F9";
      "*.color12" = "#CAA9FA";
      "*.color5" = "#FF79C6";
      "*.color13" = "#FF92D0";
      "*.color6" = "#8BE9FD";
      "*.color14" = "#9AEDFE";
      "*.color7" = "#BFBFBF";
      "*.color15" = "#E6E6E6";
    };
    extraConfig = ''
    '';
  };

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
