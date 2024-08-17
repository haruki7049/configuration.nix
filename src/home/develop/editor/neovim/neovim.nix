{ config, lib, pkgs, ... }:
let
  neovimPluginFromGitHub = rev: owner: repo: sha256:
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
  skkeleton-jisyo = ''
    -- SKKELETON's JISYO
    vim.api.nvim_exec(
      [[
      call skkeleton#config({
        \   'globalDictionaries': ['${pkgs.skk-dicts}/share/SKK-JISYO.L'],
        \   'eggLikeNewline': v:true,
        \ })
    ]],
      false
    )
  '';
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      deno
      typescript-language-server
      rust-analyzer
      lua53Packages.lua-lsp
      nixd
      rubyPackages.solargraph
      ruff
      ruff-lsp
      gopls
      zls
    ];
    plugins = (with pkgs.vimPlugins; [
      # zephyr-nvim, A colorscheme for neovim and vim
      zephyr-nvim

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
    ]) ++ [
      # skkeleton, Vim's SKK
      (neovimPluginFromGitHub "438b9d22d926569db6e6034e0d333edce5f4d4cf"
        "vim-skk" "skkeleton"
        "sha256-jXPMDxiyJ3w4cpRgonlXjdmSJHsnkLhG6NeBjYjeKeo=")

      # Comment out
      (neovimPluginFromGitHub "0236521ea582747b58869cb72f70ccfa967d2e89"
        "numToStr" "Comment.nvim"
        "sha256-+dF1ZombrlO6nQggufSb0igXW5zwU++o0W/5ZA07cdc=")
    ];
    extraLuaConfig = lib.strings.concatStrings [
      (builtins.readFile ./init.lua)
      skkeleton-jisyo
    ];
  };
}
