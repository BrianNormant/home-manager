require('lze').load {
	'which-key.nvim',
	event = "DeferredUIEnter",
	after = function ()
		require('which-key').setup {
			preset = "helix",
			delay = 500,
			plugins = {
				marks = false,
				registers = false,
				spelling = { enabled = false, },
			},
			triggers = {
				{ "<auto>", mode = "nxso" },
				{ "s", mode = "n" },
			}
		}

		require("which-key").add {
			{"j",            icon = "↓", desc = "Down" },
			{"$",            icon = "󱖲", desc = "End of line"},
			{"G",            icon = "󱖲", desc = "Last line" },
			{"h",            icon = "←", desc = "Left" },
			{"%",            icon = "󱖲", desc = "Matching (){}[]"},
			{"}",            icon = "󱖲", desc = "Next empty line"},
			{"e",            icon = "󱖲", desc = "Next end of word" },
			{"E",            icon = "󱖲", desc = "Next end of WORD" },
			{"w",            icon = "󱖲", desc = "Next word" },
			{"W",            icon = "󱖲", desc = "Next WORD" },
			{"<RightMouse>", icon = "󰍜", desc = "Open menu"},
			{"{",            icon = "󱖲", desc = "Prev empty line"},
			{"b",            icon = "󱖲", desc = "Prev word" },
			{"B",            icon = "󱖲", desc = "Prev WORD" },
			{',',            icon = "󱖳", desc = "Repeat motion"},
			{"n",            icon = "󱖳", desc = "Repeat motion"},
			{';',            icon = "󱖳", desc = "Repeat motion reverse"},
			{"N",            icon = "󱖳", desc = "Repeat motion reverse"},
			{"l",            icon = "→", desc = "Right" },
			{'#',            icon = "", desc = "Search word"},
			{'*',            icon = "", desc = "Search word reverse"},
			{'"',            icon = "󰅍", desc = "Select register"},
			{"0",            icon = "󱖲", desc = "Start of line" },
			{"k",            icon = "↑", desc = "Up" },
			{'&',            icon = "ℜ", desc = "Repeat Substitution"},
			{'Y',            desc = "Yank to EOL"},
			{'<C-d>',        desc = "Half Page Down"},
			{"<C-f>",        desc = "Page down" },
			{'<C-b>',        desc = "Page Up"},
			{'<leader>f',    icon = "󰭎", group = "Telescope"},
			{'<leader>g',    icon = "", group = "Git"},
			{'<leader>l',    icon = "", group = "LSP"},
			{'<leader>o',    icon = "󰏇", group = "Oil files"},
			{'<leader>s',    icon = "", group = "DataBase"},
			{'<leader>t',    icon = "󰓩", group = "Tabs"},
			{'<leader>u',    icon = "", group = "UI"},
			{ "g=", desc = "mini-operators evaluate" },
			{ "gm", desc = "mini-operators multiply" },
			{ "ss", desc = "mini-operators exchange" },
			{ "sp", desc = "mini-operators replace with register" },
			{ "sx", desc = "mini-operators sort text" },
		}

		require('which-key').add(_G.wk.config)
	end,
}
