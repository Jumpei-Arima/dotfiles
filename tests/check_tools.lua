local required = {
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
}

local registry = require("mason-registry")
for _, name in ipairs(required) do
	local package = registry.get_package(name)
	assert(package:is_installed(), name .. " is not installed")
end

print("MASON_TOOLS_PASS:" .. #required)
vim.cmd("qa!")
