return {
	"nvimdev/lspsaga.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter", -- optional
		"nvim-tree/nvim-web-devicons", -- optional
	},
	---@type LspsagaConfig
	opts = {
		lightbulb = {
			sign = false,
			virtual_text = true,
		},
	},
}
