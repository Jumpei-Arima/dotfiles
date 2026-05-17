if not vim.o.loadplugins then
  dofile(vim.fn.stdpath("config") .. "/vanilla_init.lua")
  return
end

vim.cmd("autocmd!")

vim.g.mapleader = " "
vim.o.encoding = "utf-8"
vim.scriptencoding = "utf-8"

require("autocmds")
require("options")
require("keymaps")
require("colorscheme")
require("plugins")

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
require("nvim-tree").setup()

local ts_ok, ts = pcall(require, "nvim-treesitter.configs")
if ts_ok then
    ts.setup({
        ensure_installed = { "markdown", "markdown_inline" },
        highlight = { enable = true },
    })
end
