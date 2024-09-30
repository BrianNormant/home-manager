local jdtls = require 'jdtls'
-- TODO use this fork of jdtls to have pretty prompt with multiple actions
-- https://github.com/mfussenegger/nvim-jdtls/pull/572


local config = {
	cmd = { vim.fn.exepath 'jdtls' },
	settings = {
		java = {
			configuration = {
				runtimes = {
					{name = "JavaSE-17", path = "~/.java/home/jdk-17",},
					{name = "JavaSE-21", path = "~/.java/home/jdk-21",},
					-- {name = "JavaSE-8",  path = "~/.java/home/jdk-8" ,},
				}
			}
		},
	},

	root_dir = jdtls.setup.find_root({'.git', 'mvnw', 'gradlew', "pom.xml"}),

	init_options = {
		bundles = {
			vim.fn.glob(vscodepath .. "/share/vscode/extensions/vscjava.vscode-java-debug/server/com.microsoft.java.debug.plugin-*.jar", 1),
		}
	},
}

vim.api.nvim_create_autocmd(
'BufEnter',
{ 	pattern = {'*.java'},
callback = function()
	jdtls.start_or_attach(config)
	vim.defer_fn(function () require('jdtls.dap').setup_dap_main_class_configs() end, 3000) -- Wait for LSP to start
end,
	})
