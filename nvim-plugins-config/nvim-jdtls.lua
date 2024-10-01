local jdtls = require 'jdtls'
-- TODO use this fork of jdtls to have pretty prompt with multiple actions
-- https://github.com/mfussenegger/nvim-jdtls/pull/572


local config = {
	cmd = { vim.fn.exepath 'jdtls' },
	settings = {
		java = {
			configuration = {
				runtimes = {
					-- {name = "JavaSE-17", path = "~/.gradle/jdks/eclipse_adoptium-17-amd64-linux/jdk-17.0.10+7" },
					-- {name = "JavaSE-21", path = "~/.gradle/jdks/eclipse_adoptium-21-amd64-linux/jdk-21.0.2+13",},
					{name = "JavaSE-21", path = "~/.java/home/jdk-21",},
					{name = "JavaSE-17", path = "~/.java/home/jdk-17",},
					-- {name = "JavaSE-8",  path = "~/.java/home/jdk-8" ,},
				}
			},
			references = {
				includeDecompiledSources = true,
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

-- To attach a dap to junit
-- https://github.com/mfussenegger/nvim-jdtls?tab=readme-ov-file#vscode-java-test-installation

vim.api.nvim_create_autocmd(
	'BufEnter',
	{
		pattern = {'*.java'},
		callback = function()
			jdtls.start_or_attach(config)
			-- vim.defer_fn(function () require('jdtls.dap').setup_dap_main_class_configs() end, 3000) -- Wait for LSP to start
		end,
	}
)

local legend = {
	keymaps = {
		{'<A-o>', require'jdtls'.organize_imports(),       mode = 'n', description="jdtls organize imports"},
		{'crc',   require('jdtls').extract_constant(),     mode = 'n', description="jdtls extract constant"},
		{'crc',   require('jdtls').extract_constant(true), mode = 'v', description="jdtls extract constant"},
		{'crm',   require('jdtls').extract_method(true),   mode = 'v', description="jdtls extract method"},
		{'crv',   require('jdtls').extract_variable(),     mode = 'n', description="jdtls extract variable"},
		{'crv',   require('jdtls').extract_variable(true), mode = 'v', description="jdtls extract variable"},
	},
}
_G.LEGEND_append(legend)
