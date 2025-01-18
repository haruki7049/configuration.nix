{
  pkgs,
  lib,

  # TODO: These cannot import by 'imports' attribute
  #vimPlugins,
  #vimUtils,
  #fetchFromGitHub,
  #deno,
  ...
}:

let
  neovimPluginFromGitHub =
    rev: owner: repo: sha256:
    pkgs.vimUtils.buildVimPlugin {
      pname = "${lib.strings.sanitizeDerivationName repo}";
      version = rev;
      src = pkgs.fetchFromGitHub {
        owner = owner;
        repo = repo;
        rev = rev;
        sha256 = sha256;
      };
    };
in

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraPackages = [
      pkgs.deno
    ];
    plugins =
      [
        # Colorscheme, nvim-base16
        pkgs.vimPlugins.base16-nvim

        # plenary, A library for plugin creator
        pkgs.vimPlugins.plenary-nvim

        # denops, A Deno-Vim library for plugin creator
        pkgs.vimPlugins.denops-vim

        # Telescope
        pkgs.vimPlugins.telescope-nvim
        pkgs.vimPlugins.telescope-file-browser-nvim

        # lspconfig
        pkgs.vimPlugins.nvim-lspconfig

        # Treesitter
        pkgs.vimPlugins.nvim-treesitter.withAllGrammars
      ]
      ++ [
        # Comment out
        (neovimPluginFromGitHub "0236521ea582747b58869cb72f70ccfa967d2e89" "numToStr" "Comment.nvim"
          "sha256-+dF1ZombrlO6nQggufSb0igXW5zwU++o0W/5ZA07cdc="
        )
      ];
    extraLuaConfig = builtins.readFile ./init.lua;
  };
}
