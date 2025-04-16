return {
	-- Auto close
	{ "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
	-- Close surrounding text
	{ "kylechui/nvim-surround", version = "^3.0.0", event = "VeryLazy", opts = {} },
	-- autoclose & autorename for html tags
	{ "windwp/nvim-ts-autotag", opts = {} },
	-- Commenting
	{
		"numToStr/Comment.nvim",
		dependencies = "JoosepAlviste/nvim-ts-context-commentstring",
		event = { "BufReadPre", "BufNewFile" },
		opts = function()
			return { pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook() }
		end,
	},
	-- Moving code
	{
		"fedepujol/move.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("move").setup({})
			local opts = { noremap = true, silent = true }
			vim.keymap.set("n", "<A-j>", ":MoveLine(1)<cr>", opts)
			vim.keymap.set("n", "<A-k>", ":MoveLine(-1)<cr>", opts)
			vim.keymap.set("v", "<A-j>", ":MoveBlock(1)<cr>", opts)
			vim.keymap.set("v", "<A-k>", ":MoveBlock(-1)<cr>", opts)
		end,
	},
}
