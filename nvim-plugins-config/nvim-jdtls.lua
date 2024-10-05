-- vim.opt.rtp:append(vim.fn.stdpath('config') .. '/lua/nvim-jdtls')

local jdtls = require 'jdtls'
local root_dir = jdtls.setup.find_root({'.git', 'mvnw', 'gradlew', "pom.xml"})

local config = {
	cmd = {
		'jdtls',
		"-data", root_dir,
	},
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
	root_dir = root_dir,
	init_options = {
		bundles = {
			vim.fn.glob(vscodepath .. "/share/vscode/extensions/vscjava.vscode-java-debug/server/com.microsoft.java.debug.plugin-*.jar", 1),
		}
	},
}

-- To attach a dap to junit
-- https://github.com/mfussenegger/nvim-jdtls?tab=readme-ov-file#vscode-java-test-installation

vim.api.nvim_create_autocmd(
	{ 'BufEnter', 'FileType' },
	{
		pattern = {'*'},
		callback = function()
			if vim.bo.filetype == "java" then
				jdtls.start_or_attach(config)
				-- TODO install dap
			-- vim.defer_fn(function () require('jdtls.dap').setup_dap_main_class_configs() end, 3000) -- Wait for LSP to start
			end
		end,
	}
)

local legend = {
	keymaps = {
		{'<A-o>', function() require('jdtls').organize_imports() end, mode = 'n', description="jdtls organize imports"},
		{'cjc',   function() require('jdtls').extract_constant() end, mode = 'n', description="jdtls extract constant"},
		{'cjm',   function() require('jdtls').extract_method()   end, mode = 'n', description="jdtls extract method"},
		{'cjv',   function() require('jdtls').extract_variable() end, mode = 'n', description="jdtls extract variable"},
		{'cjv',   function() require('jdtls').extract_variable() end, mode = 'n', description="jdtls extract variable"},
	},
}
_G.LEGEND_append(legend)
