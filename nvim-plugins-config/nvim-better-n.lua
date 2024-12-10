require('lze').load {
	'mini.bracketed',
	dep_of = "nvim-better-n",
}

require('lze').load {
	'nvim-better-n',
	event = "DeferredUIEnter",
	keys = {
		{"n"}, {"<s-n>"}, {","}, {";"},
		{ "*", mode = { "n", "x" } },
		{ "#", mode = { "n", "x" } },
		{ "]d", mode = { "n", "x" } }, { "]d", mode = { "n", "x" } },
		{ "]D", mode = { "n", "x" } }, { "]D", mode = { "n", "x" } },
		{ "]x", mode = { "n", "x" } }, { "]x", mode = { "n", "x" } },
		{ "]X", mode = { "n", "x" } }, { "]X", mode = { "n", "x" } },
		{ "]b", mode = { "n", "x" } }, { "]b", mode = { "n", "x" } },
		{ "]B", mode = { "n", "x" } }, { "]B", mode = { "n", "x" } },
		{ "]f", mode = { "n", "x" } }, { "]f", mode = { "n", "x" } },
		{ "]F", mode = { "n", "x" } }, { "]F", mode = { "n", "x" } },
		{ "]j", mode = { "n", "x" } }, { "]j", mode = { "n", "x" } },
		{ "]J", mode = { "n", "x" } }, { "]J", mode = { "n", "x" } },
		{ "]l", mode = { "n", "x" } }, { "]l", mode = { "n", "x" } },
		{ "]L", mode = { "n", "x" } }, { "]L", mode = { "n", "x" } },
		{ "]o", mode = { "n", "x" } }, { "]o", mode = { "n", "x" } },
		{ "]O", mode = { "n", "x" } }, { "]O", mode = { "n", "x" } },
		{ "]q", mode = { "n", "x" } }, { "]q", mode = { "n", "x" } },
		{ "]Q", mode = { "n", "x" } }, { "]Q", mode = { "n", "x" } },
		{ "]t", mode = { "n", "x" } }, { "]t", mode = { "n", "x" } },
		{ "]T", mode = { "n", "x" } }, { "]T", mode = { "n", "x" } },
		{ "]u", mode = { "n", "x" } }, { "]u", mode = { "n", "x" } },
		{ "]U", mode = { "n", "x" } }, { "]U", mode = { "n", "x" } },
		{ "]w", mode = { "n", "x" } }, { "]w", mode = { "n", "x" } },
		{ "]W", mode = { "n", "x" } }, { "]W", mode = { "n", "x" } },
		{ "]y", mode = { "n", "x" } }, { "]y", mode = { "n", "x" } },
		{ "]y", mode = { "n", "x" } }, { "]y", mode = { "n", "x" } },
		{ "]i", mode = { "n", "x" } }, { "]i", mode = { "n", "x" } },
		{ "]I", mode = { "n", "x" } }, { "]I", mode = { "n", "x" } },
		{ "]h", mode = { "n", "x" } }, { "]h", mode = { "n", "x" } },
		{ "]H", mode = { "n", "x" } }, { "]H", mode = { "n", "x" } },
		{ "]s", mode = { "n", "x" } }, { "]s", mode = { "n", "x" } },
		{ "]S", mode = { "n", "x" } }, { "]S", mode = { "n", "x" } },
		{ "]c", mode = { "n", "x" } }, { "]c", mode = { "n", "x" } },
		{ "]C", mode = { "n", "x" } }, { "]C", mode = { "n", "x" } },
	},
	after = function ()
		local better_n = require("better-n")
		better_n.setup { disable_default_mappings = true }

		better_n.create({ key = "/", next = "n", previous = "<s-n>" })
		local asterisk = better_n.create({ key = "*", next = "n", previous = "<s-n>" })
		vim.keymap.set({ "n", "x" }, "*", asterisk.passthrough, { expr = true, silent = true })

		local hash = better_n.create({ key = "#", next = "n", previous = "<s-n>" })
		vim.keymap.set({ "n", "x" }, "#", hash.passthrough, { expr = true, silent = true })

		local bracketed_override = function(key, name, desc_name)
			local bracket = require('mini.bracketed')
			bracket.setup {
				diagnostic = { options = { severity = vim.diagnostic.severity.ERROR } },
			}

			local nav = better_n.create {
				next = function() bracket[name]('forward') end,
				previous = function() bracket[name]('backward') end,
			}

			vim.keymap.set({ "n", "x" }, "]" .. key,               nav.next,                              { desc = desc_name .. " forward"})
			vim.keymap.set({ "n", "x" }, "[" .. key,               nav.previous,                          { desc = desc_name .. " backward"})
			vim.keymap.set({ "n", "x" }, "]" .. string.upper(key), function() bracket[name]('last')  end, { desc = desc_name .. " last"})
			vim.keymap.set({ "n", "x" }, "[" .. string.upper(key), function() bracket[name]('first') end, { desc = desc_name .. " first"})
		end
		local bracketed_list = {
			{ "d", "diagnostic", "Diagnostic" },
			{ "x", "conflict",   "Conflict"},
			{ "b", "buffer",     "Buffer" },
			{ "f", "file",       "File" },
			{ "j", "jump",       "Jump" },
			{ "l", "location",   "Loclist" },
			{ "o", "oldfile",    "Oldfile" },
			{ "q", "quickfix",   "Quickfix" },
			{ "t", "treesitter", "Treesitter node" },
			{ "u", "undo",       "Undo" },
			{ "w", "window",     "Window" },
			{ "y", "yank",       "Yank" },
		}

		for _, v in ipairs(bracketed_list) do
			bracketed_override(unpack(v))
		end

		local normal_override = function(key, fn_next, fn_prev, desc)
			local nav = better_n.create {
				next = fn_next,
				previous = fn_prev,
			}

			vim.keymap.set({ "n", "x" }, "]" .. key, nav.next,     { desc = "next " .. desc})
			vim.keymap.set({ "n", "x" }, "[" .. key, nav.previous, { desc = "previous " .. desc})
		end

		local normal_list = {
			{ "i",
				function() require('mini.indentscope').operator("top", true) end,
				function() require('mini.indentscope').operator("bottom", true) end, "Indent"
			},
			{ "h",
				function() require('gitsigns').nav_hunk("next") end,
				function() require('gitsigns').nav_hunk("prev") end, "Hunk"
			},
			{ "s",
				function() vim.cmd "norm! ]s" end,
				function() vim.cmd "norm! [s" end, "misspelled word"
			},
			{ "c",
				function() vim.cmd "norm! ]c" end,
				function() vim.cmd "norm! [c" end, "diff"
			},
		}
		for _, v in ipairs(normal_list) do
			normal_override(unpack(v))
		end
		-- I prefer to use , and ;
		vim.keymap.set({ "n", "x" }, "n", better_n.next, { expr = true, silent = true, nowait = true })
		vim.keymap.set({ "n", "x" }, "<s-n>", better_n.previous, { expr = true, silent = true, nowait = true })
		vim.keymap.set({ "n", "x"}, ",", better_n.next,     { expr = true, silent = true, nowait = true })
		vim.keymap.set({ "n", }, ";", better_n.previous, { expr = true, silent = true, nowait = true })
	end
}

