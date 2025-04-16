local pipepath = vim.fn.stdpath("cache") .. "/server.pipe"
if not vim.uv.fs_stat(pipepath) then
	vim.fn.serverstart(pipepath)
end

---@type vim.lsp.Config
vim.lsp.config.gdscript = {
	cmd = vim.lsp.rpc.connect("127.0.0.1", 6005),
	filetypes = { "gd", "gdscript", "gdscript3" },
	root_markers = { "project.godot", ".git" },
}

vim.lsp.enable("gdscript")

return {}
