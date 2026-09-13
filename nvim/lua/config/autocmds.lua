local group = vim.api.nvim_create_augroup("dotfiles", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
	group = group,
	pattern = "*",
	callback = function()
		local view = vim.fn.winsaveview()
		vim.cmd([[keepjumps keeppatterns silent! %s/\s\+$//e]])
		vim.fn.winrestview(view)
	end,
	desc = "Remove trailing whitespace",
})

vim.api.nvim_create_autocmd("BufReadPost", {
	group = group,
	pattern = "*",
	callback = function(event)
		local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
		local line_count = vim.api.nvim_buf_line_count(event.buf)
		if mark[1] > 0 and mark[1] <= line_count then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
	desc = "Restore cursor position",
})

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	pattern = { "markdown", "markdown_inline" },
	callback = function(event)
		pcall(vim.treesitter.start, event.buf)
	end,
	desc = "Use Neovim's bundled Markdown parser",
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = group,
	callback = function(event)
		local opts = { buffer = event.buf, silent = true }
		local function lsp_map(lhs, rhs, desc)
			vim.keymap.set("n", lhs, rhs, vim.tbl_extend("force", opts, { desc = desc }))
		end
		lsp_map("gd", vim.lsp.buf.definition, "Go to definition")
		lsp_map("gr", vim.lsp.buf.references, "Find references")
		lsp_map("K", vim.lsp.buf.hover, "Show documentation")
		lsp_map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
		lsp_map("<leader>ca", vim.lsp.buf.code_action, "Code action")
	end,
	desc = "Set LSP keymaps",
})
