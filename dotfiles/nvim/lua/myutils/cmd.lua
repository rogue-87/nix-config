local M = {}

-- checks if a commandline program exists
--{ "git", "rg", { "fd", "fdfind" }, "lazygit" }
function M.check(cmds)
	local result = {}
	for _, cmd in ipairs(cmds) do
		local name = type(cmd) == "string" and cmd or vim.inspect(cmd)
		local commands = type(cmd) == "string" and { cmd } or cmd
		---@cast commands string[]
		local found = false
		for _, c in ipairs(commands) do
			if vim.fn.executable(c) == 1 then
				name = c
				found = true
			end
			result[name] = { found }
		end
	end
	return result
end

return M
