return {
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns
				local function map(lhs, rhs, desc)
					vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
				end
				map("]c", function()
					if vim.wo.diff then
						return "]c"
					end
					vim.schedule(gs.next_hunk)
					return "<Ignore>"
				end, "Next Git hunk")
				map("[c", function()
					if vim.wo.diff then
						return "[c"
					end
					vim.schedule(gs.prev_hunk)
					return "<Ignore>"
				end, "Previous Git hunk")
				map("<leader>gp", gs.preview_hunk, "Preview Git hunk")
				map("<leader>gb", gs.blame_line, "Blame line")
			end,
		},
	},
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Open Git diff" },
			{ "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Close Git diff" },
			{ "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File history" },
		},
	},
}
