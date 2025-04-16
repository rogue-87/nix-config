---@param bufnr integer
---@param client vim.lsp.Client
local function buf_cache(bufnr, client)
	local params = {
		command = "deno.cache",
		arguments = { {}, vim.uri_from_bufnr(bufnr) },
	}
	client:request("workspace/executeCommand", params, function(err, _result, ctx)
		if err then
			local uri = ctx.params.arguments[2]
			vim.notify("cache command failed for " .. vim.uri_to_fname(uri), vim.log.levels.ERROR)
		end
	end, bufnr)
end

---@param uri string
---@param res? any
---@param client vim.lsp.Client
local function virtual_text_document_handler(uri, res, client)
	if not res then
		return nil
	end

	local lines = vim.split(res.result, "\n")
	local bufnr = vim.uri_to_bufnr(uri)

	local current_buf = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	if #current_buf ~= 0 then
		return nil
	end

	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
	vim.api.nvim_set_option_value("readonly", true, { buf = bufnr })
	vim.api.nvim_set_option_value("modified", false, { buf = bufnr })
	vim.api.nvim_set_option_value("modifiable", false, { buf = bufnr })
	vim.lsp.buf_attach_client(bufnr, client.id)
end

---@param uri string
---@param client vim.lsp.Client
local function virtual_text_document(uri, client)
	local params = {
		textDocument = {
			uri = uri,
		},
	}
	local result = client:request_sync("deno/virtualTextDocument", params)
	virtual_text_document_handler(uri, result, client)
end

local function denols_handler(err, result, ctx, config)
	if not result or vim.tbl_isempty(result) then
		return nil
	end

	local client = vim.lsp.get_client_by_id(ctx.client_id)
	for _, res in pairs(result) do
		local uri = res.uri or res.targetUri
		if uri:match("^deno:") then
			virtual_text_document(uri, client)
			res["uri"] = uri
			res["targetUri"] = uri
		end
	end

	vim.lsp.handlers[ctx.method](err, result, ctx, config)
end

---@type table<string, vim.lsp.Config>
local configs = {
	html = {
		cmd = { "vscode-html-language-server", "--stdio" },
		filetypes = { "html", "templ" },
		root_markers = { "package.json", ".git" },
		single_file_support = true,
		settings = {},
		init_options = {
			provideFormatter = true,
			embeddedLanguages = { css = true, javascript = true },
			configurationSection = { "html", "css", "javascript" },
		},
	},
	css = {
		cmd = { "vscode-css-language-server", "--stdio" },
		filetypes = { "css", "scss", "less" },
		init_options = { provideFormatter = true }, -- needed to enable formatting capabilities
		root_markers = { "package.json", ".git" },
		single_file_support = true,
		settings = {
			css = { validate = true },
			scss = { validate = true },
			less = { validate = true },
		},
	},
	css_vars = {
		cmd = { "css-variables-language-server", "--stdio" },
		filetypes = { "css", "scss", "less" },
		root_markers = { "package.json", ".git" },
		settings = {
			cssVariables = {
				lookupFiles = {
					"**/*.less",
					"**/*.scss",
					"**/*.sass",
					"**/*.css",

					"src/lib/style/abstracts/colorscheme.css",
					"src/lib/style/abstracts/variables.css",
				},
				blacklistFolders = {
					"**/.cache",
					"**/.DS_Store",
					"**/.git",
					"**/.hg",
					"**/.next",
					"**/.svn",
					"**/bower_components",
					"**/CVS",
					"**/dist",
					"**/node_modules",
					"**/tests",
					"**/tmp",
				},
			},
		},
	},

	svelte = {
		cmd = { "svelteserver", "--stdio" },
		filetypes = { "svelte" },
		root_markers = { "package.json", ".git" },
	},

	tailwindcss = {
		cmd = { "tailwindcss-language-server", "--stdio" },
		filetypes = {
			-- html
			"aspnetcorerazor",
			"astro",
			"astro-markdown",
			"blade",
			"clojure",
			"django-html",
			"htmldjango",
			"edge",
			"eelixir",
			"elixir",
			"ejs",
			"erb",
			"eruby",
			"gohtml",
			"gohtmltmpl",
			"haml",
			"handlebars",
			"hbs",
			"html",
			"htmlangular",
			"html-eex",
			"heex",
			"jade",
			"leaf",
			"liquid",
			"markdown",
			"mdx",
			"mustache",
			"njk",
			"nunjucks",
			"php",
			"razor",
			"slim",
			"twig",
			-- css
			"css",
			"less",
			"postcss",
			"sass",
			"scss",
			"stylus",
			"sugarss",
			-- js
			"javascript",
			"javascriptreact",
			"reason",
			"rescript",
			"typescript",
			"typescriptreact",
			-- mixed
			"vue",
			"svelte",
			"templ",
		},
		settings = {
			tailwindCSS = {
				validate = true,
				lint = {
					cssConflict = "warning",
					invalidApply = "error",
					invalidScreen = "error",
					invalidVariant = "error",
					invalidConfigPath = "error",
					invalidTailwindDirective = "error",
					recommendedVariantOrder = "warning",
				},
				classAttributes = {
					"class",
					"className",
					"class:list",
					"classList",
					"ngClass",
				},
				includeLanguages = {
					eelixir = "html-eex",
					eruby = "erb",
					templ = "html",
					htmlangular = "html",
				},
			},
		},
		on_new_config = function(new_config)
			if not new_config.settings then
				new_config.settings = {}
			end
			if not new_config.settings.editor then
				new_config.settings.editor = {}
			end
			if not new_config.settings.editor.tabSize then
				-- set tab size for hover
				new_config.settings.editor.tabSize = vim.lsp.util.get_effective_tabstop()
			end
		end,
		-- FIX: only works with legacy tailwind (prior to version 4.0)
		root_markers = {
			"tailwind.config.js",
			"tailwind.config.cjs",
			"tailwind.config.mjs",
			"tailwind.config.ts",
			"postcss.config.js",
			"postcss.config.cjs",
			"postcss.config.mjs",
			"postcss.config.ts",
		},
	},

	tsserver = {
		init_options = { hostInfo = "neovim" },
		cmd = { "typescript-language-server", "--stdio" },
		filetypes = {
			"javascript",
			"javascriptreact",
			"javascript.jsx",
			"typescript",
			"typescriptreact",
			"typescript.tsx",
		},
		root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
		single_file_support = true,
	},

	denols = {
		cmd = { "deno", "lsp" },
		cmd_env = { NO_COLOR = true },
		filetypes = {
			"javascript",
			"javascriptreact",
			"javascript.jsx",
			"typescript",
			"typescriptreact",
			"typescript.tsx",
		},
		root_markers = { "deno.json", "deno.jsonc", ".git" },
		settings = {
			deno = {
				enable = true,
				suggest = {
					imports = {
						hosts = {
							["https://deno.land"] = true,
						},
					},
				},
			},
		},
		handlers = {
			["textDocument/definition"] = denols_handler,
			["textDocument/typeDefinition"] = denols_handler,
			["textDocument/references"] = denols_handler,
		},
		commands = {
			-- description = "Cache a module and all of its dependencies."
			DenolsCache = function(command, ctx)
				local clients = vim.lsp.get_clients({ bufnr = 0, name = "denols" })

				if #clients > 0 then
					buf_cache(0, clients[#clients])
				end
			end,
		},
	},
}

vim.g.markdown_fenced_languages = { "ts=typescript" }

-- stylua: ignore
for k, v in pairs(configs) do vim.lsp.config[k] = v end

vim.lsp.enable({ "html", "css", "css_vars" })

-- stylua: ignore
if vim.fn.filereadable("package.json") == 1 then vim.lsp.enable("tsserver") end

-- stylua: ignore
if vim.fn.filereadable("deno.json") == 1 then vim.lsp.enable("denols") end

if vim.fn.filereadable("package.json") == 1 or vim.fn.filereadable("deno.json") == 1 then
	vim.lsp.enable({ "svelte", "tailwindcss" })
end

return {
	-- formatter
	{
		"stevearc/conform.nvim",
		optional = true,
		opts = function()
			local conform = require("conform")
			if vim.fn.filereadable("package.json") == 1 then
				conform.setup({
					formatters_by_ft = {
						javascript = { "prettierd" },
						javascriptreact = { "prettierd" },
						typescript = { "prettierd" },
						typescriptreact = { "prettierd" },

						html = { "prettierd" },
						-- markdown = { "prettierd" },
						css = { "prettierd" },
						scss = { "prettierd" },

						json = { "prettierd" },
						yaml = { "prettierd" },
					},
				})
			end

			if vim.fn.filereadable("deno.json") == 1 then
				conform.setup({
					formatters_by_ft = {
						javascript = { "deno_fmt" },
						javascriptreact = { "deno_fmt" },
						typescript = { "deno_fmt" },
						typescriptreact = { "deno_fmt" },

						html = { "deno_fmt" },
						markdown = { "deno_fmt" },
						css = { "deno_fmt" },
						scss = { "deno_fmt" },

						json = { "deno_fmt" },
						yaml = { "deno_fmt" },
					},
				})
			end
		end,
	},
	-- linter
	{
		"mfussenegger/nvim-lint",
		optional = true,
		opts = function()
			if vim.fn.filereadable("package.json") then
				local node = {
					javascript = { "eslint" },
					javascriptreact = { "eslint" },
					typescript = { "eslint" },
					typescriptreact = { "eslint" },
				}

				-- stylua: ignore
				for k, _ in pairs(node) do table.insert(require("lint").linters_by_ft, node[k]) end
			end

			if vim.fn.filereadable("deno.json") then
				local deno = {
					javascript = { "deno" },
					javascriptreact = { "deno" },
					typescript = { "deno" },
					typescriptreact = { "deno" },
					json = { "deno" },
				}

				-- stylua: ignore
				for k, _ in pairs(deno) do table.insert(require("lint").linters_by_ft, deno[k]) end
			end
		end,
	},
	-- debugger
	--[[ {
		"mfussenegger/nvim-dap",
		optional = true,
		opts = function()
			local dap = require("dap")

			-- debug adapter for nodejs & deno
			dap.adapters["pwa-node"] = {
				type = "server",
				host = "localhost",
				port = "${port}",
				executable = {
					command = "node",
					args = {
						"path/to" .. "/js-debug/src/dapDebugServer.js",
						"${port}",
					},
				},
			}

			dap.configurations.javascript = {
				{
					type = "pwa-node",
					request = "launch",
					name = "Debug with js-debug",
					program = "${file}",
					cwd = "${workspaceFolder}",
				},
			}

			dap.configurations.typescript = {
				{
					type = "pwa-node",
					request = "launch",
					name = "Debug with deno",
					runtimeExecutable = "deno",
					runtimeArgs = {
						"run",
						"--inspect-wait",
						"--allow-all",
					},
					program = "${file}",
					cwd = "${workspaceFolder}",
					attachSimplePort = 9229,
				},
			}
		end,
	}, ]]
}
