local expected = assert(vim.env.EXPECT_LSP, "EXPECT_LSP is required")
local attached = vim.wait(15000, function()
	for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
		if client.name == expected then
			return true
		end
	end
	return false
end, 100)

if not attached then
	local names = vim.tbl_map(function(client)
		return client.name
	end, vim.lsp.get_clients({ bufnr = 0 }))
	error("Expected " .. expected .. "; attached: " .. table.concat(names, ", "))
end

assert(vim.fn.maparg("gd", "n") ~= "", "LSP buffer keymaps were not created")
print("LSP_ATTACH_PASS:" .. expected)
vim.cmd("qa!")
