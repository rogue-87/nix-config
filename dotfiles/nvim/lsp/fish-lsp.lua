---@type vim.lsp.Config
return {
	cmd = { "fish-lsp", "start" },
	cmd_env = { fish_lsp_show_client_popups = false },
	filetypes = { "fish" },
	root_marker = { ".git" },
}
