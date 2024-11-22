-- load additional plugins before
require('lze').load {
	'neotest-java',
	ft = {'java'},
	after = function ()
		local test = require('neotest')
		test.setup {
			opts = {
				adapters = {
					['neotest-java'] = {}
				}
			}
		}
	end
}

require('lze').load {
	'neotest',
	keys = {},
	cmd = {
		"Test",
		"TestFile",
		"TestDebug",
		"TestStop",
		"TestAttach",
	},
	after = function()
		local test = require('neotest')
		test.setup { }
		-- vim.cmd "NeotestJava setup"
		vim.api.nvim_create_user_command('Test', test.run.run, {})
		vim.api.nvim_create_user_command('TestFile', function ()
			test.run.run(vim.fn.expand("%"))
		end, {})
		vim.api.nvim_create_user_command('TestDebug', function ()
			test.run.run({strategy = "dap"})
		end, {})
		vim.api.nvim_create_user_command('TestStop', function ()
			test.run.stop()
		end, {})
		vim.api.nvim_create_user_command('TestAttach', function ()
			test.run.attach()
		end, {})
	end
}
