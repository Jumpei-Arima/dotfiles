local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

-- Install your plugins here
return packer.startup(function(use)
	-- My plugins here

	use({ "wbthomason/packer.nvim" })
	use({ "nvim-lua/plenary.nvim" }) -- Common utilities

	-- Colorschemes
	use({ "EdenEast/nightfox.nvim" }) -- Color scheme

	use({ "levouh/tint.nvim" })
    use({ "nvim-lualine/lualine.nvim" })
    use({ "nvim-tree/nvim-tree.lua" })
    use({ "tpope/vim-commentary" })
    use({ "nvim-telescope/telescope.nvim" })
    use({ "sindrets/diffview.nvim" })
    use({ "github/copilot.vim" })

    -- Markdown preview
    -- The legacy configs API supports 0.10/0.11 only. On 0.12 use the
    -- bundled Markdown parsers and vim.treesitter.start() in init.lua.
    if vim.fn.has("nvim-0.12") == 0 then
        use({ "nvim-treesitter/nvim-treesitter", branch = "master", run = ":TSUpdate" })
    end
    use({ "iamcco/markdown-preview.nvim", run = "cd app && npm install", ft = { "markdown" } })

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
