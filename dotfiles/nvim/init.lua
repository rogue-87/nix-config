local utils = require("myutils")

-- load vim settings(options, keymaps, etc...)
require("config.options")
utils.lazy_load({ "config.keymaps", "config.autocmds" })

-- bootstrap lazy.nvim
require("config.lazy")

-- choose colorscheme
vim.cmd("colorscheme nightfox")

-- language server configs to enable
vim.lsp.enable({
	-- shell langs
	"bashls",
	"fish-lsp",
	-- programming langs
	"clangd",
	"luals",
	"omnisharp",
	"pyright",
	"nixd",
	-- other
	"jsonls",
	"taplo",
})
