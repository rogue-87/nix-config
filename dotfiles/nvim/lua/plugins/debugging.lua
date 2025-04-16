---@param config {args?:string[]|fun():string[]?}
local function get_args(config)
	local args = type(config.args) == "function" and (config.args() or {}) or config.args or {}
	config = vim.deepcopy(config)
	---@cast args string[]
	config.args = function()
		local new_args = vim.fn.input("Run with args: ", table.concat(args, " ")) --[[@as string]]
		return vim.split(vim.fn.expand(new_args) --[[@as string]], " ")
	end
	return config
end

return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			{ "theHamsta/nvim-dap-virtual-text", opts = {} },
			{ "igorlfs/nvim-dap-view", opts = {} },
		},
		init = function()
			local icons = require("myutils.icons")
			-- signs
			-- configure debugger diagnostics signs
			for name, icon in pairs(icons.debugger) do
				vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
			end
		end,
		-- stylua: ignore
		keys = {
			{ "<leader>d", "", desc = "+debug", mode = {"n", "v"} },
			{ "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: '))  end, desc = "Breakpoint Condition" },
			{ "<leader>db", function() require("dap").toggle_breakpoint()             end, desc = "Toggle Breakpoint" },
			{ "<leader>dc", function() require("dap").continue()                      end, desc = "Continue" },
			{ "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
			{ "<leader>dC", function() require("dap").run_to_cursor()                 end, desc = "Run to Cursor" },
			{ "<leader>dg", function() require("dap").goto_()                         end, desc = "Go to Line (No Execute)" },
			{ "<leader>di", function() require("dap").step_into()                     end, desc = "Step Into" },
			{ "<leader>dj", function() require("dap").down()                          end, desc = "Down" },
			{ "<leader>dk", function() require("dap").up()                            end, desc = "Up" },
			{ "<leader>dl", function() require("dap").run_last()                      end, desc = "Run Last" },
			{ "<leader>do", function() require("dap").step_out()                      end, desc = "Step Out" },
			{ "<leader>dO", function() require("dap").step_over()                     end, desc = "Step Over" },
			{ "<leader>dp", function() require("dap").pause()                         end, desc = "Pause" },
			{ "<leader>dr", function() require("dap").repl.toggle()                   end, desc = "Toggle REPL" },
			{ "<leader>ds", function() require("dap").session()                       end, desc = "Session" },
			{ "<leader>dt", function() require("dap").terminate()                     end, desc = "Terminate" },
			{ "<leader>dw", function() require("dap.ui.widgets").hover()              end, desc = "Widgets" },
		},
		config = function()
			local dap = require("dap")

			-- NOTE: dap for C/C++
			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				executable = {
					command = "codelldb",
					args = { "--port", "${port}" },
					-- detached = false, -- On windows you may have to uncomment this.
				},
			}

			local cc_dap_config = {
				name = "Launch file",
				type = "codelldb",
				request = "launch",
				program = function()
					return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
			}
			dap.configurations.c = { cc_dap_config }
			dap.configurations.cpp = { cc_dap_config }

			-- NOTE: dap for C#
			local netcoredbg = "path/to" .. "/netcoredbg"
			dap.adapters.coreclr = {
				type = "executable",
				command = netcoredbg,
				args = { "--interpreter=vscode" },
			}
			dap.configurations.cs = {
				{
					type = "coreclr",
					name = "launch - netcoredbg",
					request = "launch",
					program = function()
						return vim.fn.input("Path to dll", vim.fn.getcwd() .. "/bin/Debug/", "file")
					end,
				},
			}

			-- NOTE: dap for golang
			dap.adapters.delve = function(callback, config)
				---@diagnostic disable-next-line: undefined-field
				if config.mode == "remote" and config.request == "attach" then
					callback({
						type = "server",
						---@diagnostic disable-next-line: undefined-field
						host = config.host or "127.0.0.1",
						---@diagnostic disable-next-line: undefined-field
						port = config.port or "38697",
					})
				else
					callback({
						type = "server",
						port = "${port}",
						executable = {
							command = "dlv",
							args = { "dap", "-l", "127.0.0.1:${port}", "--log", "--log-output=dap" },
							detached = vim.fn.has("win32") == 0,
						},
					})
				end
			end
			-- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
			dap.configurations.go = {
				{
					type = "delve",
					name = "Debug",
					request = "launch",
					program = "${file}",
				},
				{
					type = "delve",
					name = "Debug test", -- configuration for debugging test files
					request = "launch",
					mode = "test",
					program = "${file}",
				},
				-- works with go.mod packages and sub packages
				{
					type = "delve",
					name = "Debug test (go.mod)",
					request = "launch",
					mode = "test",
					program = "./${relativeFileDirname}",
				},
			}

			-- NOTE: dap for python
			dap.adapters.python = function(cb, config)
				if config.request == "attach" then
					---@diagnostic disable-next-line: undefined-field
					local port = (config.connect or config).port
					---@diagnostic disable-next-line: undefined-field
					local host = (config.connect or config).host or "127.0.0.1"
					cb({
						type = "server",
						port = assert(port, "`connect.port` is required for a python `attach` configuration"),
						host = host,
						options = {
							source_filetype = "python",
						},
					})
				else
					cb({
						type = "executable",
						command = os.getenv("VIRTUAL_ENV") .. "/bin/python",
						args = { "-m", "debugpy.adapter" },
						options = {
							source_filetype = "python",
						},
					})
				end
			end
			dap.configurations.python = {
				{
					-- The first three options are required by nvim-dap
					type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
					request = "launch",
					name = "Launch file",
					-- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options
					program = "${file}", -- This configuration will launch the current file if used.
					pythonPath = function()
						-- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
						-- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
						-- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
						local cwd = vim.fn.getcwd()
						if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
							return cwd .. "/venv/bin/python"
						elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
							return cwd .. "/.venv/bin/python"
						elseif vim.fn.executable(cwd .. "/bin/python") == 1 then
							return cwd .. "/bin/python"
						else
							return "/usr/bin/python"
						end
					end,
				},
			}

			-- WARN: setup dap config by VsCode launch.json file
			local vscode = require("dap.ext.vscode")
			local json = require("plenary.json")
			vscode.json_decode = function(str)
				return vim.json.decode(json.json_strip_comments(str))
			end
		end,
	},
}
