return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@module "snacks"
	---@type snacks.Config
	opts = {
		bigfile = { enabled = true },
		-- dashboard = { enabled = true },
		-- explorer = { enabled = true },
		indent = { enabled = true, animate = { enabled = false } },
		-- input = { enabled = true },
		notifier = { enabled = true, timeout = 3000 },
		picker = { enabled = true },
		quickfile = { enabled = true },
		-- scope = { enabled = true },
		scroll = { enabled = false },
		statuscolumn = { enabled = true },
		words = { enabled = true },
		styles = {},
	},
	-- stylua: ignore
	keys = {
		-- Find
		{ "<leader>fb", function() Snacks.picker.buffers() 									end, desc = "Find buffers" },
		{ "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") })	end, desc = "Find Config File" },
		{ "<leader>ff", function() Snacks.picker.files() 									end, desc = "Fuzzy find files in cwd" },
		{ "<leader>fF", function() Snacks.picker.files({ hidden = true }) 					end, desc = "Fuzzy find files in cwd (inlcuding hidden)" },
		{ "<leader>fg", function() Snacks.picker.git_files() 								end, desc = "Find Git Files" },
		{ "<leader>fp", function() Snacks.picker.projects() 								end, desc = "Projects" },
		{ "<leader>fr", function() Snacks.picker.recent() 									end, desc = "Fuzzy find recent files" },
		-- Grep
		{ "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
		{ "<leader>sb", function() Snacks.picker.lines() 		end, desc = "Buffer Lines" },
		{ "<leader>sg", function() Snacks.picker.grep() 		end, desc = "Grep" },
		{ "<leader>sw", function() Snacks.picker.grep_word() 	end, desc = "Visual selection or word", mode = { "n", "x" } },
		-- Search
		{ "<leader>sc", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
		{ "<leader>sh", function() Snacks.picker.help() 		end, desc = "Help Pages" },
		{ "<leader>si", function() Snacks.picker.icons() 		end, desc = "Icons" },
		{ "<leader>sl", function() Snacks.picker.loclist() 		end, desc = "Location List" },
		-- Notifier
		{ "<leader>n", "",																	desc = "notifications"	},
		{ "<leader>nh",	function() Snacks.notifier.show_history()					end,	desc = "History"		},
		{ "<leader>ne",	function() Snacks.notifier.show_history({filter = "error"})	end,	desc = "Errors"			},
		{ "<leader>ni",	function() Snacks.notifier.show_history({filter = "info"})	end,	desc = "Info"			},
		{ "<leader>nw",	function() Snacks.notifier.show_history({filter = "warn"})	end,	desc = "Warn"			},
		{ "<c-esc>",   	function() Snacks.notifier.hide()							end,	desc = "Dismiss"  		},

		-- Other
		{ "<c-`>",      function() Snacks.terminal.toggle(nil, { interactive = false, win = { height = 5 }}) 	end, desc = "Toggle Terminal" },
		{ "<c-/>",      function() Snacks.terminal.open(nil, { interactive = false, win = { height = 5 }}) 	end, desc = "Open Terminal" },
		{ "<leader>rb", function() Snacks.terminal("btop", { win = { position = "float" } }) 	end, desc = "Btop" },
		{ "<leader>rl", function() Snacks.lazygit() 											end, desc = "Lazygit" },
		{ "[[",         function() Snacks.words.jump(-vim.v.count1) 							end, desc = "Prev Reference", mode = { "n", "t" } },
		{ "]]",         function() Snacks.words.jump(vim.v.count1) 								end, desc = "Next Reference", mode = { "n", "t" } },
		{
			"<leader>N",
			desc = "Neovim News",
			function()
				Snacks.win({
					file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
					width = 0.8,
					height = 0.9,
					border = "rounded",
					wo = {
						spell = false,
						wrap = false,
						signcolumn = "yes",
						statuscolumn = " ",
						conceallevel = 3,
					},
				})
			end,
		},
	},
	init = function()
		vim.api.nvim_create_autocmd("User", {
			pattern = "VeryLazy",
			callback = function()
				-- Setup some globals for debugging (lazy-loaded)
				-- stylua: ignore
				_G.dd = function(...) Snacks.debug.inspect(...) end

				-- stylua: ignore
				_G.bt = function() Snacks.debug.backtrace() end

				vim.print = _G.dd -- Override print to use snacks for `:=` command

				-- Create some toggle mappings
				Snacks.toggle.diagnostics():map("<leader>ud")
				Snacks.toggle.dim():map("<leader>uD")
				Snacks.toggle.indent():map("<leader>ug")
				Snacks.toggle.inlay_hints():map("<leader>uh")
				Snacks.toggle.line_number():map("<leader>ul")
				-- stylua: ignore
				Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
				-- stylua: ignore
				Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
				Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
				Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
				Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
				Snacks.toggle.scroll():map("<leader>uS")
				Snacks.toggle.treesitter():map("<leader>uT")
				Snacks.toggle.words():map("<leader>uW")
			end,
		})
	end,
}
