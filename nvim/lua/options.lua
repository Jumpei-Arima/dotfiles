local options = {
    encoding = "utf-8",
    fileencoding = "utf-8",
    title = true,
    backup = false,
    clipboard = "unnamed",
    cmdheight = 2,
    completeopt = { "menuone", "noselect" },
    conceallevel = 0,
    mouse = "a",
    pumheight = 10,
    showmode = true,
    showtabline = 2,
    ignorecase = true,
    smartcase = true,
    hlsearch = true,
    smartindent = true,
    swapfile = false,
    termguicolors = true,
    timeoutlen = 300,
    undofile = true,
    updatetime = 300,
    writebackup = false,
    expandtab = true,
    shiftwidth = 4,
    tabstop = 4,
    cursorline = true,
    number = true,
    relativenumber = false,
    numberwidth = 3,
    signcolumn = "yes",
    wrap = false,
    winblend = 0,
    wildoptions = "pum",
    pumblend = 5,
    background = "dark",
    scrolloff = 8,
    sidescrolloff = 8,
    guifont = "monospace:h17",
    splitbelow = false,
    splitright = false,
}

vim.opt.shortmess:append("c")

for k, v in pairs(options) do
	vim.opt[k] = v
end

vim.cmd("set whichwrap=b,s,h,l,<,>,[,],~")
vim.cmd([[set iskeyword+=-]])
