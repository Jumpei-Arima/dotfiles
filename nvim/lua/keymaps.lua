local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

keymap("n", "<C-a>", "gg<S-v>G", opts)
keymap("n", "<Space>h", "^", opts)
keymap("n", "<Space>l", "$", opts)
keymap("n", "<Space>w",  ":<C-u>w<Return>", opts)
keymap("n", "<Space>q",  ":<C-u>q<Return>", opts)
keymap("n", "<Esc><Esc>", ":<C-u>set nohlsearch<Return>", opts)
keymap("i", "jj", "<ESC>", opts)
keymap("i", "JJ", "<ESC>", opts)

-- NvimTree
keymap("n", "<C-n>", ":<C-u>NvimTreeToggle<Return>", opts)

-- Markdown preview
keymap("n", "<Space>m", ":<C-u>MarkdownPreviewToggle<Return>", opts)
