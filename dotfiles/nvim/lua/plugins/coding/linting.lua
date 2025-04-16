-- noice
return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufWritePost", "BufNewFile" },
	config = function()
		local lint = require("lint")
		-- LINTER CONFIG
		lint.linters_by_ft = {
			go = { "golint" },
			lua = { "selene" },
			python = { "ruff" },
			rust = { "clippy" },
		}

		-- AUTO COMMANDS
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave", "TextChanged" }, {
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
