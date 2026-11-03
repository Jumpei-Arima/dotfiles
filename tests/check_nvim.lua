-- Run from the repository after installing the configured plugins:
-- nvim --headless -i NONE -c 'luafile tests/check_nvim.lua'
-- Requires curl and the Markdown preview dependencies. Opens no browser.
local root = vim.fn.tempname() .. "/"
vim.fn.mkdir(root, "p")
vim.fn.writefile({ "# Dotfiles smoke test", "", "- Markdown preview" }, root .. "smoke.md")
vim.fn.writefile({ "local x={1,2,3}" }, root .. "format.lua")
local function check()
	assert(vim.v.errmsg == "", vim.v.errmsg)
	assert(vim.g.colors_name == "nightfox")
	require("lazy").load({
		plugins = {
			"nvim-tree.lua",
			"telescope.nvim",
			"diffview.nvim",
			"nvim-cmp",
			"conform.nvim",
			"gitsigns.nvim",
			"persistence.nvim",
			"which-key.nvim",
			"copilot.vim",
		},
	})
	for _, name in ipairs({
		"nvim-tree",
		"telescope",
		"diffview",
		"lualine",
		"cmp",
		"conform",
		"gitsigns",
		"persistence",
		"which-key",
	}) do
		assert(pcall(require, name), name)
	end
	vim.cmd.cd(root)
	vim.cmd("NvimTreeToggle")
	assert(#vim.api.nvim_list_wins() >= 2)
	vim.cmd("NvimTreeClose")
	assert(vim.fn.maparg("jj", "i") == "<Esc>")
	assert(vim.fn.maparg("<C-n>", "n") ~= "")
	assert(vim.fn.maparg("<M-l>", "i") ~= "")

	vim.cmd("edit " .. vim.fn.fnameescape(root .. "format.lua"))
	require("conform").format({ async = false, timeout_ms = 10000 })
	assert(vim.api.nvim_get_current_line() == "local x = { 1, 2, 3 }", "Stylua formatting failed")

	vim.cmd("edit " .. vim.fn.fnameescape(root .. "smoke.md"))
	assert(vim.bo.filetype == "markdown")
	local parser = vim.treesitter.get_parser(0, "markdown")
	assert(#parser:parse() > 0)
	assert(vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()])
	assert(vim.fn.exists(":MarkdownPreview") == 2)
	vim.cmd([[function! DotfilesCaptureURL(url)
        let g:dotfiles_preview_url = a:url
    endfunction]])
	vim.g.mkdp_browserfunc = "DotfilesCaptureURL"
	vim.g.mkdp_open_to_the_world = 0
	vim.cmd("MarkdownPreview")
	assert(
		vim.wait(20000, function()
			return vim.g.dotfiles_preview_url ~= nil
		end, 100),
		"Preview URL timeout"
	)
	local html, http_exit = "", nil
	local job = vim.fn.jobstart(
		{ "curl", "--fail", "--silent", "--show-error", "--max-time", "15", vim.g.dotfiles_preview_url },
		{
			stdout_buffered = true,
			on_stdout = function(_, data)
				html = table.concat(data, "\n")
			end,
			on_exit = function(_, code)
				http_exit = code
			end,
		}
	)
	assert(job > 0)
	assert(
		vim.wait(20000, function()
			return http_exit ~= nil
		end, 50),
		"HTTP job timeout"
	)
	assert(http_exit == 0, "Preview HTTP failed: " .. tostring(http_exit))
	assert(html:lower():find("<!doctype html"), "Expected HTML response")
	print("Lazy plugins, keymaps, formatting, Markdown highlighting and preview HTTP: PASS")
	vim.cmd("MarkdownPreviewStop")
end
local ok, err = pcall(check)
pcall(vim.cmd, "MarkdownPreviewStop")
vim.fn.delete(root, "rf")
if not ok then
	print(err)
	vim.cmd("cquit 1")
else
	print("NVIM_SMOKE_PASS")
	vim.cmd("qa!")
end
