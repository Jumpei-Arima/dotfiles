return {
	{
		"stevearc/conform.nvim",
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>fm",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = { "n", "v" },
				desc = "Format buffer",
			},
		},
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "ruff_format" },
				c = { "clang_format" },
				cpp = { "clang_format" },
				sh = { "shfmt" },
				zsh = { "shfmt" },
				javascript = { "prettier", stop_after_first = true },
				typescript = { "prettier", stop_after_first = true },
				json = { "prettier", stop_after_first = true },
				yaml = { "prettier", stop_after_first = true },
				markdown = { "prettier", stop_after_first = true },
			},
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "mason-org/mason.nvim" },
		opts = {
			ensure_installed = {
				"stylua",
				"ruff",
				"clang-format",
				"shfmt",
				"prettier",
				"lua-language-server",
				"basedpyright",
				"clangd",
				"gopls",
				"bash-language-server",
				"json-lsp",
				"yaml-language-server",
				"typescript-language-server",
			},
			auto_update = false,
			run_on_start = true,
			start_delay = 1000,
			debounce_hours = 24,
		},
	},
}
