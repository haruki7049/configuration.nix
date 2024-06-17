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
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      deno
      rust-analyzer
      lua53Packages.lua-lsp
      nixd
      rubyPackages.solargraph
      ruff
      ruff-lsp
    ];
    plugins = with pkgs.vimPlugins; [
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

      # skkeleton, Vim's SKK
      (neovimPluginFromGitHub "438b9d22d926569db6e6034e0d333edce5f4d4cf"
        "vim-skk" "skkeleton"
        "sha256-jXPMDxiyJ3w4cpRgonlXjdmSJHsnkLhG6NeBjYjeKeo=")

      # Comment out
      (neovimPluginFromGitHub "0236521ea582747b58869cb72f70ccfa967d2e89"
        "numToStr" "Comment.nvim"
        "sha256-+dF1ZombrlO6nQggufSb0igXW5zwU++o0W/5ZA07cdc=")

      # GitHub Copilot
      copilot-vim
    ];
    extraLuaConfig = ''
      -- BASE
      vim.g.mapleader = ' '
      vim.opt.termguicolors = true
      vim.opt.number = true
      vim.opt.syntax = 'on'
      vim.opt.backup = false
      vim.opt.swapfile = false
      vim.scriptencoding = 'utf-8'
      vim.opt.encoding = 'utf-8'
      vim.opt.fileencoding = 'utf-8'
      vim.opt.helplang = "ja", "en"
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      vim.o.formatoptions = vim.o.formatoptions .. 'jql'
      vim.opt.laststatus = 0
      vim.opt.cmdheight = 0
      vim.api.nvim_create_autocmd({'FileType'}, {
        pattern = '*',
        command = 'set formatoptions-=c',
      })

      -- INDENT
      vim.api.nvim_create_autocmd({'FileType'}, {
        pattern = 'lua',
        command = 'setlocal tabstop=2 shiftwidth=2 et',
      })
      vim.api.nvim_create_autocmd({'FileType'}, {
        pattern = 'rust',
        command = 'setlocal tabstop=4 shiftwidth=4 et',
      })
      vim.api.nvim_create_autocmd({'FileType'}, {
        pattern = 'html',
        command = 'setlocal tabstop=4 shiftwidth=4 et',
      })
      vim.api.nvim_create_autocmd({'FileType'}, {
        pattern = 'c',
        command = 'setlocal tabstop=4 shiftwidth=4 et',
      })
      vim.api.nvim_create_autocmd({'FileType'}, {
        pattern = 'sh',
        command = 'setlocal tabstop=4 shiftwidth=4 et',
      })
      vim.api.nvim_create_autocmd({'FileType'}, {
        pattern = 'fish',
        command = 'setlocal tabstop=2 shiftwidth=2 et',
      })
      vim.api.nvim_create_autocmd({'FileType'}, {
        pattern = 'ps1',
        command = 'setlocal tabstop=4 shiftwidth=4 et',
      })
      vim.api.nvim_create_autocmd({'FileType'}, {
        pattern = 'java',
        command = 'setlocal tabstop=4 shiftwidth=4 et',
      })
      vim.api.nvim_create_autocmd({'FileType'}, {
        pattern = 'nix',
        command = 'setlocal tabstop=2 shiftwidth=2 et',
      })
      vim.api.nvim_create_autocmd({'FileType'}, {
        pattern = 'nu',
        command = 'setlocal tabstop=4 shiftwidth=4 et',
      })
      vim.api.nvim_create_autocmd({'FileType'}, {
        pattern = 'typescriptreact',
        command = 'setlocal tabstop=2 shiftwidth=2 et',
      })
      vim.api.nvim_create_autocmd({'FileType'}, {
        pattern = 'gleam',
        command = 'setlocal tabstop=2 shiftwidth=2 et',
      })
      vim.api.nvim_create_autocmd({'FileType'}, {
        pattern = 'lisp',
        command = 'setlocal tabstop=2 shiftwidth=2 et',
      })
      vim.api.nvim_create_autocmd({'FileType'}, {
        pattern = 'typescript',
        command = 'setlocal tabstop=2 shiftwidth=2 et',
      })
      vim.api.nvim_create_autocmd({'FileType'}, {
        pattern = 'nginx',
        command = 'setlocal tabstop=4 shiftwidth=4 et',
      })

      vim.api.nvim_create_autocmd({'FileType'}, {
        pattern = '*',
        command = 'if &l:omnifunc == "" | setlocal omnifunc=syntaxcomplete#Complete | endif',
      })

      -- NEOVIDE
      local font_name = "UDEV Gothic NF:h14"
      if vim.g.neovide then
        vim.o.guifont = font_name
        vim.g.neovide_transparency = 0.98
        vim.g.transparency = 0.98
      end

      -- TERMINAL
      vim.g.sh = "bash"

      -- KEYCONFIG
      vim.keymap.set("n", "<leader>q", "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown())<cr>");
      vim.keymap.set("i", "<C-j>", "<Plug>(skkeleton-enable)");
      vim.keymap.set("c", "<C-j>", "<Plug>(skkeleton-enable)");
      vim.keymap.set("n", "<Leader><Leader>", require('Comment.api').toggle.linewise.current);
      vim.keymap.set("x", "<Leader><Leader>", function()
        vim.api.nvim_feedkeys('<Esc>', 'nx', false)
        require('Comment.api').toggle.linewise(vim.fn.visualmode())
      end);

      -- SKKELETON's JISYO
      vim.api.nvim_exec([[
        call skkeleton#config({
          \   'globalDictionaries': ['~/.skk/.skk-jisyo'],
          \   'eggLikeNewline': v:true,
          \ })
      ]], false);

      -- Comment out, by Comment.nvim
      require('Comment').setup({
        padding = true,
        sticky = true,
        ignore = nil,

        mappings = {
          basic = false,
          extra = false,
        },

        pre_hook = nil,
        post_hook = nil,
      })

      -- LSPCONFIG
      require('lspconfig').rust_analyzer.setup({
        settings = {
          ['rust-analyzer'] = {},
        },
      })
      require('lspconfig').denols.setup({
        settings = {
          ['denols'] = {
            cmd = {
              "deno",
              "lsp",
            },
            filetypes = {
              "javascript",
              "javascriptreact",
              "javascript.jsx",
              "typescript",
              "typescriptreact",
              "typescript.tsx"
            },
            settings = {
              deno = {
                enable = true,
                suggest = {
                  imports = {
                    hosts = {
                      ["https://deno.land"] = true,
                      ["https://jsr.io"] = true,
                    },
                  },
                },
              },
            },
          },
        },
      })
      require('lspconfig').ruff.setup({
        settings = {
          ['ruff'] = {
            cmd = {
              "ruff",
              "server",
              "--preview",
            },
            filetypes = {
              "python",
            },
            single_file_support = true,
          },
        },
      })
      require('lspconfig').ruff_lsp.setup({
        settings = {
          ['ruff-lsp'] = {
            cmd = {
              "ruff-lsp",
            },
            filetypes = {
              "python",
            },
            single_file_support = true,
          },
        },
      })
      require('lspconfig').solargraph.setup({
        settings = {
          ['solargraph'] = {
            cmd = {
              "solargraph",
              "stdio",
            },
            filetypes = {
              "ruby",
            },
            settings = {
              solargraph = {
                diagnostics = true,
              },
            },
          },
        },
      })
      require('lspconfig').lua_ls.setup({
        settings = {
          Lua = {
            diagnostics = {
              globals = {
                'vim',
              },
            },
            telemetry = {
              enable = true,
            },
          },
        },
      })
      require('lspconfig').nixd.setup({
        settings = {
          ['nixd'] = {
            nixpkgs = {
              expr = "import <nixpkgs> { }",
            },
            formatting = {
              command = { "nixpkgs-fmt" },
            },
            options = {
              nixos = {
                expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.k-on.options',
              },
              home_manager = {
                expr = '(builtins.getFlake ("git+file://" + toString ./.)).homeConfigurations."ruixi@k-on".options',
              },
            },
          },
        },
      })

      -- COLORSCHEME
      vim.cmd("colorscheme zephyr")
    '';
  };
}
