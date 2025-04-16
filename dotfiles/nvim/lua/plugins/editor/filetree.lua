return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	lazy = false,
	keys = {
		{ "<leader>e", "<cmd>Neotree toggle<cr>", desc = "explore" },
		{ "<leader>\\", "<cmd>Neotree reveal<cr>", desc = "reveal file location in Filetree" },
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	---@module "neo-tree"
	opts = {
		close_if_last_window = false,
		enable_git_status = true,
		enable_diagnostics = true,
		open_files_do_not_replace_types = { "terminal", "trouble", "qf" },
		sort_case_insensitive = false,
		filesystem = {
			filtered_items = {
				visible = true,
				hide_dotfiles = true,
				hide_gitignored = true,
				hide_by_name = {
					"node_modlues",
				},
				hide_by_pattern = { -- uses glob style patterns
					--"*.meta",
					--"*/src/*/tsconfig.json",
				},
				always_show = { -- remains visible even if other settings would normally hide it
					--".gitignored",
				},
				always_show_by_pattern = { -- uses glob style patterns
					--".env*",
				},
				never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
					--".DS_Store",
					--"thumbs.db"
				},
				never_show_by_pattern = { -- uses glob style patterns
					--".null-ls_*",
				},
			},
			window = {
				mappings = {
					["O"] = "system_open",
					["P"] = {
						"toggle_preview",
						config = {
							use_float = false,
						},
					},
				},
			},
		},
		window = {
			position = "right",
			width = 40,
		},
		source_selector = {
			winbar = false,
			statusline = false,
		},
		default_component_configs = {
			diagnostics = {
				symbols = {
					hint = "󰌵",
					info = " ",
					warn = " ",
					error = " ",
				},
				highlights = {
					hint = "DiagnosticSignHint",
					info = "DiagnosticSignInfo",
					warn = "DiagnosticSignWarn",
					error = "DiagnosticSignError",
				},
			},
			git_status = {
				symbols = {
					-- Change type
					added = "",
					modified = "",
					deleted = "✖",
					renamed = "󰁕",
					-- Status type
					untracked = "",
					ignored = "",
					unstaged = "",
					staged = "",
					conflict = "",
				},
			},
		},
		commands = {
			system_open = function(state)
				local node = state.tree:get_node()
				local path = node:get_id()
				-- macOs: open file in default application in the background.
				vim.fn.jobstart({ "xdg-open", "-g", path }, { detach = true })
				-- Linux: open file in default application
				vim.fn.jobstart({ "xdg-open", path }, { detach = true })

				-- Windows: Without removing the file from the path, it opens in code.exe instead of explorer.exe
				local p
				local lastSlashIndex = path:match("^.+()\\[^\\]*$") -- Match the last slash and everything before it
				if lastSlashIndex then
					p = path:sub(1, lastSlashIndex - 1) -- Extract substring before the last slash
				else
					p = path -- If no slash found, return original path
				end
				vim.cmd("silent !start explorer " .. p)
			end,
		},
	},
}
