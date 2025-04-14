{
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
        (neovimPluginFromGitHub "cf385775279c0c7eed3fbebfac1022f1f05ea292" "vim-skk" "skkeleton"
          "sha256-DA/k2KxGqxYtyJcnV1g2lLbMtNKBXpPGje5WeYYnbtQ="
        )

        # Comment out
        (neovimPluginFromGitHub "0236521ea582747b58869cb72f70ccfa967d2e89" "numToStr" "Comment.nvim"
          "sha256-+dF1ZombrlO6nQggufSb0igXW5zwU++o0W/5ZA07cdc="
        )
      ];
    extraLuaConfig = lib.strings.concatStrings [
      (builtins.readFile ./init.lua)
      skkeleton-jisyo
    ];
  };
}
