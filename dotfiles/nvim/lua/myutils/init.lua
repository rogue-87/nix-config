local M = {}

function _G.dump(...)
	vim.print(...)
end

function M.reload_all()
	for name, _ in pairs(package.loaded) do
		if name:match("^config") or name:match("^plugins") then
			package.loaded[name] = nil
		end
	end
	-- Reload after/ directory
	local glob = vim.fn.stdpath("config") .. "/ftplugin/**/*.lua"
	local ftplugin_lua_filepaths = vim.fn.glob(glob, true, true)

	for _, filepath in ipairs(ftplugin_lua_filepaths) do
		dofile(filepath)
	end

	dofile(vim.env.MYVIMRC)
end

function M.reload_one(module)
	for name, _ in pairs(package.loaded) do
		if name:match("^" .. module) then
			package.loaded[name] = nil
			require(name)
			return
		end
	end
end

---@param editor_variable? {global: boolean}
---@param values? {[1]:any, [2]:any}
---@param option string
function M.toggle(option, editor_variable, values)
	if values then
		if not editor_variable then
			if vim.deep_equal(vim.opt_local[option]:get(), values[1]) then
				vim.opt_local[option] = values[2]
			else
				vim.opt_local[option] = values[1]
			end
			vim.notify(
				"set editor option " .. option .. " to " .. tostring(vim.opt_local[option]:get()),
				vim.log.levels.INFO,
				{ title = "toggle editor option" }
			)
		else
			if not editor_variable.global then
				local bufnr = vim.api.nvim_get_current_buf()
				if vim.b[bufnr][option] == values[1] then
					vim.b[bufnr][option] = values[2]
				else
					--if option is unset or nil
					vim.b[bufnr][option] = values[1]
				end
				--:h debug.getinfo() or lua_getinfo() to get information about a function
				vim.notify("set option " .. option .. " to " .. tostring(vim.b[bufnr][option]), vim.log.levels.INFO, {
					title = "toggle local option",
				})
			else
				if vim.g[option] == values[1] then
					vim.g[option] = values[2]
				else
					--if option is unset or nil
					vim.g[option] = values[1]
				end
				vim.notify("set global option " .. option .. " to " .. tostring(vim.g[option]), vim.log.levels.INFO, {
					title = "toggle global option",
				})
			end
		end
	else
		if not editor_variable then
			vim.opt_local[option] = not vim.opt_local[option]:get()
			vim.notify(
				"set editor option " .. option .. " to " .. tostring(vim.opt_local[option]:get()),
				vim.log.levels.INFO,
				{
					title = "toggle editor option",
				}
			)
		else
			if not editor_variable.global then
				local bufnr = vim.api.nvim_get_current_buf()
				vim.b[bufnr][option] = not vim.b[bufnr][option] and true or false
				vim.notify("set option " .. option .. " to " .. tostring(vim.b[bufnr][option]), vim.log.levels.INFO, {
					title = "toggle local option",
				})
			else
				vim.g[option] = not vim.g[option]
				vim.notify("set global option " .. option .. " to " .. tostring(vim.g[option]), vim.log.levels.INFO, {
					title = "toggle global option",
				})
			end
		end
	end
end

---@param fn fun()
function M.on_very_lazy(fn)
	vim.api.nvim_create_autocmd("User", {
		group = vim.api.nvim_create_augroup("Lazy", { clear = true }),
		pattern = "VeryLazy",
		callback = function()
			fn()
		end,
	})
end

--modules like "autocmds" | "options" | "keymaps"
---@param modules string[]
function M.lazy_load(modules)
	-- when no file is opened at startup
	if vim.fn.argc(-1) == 0 then
		-- autocmds and keymaps can wait to load
		-- always load lazyvim, then user file
		M.on_very_lazy(function()
			for i = 1, #modules do
				require(modules[i])
			end
		end)
	else
		-- load them now so they affect the opened buffers
		for i = 1, #modules do
			require(modules[i])
		end
	end
end

---@param plugin string
function M.has(plugin)
	if package.loaded["lazy"] then
		return require("lazy.core.config").plugins[plugin] ~= nil
	else
		local plugin_name = vim.split(plugin, ".", { plain = true, trimempty = true })
		return package.loaded[plugin_name[1]] ~= nil
	end
end

---@param description? string
---@param opt table
local function mdesc(opt, description)
	return vim.tbl_extend("force", opt, { desc = description })
end

--- wrapper function around `vim.keymap.set`
---@param mode string|table
---@param lhs string
---@param rhs string|function
---@param opts? table
---@param desc? string
function M.map(mode, lhs, rhs, opts, desc)
	opts = opts and opts or {}
	opts = mdesc(opts, desc)
	vim.keymap.set(mode, lhs, rhs, opts)
end

--- shortcut to vim.api.nvim_create_autocmd
M.autocmd = vim.api.nvim_create_autocmd

--- shortcut to vim.api.nvim_create_augroup
M.augroup = vim.api.nvim_create_augroup

return M
