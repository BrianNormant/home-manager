require 'mdeval'.setup {
	require_confirmation = false,
	eval_options = {
		elixir = {
			command       = "iex",
			language_code = { "ex" },
			exec_type     = "interpreted",
			extension     = "ex",
		},

		java = {
			command       = "jshell",
			language_code = { "java" },
			exec_type     = "interpreted",
			extension     = "java",
		},

		c = {
			command = "cling",
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
			]]
		}
	},
}

local legend = {
	keymaps = {
		{ "sc", mode = "n", "<cmd>MdEval<cr>", description = "Eval code block under cursor"}
	},
}
_G.LEGEND_append(legend)

