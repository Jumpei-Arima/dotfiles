local map = vim.keymap.set

map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
map("n", "<C-a>", "ggVG", { desc = "Select all" })
map("n", "<leader>h", "^", { desc = "Start of line" })
map("n", "<leader>l", "$", { desc = "End of line" })
map("n", "<leader>w", "<cmd>write<cr>", { desc = "Write file" })
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit window" })
map("n", "<Esc><Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
map("i", "jj", "<Esc>", { desc = "Normal mode" })
map("i", "JJ", "<Esc>", { desc = "Normal mode" })

map("n", "[d", function()
	vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Previous diagnostic" })
map("n", "]d", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next diagnostic" })
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic" })
