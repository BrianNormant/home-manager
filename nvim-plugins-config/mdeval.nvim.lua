require 'mdeval'.setup {
	require_confirmation = false,
	exec_timeout = 5, -- is blocking so limit it to short interval. It is not supposed to run for long anyway
	eval_options = {
		elixir = {
			command       = { "elixir", "-r" },
			language_code = "elixir",
			exec_type     = "interpreted",
			extension     = "ex",
		},

		java = {
			command       = { "jshell" },
			language_code = "java",
			exec_type     = "interpreted",
			extension     = "java",
		},

		c = {
			command = { "clang" },
			language_code= "c",
			exec_type = "compiled",
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
		{ "sc", mode = "n", "<cmd>MdEval<cr>", description = "Eval code block under cursor" }
	},
}
_G.LEGEND_append(legend)
