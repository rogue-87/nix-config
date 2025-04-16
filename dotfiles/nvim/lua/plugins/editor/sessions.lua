return {
	"folke/persistence.nvim",
    -- stylua: ignore
	keys = {
		{ "<leader>qs", function() require("persistence").load()                end, desc = "Load session for cwd" },
		{ "<leader>qS", function() require("persistence").select()              end, desc = "Select session" },
		{ "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Load last session" },
		{ "<leader>qd", function() require("persistence").stop()                end, desc = "Stop Persistence: session won't be saved on exit" },
	},
	event = "BufReadPre", -- this will only start session saving when an actual file was opened
	opts = {},
}
