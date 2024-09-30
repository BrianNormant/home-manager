local dap, dapui = require("dap"), require("dapui")

dap.listeners.after.event_initialized["dapui_config"] = function()
dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
dapui.close()
end

vim.fn.sign_define('DapBreakpoint', {text='🛑', texthl='', linehl='', numhl=''})
dap.adapters.gdb = {
	type = "executable",
	command = "gdb",
	args = { "-i", "dap" },
}
dap.configurations.c = {
	{
			name = "Launch",
			type = "gdb",
			request = "launch",
			program = function()
			return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
			end,
			cwd = "${workspaceFolder}",
	}
	}
dap.configurations.cpp = dap.configurations.c
dap.configurations.rust = dap.configurations.c

dapui.setup {
	layouts = {
		{
				elements = {
					{
							id = "breakpoints",
							size = 0.25,
					},
					{
							id = "scopes",
							size = 0.25,
					},
					{
							id = "watches",
							size = 0.5,
					},
				},
				position = "left",
				size = 40,
		},
		{
				elements = {
					{
							id = "repl",
							size = 0.5
					},
					{
							id = "stacks",
							size = 0.5
					}
					},
				position = "right",
				size = 60,
		}
	}
}

--- Keymaps
local legend = {
	keymaps = {
		{"<F9>",   function()  require'dap'.toggle_breakpoint()  end,  description="DAP  Toggle breakpoint"},
		{"<F10>",  function()  require'dap'.continue()           end,  description="DAP  Start/Resume"},
		{"<F58>",  function()  require'dap'.terminate()          end,  description="DAP  Stop"},
		{"<F11>",  function()  require'dap'.step_over()          end,  description="DAP  Step"},
		{"<F12>",  function()  require'dap'.step_into()          end,  description="DAP  Step into"},
		{"<F60>",  function()  require'dap'.step_out()           end,  description="DAP  Step out"},
	},
}
_G.LEGEND_append(legend)

