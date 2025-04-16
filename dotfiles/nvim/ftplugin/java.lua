vim.bo.tabstop = 4
vim.bo.shiftwidth = 4

local utils = require("myutils")
local java_debug = "path/to" .. "/extension/server/com.microsoft.java.debug.plugin-*.jar"

local java_test = "path/to" .. "/extension/server/*.jar"

local config = {
	cmd = { vim.fn.exepath("jdtls") },
	root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw" }, { upward = true })[1]),
	settings = {
		java = {
			configuration = {
				runtimes = {
					{
						name = "Java-21",
						path = "/usr/lib/jvm/java-21-openjdk/",
					},
					{
						name = "Java-24",
						path = "/usr/lib/jvm/java-24-openjdk/",
					},
				},
			},
		},
	},
}
local bundles = {}

if utils.has("java-debug") then
	table.insert(bundles, vim.fn.glob(java_debug, true))
end

if utils.has("vscode-java-test") then
	vim.list_extend(bundles, vim.split(vim.fn.glob(java_test, true), "\n"))
end

config["init_options"] = { bundles = bundles }

if utils.has("nvim-jdtls") then
	require("jdtls").start_or_attach(config)
end
