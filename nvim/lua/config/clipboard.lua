if vim.env.SSH_TTY or vim.env.SSH_CONNECTION or vim.env.MOSH_IP then
	vim.g.clipboard = "osc52"
end
