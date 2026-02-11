{
  pkgs,
  ...
}:

{
  imports = [
    ./editor
    ./tools
    ./shell
  ];
  home.packages = [
    pkgs.htop
    pkgs.wget
    pkgs.curl
    pkgs.unzip
    pkgs.gzip
    pkgs.git
    pkgs.deno # For Vim denops
    pkgs.vim-full
    pkgs.gnupg # GPG
  ];

  nix.settings = {
    accept-flake-config = true;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;

      # Shell integration
      enableBashIntegration = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
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
