return {
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		keys = {
			{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
			{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Find text" },
			{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
			{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Find help" },
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			defaults = {
				mappings = { i = { ["<C-u>"] = false, ["<C-d>"] = false } },
			},
		},
	},
	{
		"tpope/vim-commentary",
		event = { "BufReadPost", "BufNewFile" },
	},
	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		opts = {},
		keys = {
			{
				"<leader>rs",
				function()
					require("persistence").load()
				end,
				desc = "Restore session",
			},
			{
				"<leader>rl",
				function()
					require("persistence").load({ last = true })
				end,
				desc = "Restore last session",
			},
			{
				"<leader>rd",
				function()
					require("persistence").stop()
				end,
				desc = "Do not save session",
			},
		},
	},
	{
		"iamcco/markdown-preview.nvim",
		ft = { "markdown" },
		build = "cd app && npm install --package-lock=false",
		keys = {
			{
				"<leader>m",
				"<cmd>MarkdownPreviewToggle<cr>",
				ft = "markdown",
				desc = "Toggle Markdown preview",
			},
		},
	},
}
