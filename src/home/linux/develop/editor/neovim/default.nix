{
  lib,
  pkgs,
  ...
}:

let
  neovimPluginFromGitHub =
    {
      owner,
      repo,
      rev,
      sha256,
    }:
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
        \   'globalDictionaries': ['${pkgs.skkDictionaries.l}/share/skk/SKK-JISYO.L'],
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
    extraPackages = [
      pkgs.deno
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

        # Treesitter
        nvim-treesitter.withAllGrammars
      ])
      ++ [
        # skkeleton, Vim's SKK
        (neovimPluginFromGitHub {
          owner = "vim-skk";
          repo = "skkeleton";
          rev = "cf385775279c0c7eed3fbebfac1022f1f05ea292";
          sha256 = "sha256-DA/k2KxGqxYtyJcnV1g2lLbMtNKBXpPGje5WeYYnbtQ=";
        })

        # janet-vim
        (neovimPluginFromGitHub {
          owner = "janet-lang";
          repo = "janet.vim";
          rev = "67075b190a44310df356137e35cc1949782b20e0";
          sha256 = "sha256-TmbInorBSlKSK/D59izThad7PSfH2JmJdAnbOMhixHA=";
        })

        # pest.vim
        (neovimPluginFromGitHub {
          owner = "pest-parser";
          repo = "pest.vim";
          rev = "7cfcb43f824e74d13dfe631359fff2ec23836a77";
          sha256 = "sha256-EQcMSsKWtQvr0eQ6Hn0TtDA5Nc7VV0g2bnbx7i2B7u4=";
        })
      ];
    extraLuaConfig = lib.strings.concatStrings [
      (builtins.readFile ./init.lua)
      skkeleton-jisyo
    ];
  };
}
