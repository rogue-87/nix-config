---@type vim.lsp.Config
return {
	cmd = { "pyright-langserver", "--stdio" },
	filetypes = { "python", "py" },
	root_markers = {
		"pyproject.toml",
		"setup.py",
		"setup.cfg",
		"requirements.txt",
		"Pipfile",
		"pyrightconfig.json",
		".git",
	},
	settings = {
		python = {
			analysis = {
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				diagnosticMode = "openFilesOnly",
			},
		},
	},
	commands = {
		-- description = "Organize Imports",
		PyrightOrganizeImports = function(command, ctx)
			local params = {
				command = "pyright.organizeimports",
				arguments = { vim.uri_from_bufnr(0) },
			}

			local clients = vim.lsp.get_clients({
				bufnr = vim.api.nvim_get_current_buf(),
				name = "pyright",
			})
			for _, client in ipairs(clients) do
				client:request("workspace/executeCommand", params, nil, 0)
			end
		end,
		-- description = "Reconfigure pyright with the provided python path",
		-- nargs = 1,
		-- complete = "file",
		PyrightSetPythonPath = function(command, ctx)
			local clients = vim.lsp.get_clients({
				bufnr = vim.api.nvim_get_current_buf(),
				name = "pyright",
			})

			for _, client in ipairs(clients) do
				if client.settings then
					client.settings.python = vim.tbl_deep_extend("force", client.settings.python, { pythonPath = path })
				else
					client.config.settings =
						vim.tbl_deep_extend("force", client.config.settings, { python = { pythonPath = path } })
				end
				client:notify("workspace/didChangeConfiguration", { settings = nil })
			end
		end,
	},
}
