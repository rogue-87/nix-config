local utils = require("myutils")
local lsp = require("myutils.lsp")
---@type vim.keymap.set.Opts
local opts = { noremap = true, silent = true }

-- Clipboard related stuff
-- DELETE
utils.map({ "n", "v" }, "d", '"_d', opts)
-- DELETE LINE
utils.map("n", "dd", '"_dd', opts)
-- DELETE TILL END OF LINE
utils.map("n", "D", '"_D', opts)

-- CHANGE
utils.map({ "n", "v" }, "c", '"_c', opts)
-- CHANGE LINE
utils.map("n", "cc", '"_cc', opts)
-- CHANGE TILL END OF LINE
utils.map("n", "C", '"_C', opts)

-- CUT
utils.map({ "n", "v" }, "x", "d", opts)
-- CUT LINE
utils.map("n", "xx", "dd", opts)
-- CUT TILL END OF LINE
utils.map("n", "X", "D", opts)

-- SELECT
utils.map({ "n", "v" }, "s", '"_s', opts)
-- SELECT LINE
utils.map("n", "S", '"_S', opts)

-- Actual Keymaps
opts.desc = "this file"
utils.map("n", "<leader>ww", function()
	local msg = vim.api.nvim_exec2("w", { output = true })
	Snacks.notifier.notify(msg["output"], "info", { style = "compact", icon = "  ", title = "written" })
end, opts)

opts.desc = "all files"
utils.map("n", "<leader>wa", function()
	---@type {output: string}
	local files = vim.api.nvim_exec2("wa", { output = true })
	-- stylua: ignore
	if files["output"] == "" then return end

	local written_files = ""
	for file in files["output"]:gmatch('"(.-)"') do
		written_files = written_files .. file .. "\n"
	end
	written_files = written_files:sub(1, written_files:len() - 1)

	Snacks.notifier.notify(written_files, "info", { style = "fancy", icon = "  ", title = "written" })
end, opts)

opts.desc = "nohlsearch"
utils.map("n", "<leader>h", "<cmd>nohlsearch<cr>", opts)

opts.desc = "quit/session"
utils.map("n", "<leader>q", "", opts)

opts.desc = "quit & save"
utils.map("n", "<leader>qq", "<cmd>wqa<cr>", opts)

opts.desc = "quit witout saving"
utils.map("n", "<leader>qQ", "<cmd>qa!<cr>", opts)

opts.desc = "Lazy"
utils.map("n", "<leader>ml", "<cmd>Lazy<cr>", opts)

opts.desc = "Open remote git repository"
utils.map("n", "<leader>go", function()
	-- Get the Git remote URL
	local handle = io.popen("git config --get remote.origin.url")
	local remote_url
	if handle then
		remote_url = handle:read("*a")
		handle:close()
	end

	-- Remove any newline character
	remote_url:gsub("%s+", "")

	-- Convert SSH remote URLs to HTTPS URLs
	if remote_url:match("^git@") then
		remote_url = remote_url:gsub(":", "/"):gsub("^git@", "https://")
	elseif remote_url:match("^https://") then
	-- HTTPS URLs are fine as is
	else
		print("Unsupported remote URL format: " .. remote_url)
		return
	end

	-- Open the URL in the default browser (for Linux)
	os.execute("xdg-open " .. remote_url)
end, opts)

utils.map("n", "<A-n>", "<cmd>tabnew<cr>", opts)
utils.map("n", "<A-c>", "<cmd>tabclose<cr>", opts)
utils.map("n", "<A-.>", "<cmd>tabn<cr>", opts)
utils.map("n", "<A-,>", "<cmd>tabp<cr>", opts)
utils.map("n", "<C-,>", "<cmd>-tabmove<cr>", opts)
utils.map("n", "<C-.>", "<cmd>+tabmove<cr>", opts)

-- NOTE: LSP related mappings
lsp.on_attach(function(client, bufnr)
	local ls_opts = { buffer = bufnr }

	if client.server_capabilities.hoverProvider then
		utils.map("n", "K", function()
			vim.lsp.buf.hover()
		end, ls_opts, "get hover info")
	end

	if client.server_capabilities.semanticTokensProvider then
		utils.map("n", "<localleader>us", function()
			utils.toggle("enable_semantic_tokens", { global = true }, nil)
			if vim.g["enable_semantic_tokens"] then
				vim.lsp.semantic_tokens.start(bufnr, client.id)
			else
				vim.lsp.semantic_tokens.stop(bufnr, client.id)
			end
		end, ls_opts, "toggle semantic token highlighting")
	end

	if client.server_capabilities.signatureHelpProvider then
		utils.map("n", "<localleader>k", vim.lsp.buf.signature_help, ls_opts, "get fn signature help")
	end

	if client.server_capabilities.declarationProvider then
		utils.map("n", "<localleader>gD", vim.lsp.buf.declaration, ls_opts, "goto declaration")
	end

	if client.server_capabilities.definitionProvider then
		-- vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
		utils.map("n", "<localleader>gd", function()
			if utils.has("lspsaga.nvim") then
				vim.cmd([[Lspsaga goto_definition]])
			else
				vim.lsp.buf.definition()
			end
		end, ls_opts, "goto definition")

		if utils.has("lspsaga.nvim") then
			utils.map("n", "<localleader>pd", function()
				vim.cmd([[Lspsaga peek_definition]])
			end, ls_opts, "peek definition")
		end
	end

	if client.server_capabilities.typeDefinitionProvider then
		utils.map("n", "<localleader>gt", function()
			if utils.has("lspsaga.nvim") then
				vim.cmd([[Lspsaga goto_type_definition]])
			else
				vim.lsp.buf.type_definition()
			end
		end, ls_opts, "goto type definition")

		if utils.has("lspsaga.nvim") then
			utils.map("n", "<localleader>pt", function()
				vim.cmd([[Lspsaga peek_type_definition]])
			end, ls_opts, "peek type definition")
		end
	end

	if client.server_capabilities.implementationProvider then
		utils.map("n", "<localleader>gi", function()
			if utils.has("lspsaga.nvim") then
				vim.cmd([[Lspsaga finder imp+def]])
			elseif utils.has("snacks.nvim") then
				---@diagnostic disable-next-line: undefined-global
				Snacks.picker.lsp_implementations()
			else
				vim.lsp.buf.implementation()
			end
		end, ls_opts, "goto type implementation")
	end

	if client.server_capabilities.referencesProvider then
		utils.map("n", "<localleader>gr", function()
			if utils.has("lspsaga.nvim") then
				vim.cmd([[Lspsaga finder ref]])
			elseif utils.has("snacks.nvim") then
				Snacks.picker.lsp_references()
			else
				vim.lsp.buf.references()
			end
		end, ls_opts, "goto type references")
	end

	if client.server_capabilities.documentHighlightProvider then
		vim.api.nvim_set_hl(0, "LspReferenceRead", {
			link = "DiffText",
		})
		vim.api.nvim_set_hl(0, "LspReferenceText", {
			link = "IncSearch",
		})
		vim.api.nvim_set_hl(0, "LspRefDiffTexterenceWrite", {
			link = "WildMenu",
		})
		local doc_highlight = utils.augroup("lsp_document_highlight", { clear = true })
		local enable_highlight = function()
			utils.autocmd({ "CursorHold", "CursorHoldI" }, {
				group = doc_highlight,
				buffer = bufnr,
				callback = vim.lsp.buf.document_highlight,
			})
			utils.autocmd("CursorMoved", {
				group = doc_highlight,
				buffer = bufnr,
				callback = vim.lsp.buf.clear_references,
			})
		end
		local disable_highlight = function()
			vim.lsp.buf.clear_references()
			vim.api.nvim_clear_autocmds({
				buffer = bufnr,
				group = doc_highlight,
			})
		end
		utils.map("n", "<localleader>uh", function()
			utils.toggle("highlight", {}, { enable_highlight, disable_highlight })
			vim.b[vim.fn.bufnr()]["highlight"]()
		end, ls_opts, "toggle document highlight")
	end

	if client.server_capabilities.documentSymbolProvider then
		utils.map("n", "<localleader>ds", vim.lsp.buf.document_symbol, ls_opts, "document symbols")
	end

	if client.server_capabilities.codeActionProvider then
		utils.map({ "n", "v" }, "<localleader>ca", function()
			if utils.has("lspsaga.nvim") then
				vim.cmd([[Lspsaga code_action]])
			else
				vim.lsp.buf.code_action()
			end
		end, ls_opts, "code action")
	end

	if client.server_capabilities.documentFormattingProvider then
		utils.map("n", "<localleader>uf", function()
			utils.toggle("autoformat", { global = false })
			utils.autocmd("BufWritePre", {
				group = utils.augroup("LspFormat", { clear = true }),
				callback = function()
					if vim.g["autoformat"] then
						vim.lsp.buf.format({ async = true })
					end
				end,
			})
		end, ls_opts, "toggle autoformat")

		if not utils.has("conform.nvim") then
			utils.map("n", "<localleader>f", function()
				vim.lsp.buf.format({ async = true })
			end, ls_opts, "range format buffer")
		end
	end

	if client.server_capabilities.documentRangeFormattingProvider then
		utils.map("v", "<localleader>f", function()
			vim.lsp.buf.format({ async = true })
		end, ls_opts, "range format buffer")
	end

	if client.server_capabilities.renameProvider then
		utils.map("n", "<localleader>rn", function()
			if utils.has("lspsaga.nvim") then
				vim.cmd([[Lspsaga rename]])
			else
				vim.lsp.buf.rename()
			end
		end, ls_opts, "rename symbol")
	end

	if client.server_capabilities.callHierarchyProvider then
		utils.map("n", "<localleader>ci", function()
			if utils.has("lspsaga.nvim") then
				vim.cmd([[Lspsaga incoming_calls]])
			else
				vim.lsp.buf.incoming_calls()
			end
		end, ls_opts, "incoming calls")

		utils.map("n", "<localleader>co", function()
			if utils.has("lspsaga.nvim") then
				vim.cmd([[Lspsaga outgoing_calls]])
			else
				vim.lsp.buf.outgoing_calls()
			end
		end, ls_opts, "outgoing calls")
	end

	if client.server_capabilities.workspaceSymbolProvider then
		utils.map("n", "<localleader>ws", vim.lsp.buf.workspace_symbol, ls_opts, "list workspace symbols")
	end

	utils.map("n", "[d", function()
		if utils.has("lspsaga.nvim") then
			vim.cmd([[Lspsaga diagnostic_jump_prev]])
		else
			vim.diagnostic.jump({ count = -1, float = true })
		end
	end, ls_opts, "goto previous diagnostics")
	utils.map("n", "]d", function()
		if utils.has("lspsaga.nvim") then
			vim.cmd([[Lspsaga diagnostic_jump_next]])
		else
			vim.diagnostic.jump({ count = 1, float = true })
		end
	end, ls_opts, "goto next diagnostics")

	if utils.has("lspsaga.nvim") then
		utils.map("n", "<localleader>wd", function()
			vim.cmd([[Lspsaga show_workspace_diagnostics]]) --can use ++normal to show in loclist
		end, ls_opts, "workspace diagnostics")
		utils.map("n", "<localleader>bd", function()
			vim.cmd([[Lspsaga show_buf_diagnostics]])
		end, ls_opts, "buffer diagnostics")
		utils.map("n", "<localleader>ld", function()
			vim.cmd([[Lspsaga show_line_diagnostics]])
		end, ls_opts, "line diagnostics")
		utils.map("n", "<localleader>wo", function()
			vim.cmd([[Lspsaga outline]])
		end, ls_opts, "workspace outline")
	else
		utils.map("n", "<localleader>ld", vim.diagnostic.open_float, ls_opts, "line diagnostics")
	end
	utils.map("n", "<localleader>sl", vim.diagnostic.setloclist, ls_opts, "set loclist")

	utils.map("n", "<localleader>wf", function()
		vim.print(vim.lsp.buf.list_workspace_folders())
	end, ls_opts, "list workspace folders")
	utils.map("n", "<localleader>rd", function()
		vim.notify("Language server " .. (vim.lsp.status() and "is ready" or "is not ready"), vim.log.levels.INFO)
	end, ls_opts, "check if lsp is ready")
end)
