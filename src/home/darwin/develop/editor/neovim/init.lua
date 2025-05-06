-- BASE
vim.g.mapleader = " "
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.syntax = "on"
vim.opt.backup = false
vim.opt.swapfile = false
vim.scriptencoding = "utf-8"
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.helplang = "ja", "en"
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.o.formatoptions = vim.o.formatoptions .. "jql"
vim.opt.laststatus = 0
vim.opt.cmdheight = 0
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = "*",
    command = "set formatoptions-=c",
})

-- INDENT
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = "lua",
    command = "setlocal tabstop=2 shiftwidth=2 et",
})
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = "rust",
    command = "setlocal tabstop=4 shiftwidth=4 et",
})
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = "html",
    command = "setlocal tabstop=4 shiftwidth=4 et",
})
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = "c",
    command = "setlocal tabstop=4 shiftwidth=4 et",
})
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = "sh",
    command = "setlocal tabstop=4 shiftwidth=4 et",
})
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = "fish",
    command = "setlocal tabstop=2 shiftwidth=2 et",
})
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = "ruby",
    command = "setlocal tabstop=2 shiftwidth=2 et",
})
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = "ps1",
    command = "setlocal tabstop=4 shiftwidth=4 et",
})
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = "java",
    command = "setlocal tabstop=4 shiftwidth=4 et",
})
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = "nix",
    command = "setlocal tabstop=2 shiftwidth=2 et",
})
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = "nu",
    command = "setlocal tabstop=4 shiftwidth=4 et",
})
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = "typescriptreact",
    command = "setlocal tabstop=2 shiftwidth=2 et",
})
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = "gleam",
    command = "setlocal tabstop=2 shiftwidth=2 et",
})
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = "lisp",
    command = "setlocal tabstop=2 shiftwidth=2 et",
})
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = "typescript",
    command = "setlocal tabstop=2 shiftwidth=2 et",
})
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = "nginx",
    command = "setlocal tabstop=4 shiftwidth=4 et",
})
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = "json",
    command = "setlocal tabstop=2 shiftwidth=2 et",
})

vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = "*",
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
vim.keymap.set(
    "n",
    "<leader>q",
    "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown())<cr>"
)
vim.keymap.set("i", "<C-j>", "<Plug>(skkeleton-enable)")
vim.keymap.set("c", "<C-j>", "<Plug>(skkeleton-enable)")

-- LSPCONFIG
require("lspconfig").rust_analyzer.setup({
    settings = {
        ["rust-analyzer"] = {},
    },
})
require("lspconfig").denols.setup({
    root_dir = require("lspconfig").util.root_pattern("deno.json"),
    settings = {
        ["denols"] = {
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
                "typescript.tsx",
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
require("lspconfig").ts_ls.setup({
    root_dir = require("lspconfig").util.root_pattern("package.json"),
})
require("lspconfig").ruff.setup({
    settings = {
        ["ruff"] = {
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
require("lspconfig").rubocop.setup({})
require("lspconfig").lua_ls.setup({
    settings = {
        Lua = {
            diagnostics = {
                globals = {
                    "vim",
                },
            },
            telemetry = {
                enable = true,
            },
        },
    },
})
require("lspconfig").nil_ls.setup({
    autostart = true,
    settings = {
        ["nil"] = {
            testSettings = 42,
            formatting = {
                command = { "nixpkgs-fmt" },
            },
        },
    },
})
require("lspconfig").gopls.setup({
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
            },
            gofumpt = true,
        },
    },
})
require("lspconfig").gleam.setup({
    autostart = true,
})
require("lspconfig").zls.setup({
    settings = {
        diagnostics = false,
    },
})

-- COLORSCHEME
vim.cmd("colorscheme base16-dracula")

-- DON'T FORMAT ON SAVE, ZIGLANG!!
vim.g.zig_fmt_autosave = false
