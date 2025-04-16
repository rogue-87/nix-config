---@diagnostic disable: missing-fields
return {
	"folke/noice.nvim",
	dependencies = { "MunifTanjim/nui.nvim" },
	---@type NoiceConfig
	opts = {
		cmdline = {
			enabled = true,
		},
		health = { checker = false },
		lsp = {
			hover = { enabled = false },
			message = { enabled = false },
			progress = { enabled = false },
			signature = { enabled = false },
		},
		messages = { enabled = true },
		notify = { enabled = false, view = "mini" },
		popupmenu = { enabled = true },
		presets = {
			bottom_search = true,
			cmdline_output_to_split = false,
			command_palette = true,
			inc_rename = false,
			long_message_to_split = false,
			lsp_doc_border = false,
		},
	},
}
