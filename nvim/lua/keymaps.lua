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

-- Markdown preview is loaded by packer only for Markdown buffers.
vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function(event)
        vim.keymap.set("n", "<Space>m", function()
            if vim.fn.exists(":MarkdownPreviewToggle") == 2 then
                vim.cmd("MarkdownPreviewToggle")
            else
                vim.notify(
                    "Markdown preview is unavailable; run :PackerInstall and :PackerCompile",
                    vim.log.levels.ERROR
                )
            end
        end, { buffer = event.buf, silent = true, desc = "Toggle Markdown preview" })
    end,
})
