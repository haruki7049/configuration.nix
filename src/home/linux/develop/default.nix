{
  pkgs,
  ...
}:

let
  cli-tools = [
    pkgs.git
    pkgs.wget
    pkgs.curl
    pkgs.unzip
    pkgs.zip
    pkgs.gzip
    pkgs.mpc
    pkgs.htop
    pkgs.nixfmt-rfc-style
    pkgs.deno # For denops.vim
    pkgs.vim-full
    pkgs.wl-clipboard
    pkgs.unar
    pkgs.file
    pkgs.cmus
  ];

  browsers = [
    pkgs.brave
    pkgs.google-chrome
    pkgs.nyxt
    pkgs.vivaldi
  ];

  sns = [
    pkgs.discord
    pkgs.element-desktop
    pkgs.slack
    pkgs.whalebird
    pkgs.zulip
  ];

  desktop-apps = [
    pkgs.anki
    pkgs.spotify
    pkgs.obsidian
    pkgs.zotero
    pkgs.vlc
    pkgs.prismlauncher
  ];

  bitwarden = [
    pkgs.bitwarden-cli
    pkgs.bitwarden-desktop
  ];
in

{
  imports = [
    ./windowManager
    ./browser
    ./mpd
    ./shell
    ./tools
    ./editor
    ./xdg
  ];

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";

    # Fcitx5
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-skk
        fcitx5-mozc
        fcitx5-gtk
      ];
    };
  };

  qt.enable = true;

  home.packages = cli-tools ++ browsers ++ sns ++ desktop-apps ++ bitwarden;

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
      "sha256-jpEuovyLr9HBDsShJo1efRxd21Fxi7HIjXtPJmLQaCU="
      "bibata"
      24;

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
    extraConfig = '''';
  };

  nix.settings = {
    accept-flake-config = true;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  nixpkgs.config.allowUnfree = true;

  services = {
    gpg-agent = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;

      pinentry.package = pkgs.pinentry-tty;
    };
  };

  programs = {
    gpg.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;

      # Shell integrations
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
    };
    alacritty = {
      enable = true;
      settings = {
        font.size = 9.0;
        font.normal.family = "UDEV Gothic NF";

        window.opacity = 0.7;

        colors = {
          # Dracula color theme
          # https://github.com/dracula/alacritty
          primary.background = "#282a36";
          primary.foreground = "#f8f8f2";
          primary.bright_foreground = "#ffffff";
          cursor.text = "#282a36";
          cursor.cursor = "#f8f8f2";
          vi_mode_cursor.text = "CellBackground";
          vi_mode_cursor.cursor = "CellForeground";
          selection.text = "CellForeground";
          selection.background = "#44475a";
          normal.black = "#21222c";
          normal.red = "#ff5555";
          normal.green = "#50fa7b";
          normal.yellow = "#f1fa8c";
          normal.blue = "#bd93f9";
          normal.magenta = "#ff79c6";
          normal.cyan = "#a4ffff";
          normal.white = "#ffffff";
          search.matches.foreground = "#44475a";
          search.matches.background = "#50fa7b";
          search.focused_match.foreground = "#44475a";
          search.focused_match.background = "#ffb86c";
          footer_bar.foreground = "#f8f8f2";
          footer_bar.background = "#282a36";
          hints.start.foreground = "#282a36";
          hints.start.background = "#f1fa8c";
          hints.end.foreground = "#f1fa8c";
          hints.end.background = "#282a36";
        };
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
