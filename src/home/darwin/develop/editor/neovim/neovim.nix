{
  config,
  lib,
  pkgs,
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
    extraPackages = with pkgs; [
      deno
    ];
    plugins =
      (with pkgs.vimPlugins; [
        # Colorscheme, nvim-base16
        base16-nvim

        # plenary, A library for plugin creator
        plenary-nvim

        # denops, A Deno-Vim library for plugin creator
        denops-vim

        # Telescope
        telescope-nvim
        telescope-file-browser-nvim

        # lspconfig
        nvim-lspconfig

        # GitHub Copilot
        copilot-vim

        # Treesitter
        nvim-treesitter.withAllGrammars
      ])
      ++ [
        # Comment out
        (neovimPluginFromGitHub "0236521ea582747b58869cb72f70ccfa967d2e89" "numToStr" "Comment.nvim"
          "sha256-+dF1ZombrlO6nQggufSb0igXW5zwU++o0W/5ZA07cdc="
        )
      ];
    extraLuaConfig = builtins.readFile ./init.lua;
  };
}
