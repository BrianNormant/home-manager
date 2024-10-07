require 'mdeval'.setup {
	-- TODO: Clone this repo and make it work with jshell.
	require_confirmation = false,
	exec_timeout = 500, -- is blocking so limit it to short interval. It is not supposed to run for long anyway
	eval_options = {
		elixir = {
			command       = { "iex" },
			language_code = "ex",
			exec_type     = "interpreted",
			extension     = "ex",
			ignore_first_line = 2,
			filter = function(line)
				local r = vim.regex([[\v...\(\d+\)\>]])
				return not r:match_str(line)
			end,
			eof = "System.halt()",
		},

		java = {
			command       = { "jshell", "--feedback", "concise"},
			language_code = "java",
			exec_type     = "interpreted",
			extension     = "java",
			eof = "/ex",
		},

		python = {
			command = { "ipython" },
			language_code = "python",
			exec_type = "interpreted",
			extension = "py",
			eof = "exit()",
			filter = function(line)
				local r = vim.regex([[\vIn \[\d+\]:]])
				return not r:match_str(line)
			end,
			ignore_first_line = 3,
		},

		c = {
			command = { "cling" },
			language_code= "c",
			exec_type = "interpreted",
			extension = "c",
			default_header = [[
			#include <stdio.h>
			#include <stdint.h>
			#include <stdlib.h>
			#include <string.h>
			#include <stdbool.h>
			#include <time.h>
			]],
			ignore_first_line = 5,
			eof = ".q",
		},

		lua = {
			command = { "lua" }, -- TODO replace this with a function to run the neovim lua
			language_code = "lua",
			exec_type = "interpreted",
			extension = "lua",
			ignore_first_line = 2,
			eof = "os.exit()",
		},
		zsh = {
			command = { "zsh" },
			language_code = "zsh",
			exec_type = "interpreted",
			eof = "exit",
		},
		bash = {
			command = { "bash" },
			language_code = "bash",
			exec_type = "interpreted",
			eof = "exit",
		},
		sh = {
			command = { "sh" },
			language_code = "sh",
			exec_type = "interpreted",
			eof = "exit",
		},
		nu = {
			command = { "nu" },
			language_code = "nu",
			exec_type = "interpreted",
			eof = "exit",
		},
	},
}

local legend = {
	keymaps = {
		{ "sc", mode = "n", function()
			vim.cmd "MdEvalClean"
			vim.cmd "MdEval"
		end, description = "Eval code block under cursor" },
		{ "sC", mode = "n", "<cmd>MdEvalClean<cr>", description = "Eval clean result" },
	},
}
_G.LEGEND_append(legend)
