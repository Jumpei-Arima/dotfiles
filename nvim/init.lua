if not vim.o.loadplugins then
	dofile(vim.fn.stdpath("config") .. "/vanilla_init.lua")
	return
end

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.clipboard")

-- Keep package-manager writes inside Neovim's cache. This also avoids broken
-- ownership in a shared ~/.npm cache on migrated machines.
vim.env.npm_config_cache = vim.fn.stdpath("cache") .. "/npm"
vim.env.COREPACK_HOME = vim.fn.stdpath("cache") .. "/corepack"
vim.env.COREPACK_ENABLE_PROJECT_SPEC = "0"
vim.env.YARN_CACHE_FOLDER = vim.fn.stdpath("cache") .. "/yarn"
require("config.lazy")
